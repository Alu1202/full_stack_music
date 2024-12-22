class SearchRequestModel {
  SearchRequestModel({
    this.yearRange,
    this.popularity,
    this.trackName,
    this.artistName,
    this.duration,
  });

  String? artistName;
  int? duration;
  double? popularity;
  String? trackName;
  double? yearRange;

  void reset() {
    yearRange = null;
    popularity = null;
    trackName = null;
    artistName = null;
    duration = null;
  }

  Map<String, String> toFilterMap() {
    final Map<String, String> filterMap = {};
    if (yearRange != null) filterMap['yearRange'] = yearRange.toString();
    if (popularity != null) filterMap['popularity'] = popularity.toString();
    if (trackName != null) filterMap['trackName'] = trackName.toString();
    if (artistName != null) filterMap['artistName'] = artistName.toString();
    if (duration != null) filterMap['duration'] = (duration!*1000).toString();
    return filterMap;
  }
}
