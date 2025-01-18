import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kpi_demo/constants/labels.dart';
import 'package:kpi_demo/error/error_screen.dart';
import 'package:kpi_demo/models/filter_model.dart';
import 'package:open_filex/open_filex.dart';
import 'package:permission_handler/permission_handler.dart';

import '../cubit/kpi_dashboard_cubit.dart';

class KpiDashboardScreen extends StatelessWidget {
  const KpiDashboardScreen({super.key});

  Widget _buildSearchForm(BuildContext context) {
    return Builder(
      builder: (context) {
        final cubit = context.read<KpiDashboardCubit>();

        return Column(
          children: [
            Text(
              Labels.searchForm,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            BlocBuilder<KpiDashboardCubit, KpiDashboardState>(
              buildWhen: (previous, current) => current is KpiFiltersLoaded,
              builder: (context, state) {
                final filterData = context.read<KpiDashboardCubit>().filterData;

                if (filterData != null) {
                  return Column(
                    children: [
                      YearRangeDragger(
                        filterData: filterData,
                      ),
                      PopularityDragger(
                        filterData: filterData,
                      ),
                    ],
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
            TextField(
              controller: context.read<KpiDashboardCubit>().trackNameController,
              decoration: const InputDecoration(
                labelText: Labels.trackName,
              ),
              onChanged: (value) {
                context.read<KpiDashboardCubit>().updateTrackName(value);
              },
            ),
            TextField(
              controller:
                  context.read<KpiDashboardCubit>().artistNameController,
              decoration: const InputDecoration(
                labelText: Labels.artistName,
              ),
              onChanged: (value) {
                context.read<KpiDashboardCubit>().updateArtistName(value);
              },
            ),
            const SizedBox(height: 10),
            BlocBuilder<KpiDashboardCubit, KpiDashboardState>(
              buildWhen: (previous, current) => current is DurationChanged,
              builder: (context, state) {
                return DropdownButton<int>(
                  dropdownColor: Colors.grey[800],
                  menuMaxHeight: MediaQuery.of(context).size.height * 0.3,
                  value: context.read<KpiDashboardCubit>().duration,
                  isExpanded: true,
                  hint: const Text(
                    Labels.selectDuration,
                  ),
                  items: context
                      .read<KpiDashboardCubit>()
                      .durationList
                      .map((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text('< $value sec'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    context.read<KpiDashboardCubit>().updateDuration(value!);
                  },
                );
              },
            ),
            const SizedBox(height: 20),
            BlocBuilder<KpiDashboardCubit, KpiDashboardState>(
              builder: (context, state) {
                final hasData =
                    state is KpiDashboardDataLoaded && state.data.isNotEmpty;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        cubit.fetchData();
                      },
                      child: const Row(
                        children: [
                          Icon(Icons.search),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            'Search',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    if (!hasData ||
                        BlocProvider.of<KpiDashboardCubit>(context)
                                .maxYearRange !=
                            null ||
                        BlocProvider.of<KpiDashboardCubit>(context)
                                .minPopularity !=
                            null)
                      TextButton(
                        onPressed: () {
                          cubit.resetAndSearch();
                        },
                        child: const Text('Reset And Search'),
                      ),
                  ],
                );
              },
            )
          ],
        );
      },
    );
  }

  Widget _buildLabelsSection() {
    return BlocBuilder<KpiDashboardCubit, KpiDashboardState>(
      builder: (context, state) {
        if (state is KpiDashboardDataLoaded) {
          return Row(
            children: [
              Expanded(
                child: _buildLabelColumn(
                    Labels.uniqueTrackCount,
                    state.data
                        .map((track) => track.trackId)
                        .toSet()
                        .length
                        .toString()),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: _buildLabelColumn(
                    Labels.uniqueArtistCount,
                    state.data
                        .map((track) => track.trackName)
                        .toSet()
                        .length
                        .toString()),
              ),
            ],
          );
        }
        return Row(
          children: [
            Expanded(
              child: _buildLabelColumn(
                Labels.uniqueTrackCount,
                '0',
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _buildLabelColumn(
                Labels.uniqueArtistCount,
                '0',
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLabelColumn(String label, String value) {
    return Container(
      color: const Color.fromARGB(255, 1, 111, 5).withOpacity(0.7),
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            maxLines: 1,
          ),
          Container(
            width: double.maxFinite,
            color: const Color.fromARGB(255, 61, 100, 62),
            padding: const EdgeInsets.all(8.0),
            child: Text(value),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => KpiDashboardCubit(),
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(Labels.kpiDashboard),
            centerTitle: false,
            actions: [
              _buildDownloadButton(context),
            ],
          ),
          body: BlocListener<KpiDashboardCubit, KpiDashboardState>(
            listener: (context, state) async {
              if (state is KpiDashboardError) {
                await Navigator.of(context)
                    .push<bool>(MaterialPageRoute(
                  builder: (context) => ErrorScreen(state.exception),
                ))
                    .then((value) {
                  if (value ?? false) {
                    context.read<KpiDashboardCubit>()
                      ..fetchFilters()
                      ..fetchData();
                  }
                });
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return ConstrainedBox(
                    constraints: constraints,
                    child: Column(
                      children: [
                        ExpansionTile(
                          tilePadding: EdgeInsets.zero,
                          title: const Text('Search Filters'),
                          children: [
                            _buildSearchForm(context),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _buildLabelsSection(),
                        const SizedBox(height: 20),
                        const Expanded(
                          child: AlbumListView(),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        );
      }),
    );
  }
}

class AlbumListView extends StatelessWidget {
  const AlbumListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<KpiDashboardCubit, KpiDashboardState>(
      buildWhen: (previous, current) =>
          current is KpiDashboardDataLoaded || current is KpiDashboardLoading,
      builder: (context, state) {
        if (state is KpiDashboardDataLoaded && state is! KpiDashboardLoading) {
          return Scrollbar(
            child: ListView.builder(
              padding: const EdgeInsets.only(right: 12),
              itemCount: state.data.length,
              itemBuilder: (context, index) {
                final track = state.data[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    leading: const Icon(Icons.music_note_outlined, size: 30),
                    title: Text(
                      '${track.trackName} (${track.year})',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      'Duration: ${track.duration}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.favorite_outlined, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          track.popularity.toString(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

Future<bool> _requestPermission() async {
  if (Platform.isIOS) {
    return true;
  }
  if (await Permission.manageExternalStorage.isGranted) {
    return true;
  } else {
    final result = await Permission.manageExternalStorage.request();
    if (result.isGranted) {
      return true;
    } else if (result.isDenied || result.isPermanentlyDenied) {
      openAppSettings();
      return false;
    }
    return false;
  }
}

Widget _buildDownloadButton(BuildContext context) {
  return TextButton(
    onPressed: () async {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Dialog(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(width: 20),
                  Text("Downloading..."),
                ],
              ),
            ),
          );
        },
      );
      await _requestPermission().then((value) async {
        if (value) {
          final cubit = context.read<KpiDashboardCubit>();
          await cubit.exportToCsv().then((value) {
            if (value.isNotEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(Labels.exportSuccessMessage),
                      const SizedBox(width: 8),
                      TextButton(
                        onPressed: () async {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          await OpenFilex.open(value);
                        },
                        child: const Row(
                          children: [
                            Icon(Icons.open_in_new),
                            Text(
                              'Open',
                              style: TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(Labels.exportErrorMessage),
                ),
              );
            }
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(Labels.permissionErrorMessage),
            ),
          );
        }
      }).whenComplete(() {
        Navigator.of(context).pop();
      });
    },
    child: const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(Labels.downloadCsv),
        SizedBox(width: 8),
        Icon(Icons.download, size: 18),
      ],
    ),
  );
}
// Use this for Detail CSV View
class TabularSheet extends StatelessWidget {
  const TabularSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDownloadButton(context),
              BlocBuilder<KpiDashboardCubit, KpiDashboardState>(
                buildWhen: (previous, current) =>
                    current is KpiDashboardDataLoaded ||
                    current is KpiDashboardLoading,
                builder: (context, state) {
                  if (state is KpiDashboardDataLoaded &&
                      state is! KpiDashboardLoading) {
                    return Scrollbar(
                      scrollbarOrientation: ScrollbarOrientation.top,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: DataTable(
                            headingRowColor: MaterialStatePropertyAll(
                                Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.5)),
                            columns: const [
                              DataColumn(label: Text(Labels.trackId)),
                              DataColumn(label: Text(Labels.trackNameColumn)),
                              DataColumn(label: Text('Artists')),
                              DataColumn(label: Text(Labels.year)),
                              DataColumn(label: Text(Labels.duration)),
                              DataColumn(label: Text('Popularity')),
                            ],
                            rows: state.data.map<DataRow>((track) {
                              return DataRow(cells: [
                                DataCell(
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.15,
                                    child: Text(
                                      track.trackId,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.35,
                                    child: Text(
                                      track.trackName,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.35,
                                    child: Text(
                                      track.artists,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.15,
                                    child: Text(
                                      track.year.toString(),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.15,
                                    child: Text(
                                      track.duration,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.15,
                                    child: Text(
                                      track.popularity.toString(),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ]);
                            }).toList(),
                          ),
                        ),
                      ),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PopularityDragger extends StatelessWidget {
  const PopularityDragger({super.key, required this.filterData});

  final FilterData filterData;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          Labels.popularity,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text('${filterData.minPopularity}'),
            ),
            Expanded(
              flex: 8,
              child: BlocBuilder<KpiDashboardCubit, KpiDashboardState>(
                buildWhen: (previous, current) =>
                    current is KpiDashboardSliderUpdated,
                builder: (context, state) {
                  return Slider(
                    value: context.read<KpiDashboardCubit>().minPopularity ??
                        filterData.minPopularity.toDouble(),
                    min: filterData.minPopularity.toDouble(),
                    max: filterData.maxPopularity.toDouble(),
                    divisions:
                        filterData.maxPopularity - filterData.minPopularity,
                    label:
                        '${context.read<KpiDashboardCubit>().minPopularity?.toInt() ?? filterData.minPopularity}',
                    onChanged: (value) {
                      context.read<KpiDashboardCubit>().updatePopularity(value);
                    },
                  );
                },
              ),
            ),
            Expanded(
              child: Text('${filterData.maxPopularity}'),
            ),
          ],
        ),
      ],
    );
  }
}

class YearRangeDragger extends StatelessWidget {
  const YearRangeDragger({super.key, required this.filterData});

  final FilterData filterData;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          Labels.year,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text('${filterData.minYear}'),
            ),
            Expanded(
              flex: 8,
              child: BlocBuilder<KpiDashboardCubit, KpiDashboardState>(
                buildWhen: (previous, current) =>
                    current is KpiDashboardSliderUpdated,
                builder: (context, state) {
                  return RangeSlider(
                    values: RangeValues(
                        context.read<KpiDashboardCubit>().minYearRange ??
                            filterData.minYear.toDouble(),
                        context.read<KpiDashboardCubit>().maxYearRange ??
                            filterData.maxYear.toDouble()),
                    min: filterData.minYear.toDouble(),
                    max: filterData.maxYear.toDouble(),
                    divisions: filterData.maxYear - filterData.minYear,
                    labels: RangeLabels(
                      '${context.read<KpiDashboardCubit>().minYearRange?.toInt() ?? filterData.minYear}',
                      '${context.read<KpiDashboardCubit>().maxYearRange?.toInt() ?? filterData.maxYear}',
                    ),
                    onChanged: (value) {
                      context.read<KpiDashboardCubit>().updateYearRange(value);
                    },
                  );
                },
              ),
            ),
            Expanded(
              child: Text('${filterData.maxYear}'),
            ),
          ],
        ),
      ],
    );
  }
}
