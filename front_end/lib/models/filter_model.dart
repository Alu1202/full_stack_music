class FilterModel {
  FilterModel({required this.success, required this.data});

  factory FilterModel.fromJson(Map<String, dynamic> json) {
    return FilterModel(
      success: json['success'],
      data: FilterData.fromJson(json['data']),
    );
  }

  final FilterData data;
  final bool success;
}

class FilterData {
  FilterData({
    required this.maxYear,
    required this.minYear,
    required this.minPopularity,
    required this.maxPopularity,
  });

  factory FilterData.fromJson(Map<String, dynamic> json) {
    return FilterData(
      maxYear: json['maxYear'],
      minYear: json['minYear'],
      minPopularity: json['minPopularity'],
      maxPopularity: json['maxPopularity'],
    );
  }

  final int maxPopularity;
  final int maxYear;
  final int minPopularity;
  final int minYear;

   FilterData copyWith({
    int? maxYear,
    int? minYear,
    int? minPopularity,
    int? maxPopularity,
  }) {
    return FilterData(
      maxYear: maxYear ?? this.maxYear,
      minYear: minYear ?? this.minYear,
      minPopularity: minPopularity ?? this.minPopularity,
      maxPopularity: maxPopularity ?? this.maxPopularity,
    );
  }
}