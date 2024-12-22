import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:kpi_demo/models/filter_model.dart';
import 'package:kpi_demo/models/search_request_model.dart';
import 'package:path_provider/path_provider.dart';

import '../../models/track.dart';
import '../repository/api.dart';

part 'kpi_dashboard_state.dart';

class KpiDashboardCubit extends Cubit<KpiDashboardState> {
  KpiDashboardCubit() : super(KpiDashboardInitial()) {
    fetchFilters();
    fetchData();
  }

  String? trackName, artistName;
  final TextEditingController artistNameController = TextEditingController();
  int? duration;
  final durationList = List.generate(20, (index) => (index + 1) * 20);
  FilterData? filterData;
  double? popularity;
  final TextEditingController trackNameController = TextEditingController();
  final List<Track> tracks = [];
  double? yearRange;

  Future<void> fetchFilters() async {
    try {
      await Api.fetchFilters().then((filterModel) {
        filterData = filterModel.data;
        emit(KpiFiltersLoaded());
      });
    } on Exception catch (e) {
      emit(KpiDashboardError(e));
    }
  }

  Future<void> fetchData() async {
    emit(KpiDashboardLoading());
    try {
      final filterMap = SearchRequestModel(
        yearRange: yearRange,
        popularity: popularity,
        trackName: track,
        artistName: artist,
        duration: duration,
      );
      await Api.fetchTracks(
        filterMap: filterMap.toFilterMap(),
      ).then((value) {
        tracks
          ..clear()
          ..addAll(value);
      });
      emit(KpiDashboardDataLoaded(
        data: tracks,
      ));
    } on Exception catch (e) {
      emit(KpiDashboardError(e));
    }
  }

  String? get artist {
    return artistName = artistNameController.text;
  }

  String get track {
    return trackName = trackNameController.text;
  }

  void updateYearRange(double? yearRange) {
    this.yearRange = yearRange;
    emit(
      KpiDashboardSliderUpdated(
        popularity: popularity ?? filterData?.minPopularity.toDouble() ?? 0.0,
        yearRange: this.yearRange ?? 0,
      ),
    );
  }

  void updatePopularity(double? popularity) {
    this.popularity = popularity;
    emit(
      KpiDashboardSliderUpdated(
        popularity:
            this.popularity ?? filterData?.minPopularity.toDouble() ?? 0.0,
        yearRange: yearRange ?? filterData?.minYear.toDouble() ?? 0.0,
      ),
    );
  }

  void updateTrackName(String? trackName) {
    trackNameController.text = trackName ?? '';
  }

  void updateArtistName(String? artistName) {
    artistNameController.text = artistName ?? '';
  }

  void updateDuration(int? duration) {
    this.duration = duration;
    emit(DurationChanged());
  }

  void resetAndSearch() async {
    duration = null;
    yearRange = null;
    popularity = null;
    trackName = null;
    artistName = null;
    duration = null;
    emit(KpiFiltersLoaded());
    emit(DurationChanged());
    trackNameController.clear();
    artistNameController.clear();
    await fetchData();
  }

  Future<String> exportToCsv() async {
    String filePath = '';
    final csvData = [
      ['Track ID', 'Track Name', 'Artists', 'Year', 'Duration', 'Popularity'],
      ...tracks.map((track) => [
            track.trackId,
            track.trackName,
            track.artists,
            track.year.toString(),
            track.duration,
            track.popularity.toString(),
          ])
    ];
    final csv = const ListToCsvConverter().convert(csvData);
    final iosPath = await getApplicationDocumentsDirectory();

    final path = Platform.isIOS
        ? '${iosPath.path}/tracks.csv'
        : '/storage/emulated/0/Download/tracks_02.csv';

    final file = File(path);

    if (await file.exists()) {
      await file.delete();
    }
    await file.writeAsString(csv).then((value) {
      filePath = value.path;
    }).onError((error, stackTrace) {});

    return filePath;
  }

  @override
  Future<void> close() {
    artistNameController.dispose();
    trackNameController.dispose();

    return super.close();
  }
}
