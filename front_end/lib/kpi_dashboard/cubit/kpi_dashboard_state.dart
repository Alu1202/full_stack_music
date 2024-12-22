part of 'kpi_dashboard_cubit.dart';

@immutable
sealed class KpiDashboardState {}

final class KpiDashboardInitial extends KpiDashboardState {}

final class KpiFiltersLoaded extends KpiDashboardState {}

final class KpiDashboardLoading extends KpiDashboardState {}

final class KpiFiltersLoading extends KpiDashboardState {}

final class KpiDashboardDataLoaded extends KpiDashboardState {
  final List<Track> data;

  KpiDashboardDataLoaded({
    required this.data,
  });
}

final class KpiDashboardError extends KpiDashboardState {
  final Exception exception;

  KpiDashboardError(this.exception);
}

final class KpiDashboardSliderUpdated extends KpiDashboardState {
  final double popularity;
  final double yearRange;

  KpiDashboardSliderUpdated({
    required this.popularity,
    required this.yearRange,
  });
}

final class DurationChanged extends KpiDashboardState {
 
}
