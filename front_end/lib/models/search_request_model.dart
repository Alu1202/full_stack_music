class SearchRequestModel {
  SearchRequestModel({
    this.minYearRange,
    this.maxYearRange,
    this.popularity,
    this.trackName,
    this.artistName,
    this.duration,
  });

  String? artistName;
  int? duration;
  double? popularity;
  String? trackName;
  double? minYearRange,maxYearRange;

  void reset() {
    minYearRange = null;
    popularity = null;
    trackName = null;
    artistName = null;
    duration = null;
    maxYearRange = null;
  
  }

  Map<String, String> toFilterMap() {
    final Map<String, String> filterMap = {};
    if (minYearRange != null) filterMap['startYear'] = minYearRange!.floor().toString();
    if (maxYearRange != null) filterMap['endYear'] = maxYearRange!.floor().toString();
    if (popularity != null) filterMap['popularity'] = popularity.toString();
    if (trackName != null) filterMap['trackName'] = trackName.toString();
    if (artistName != null) filterMap['artistName'] = artistName.toString();
    if (duration != null) filterMap['duration'] = (duration!*1000).toString();
   
    return filterMap;
  }
}
