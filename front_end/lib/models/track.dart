class Track {
  Track({
    required this.trackId,
    required this.trackName,
    required this.artists,
    required this.year,
    required this.duration,
    required this.popularity,
  });

  factory Track.fromJson(Map<String, dynamic> json) {
    return Track(
      trackId: json['track_id'] as String,
      trackName: json['track_name'] as String,
      artists: json['artists'] as String,
      year: (json['year'] as int).toString(),
      duration: json['duration'] as String,
      popularity: (json['popularity'] as int).toString(),
    );
  }

  final String artists;
  final String duration;
  final String popularity;
  final String trackId;
  final String trackName;
  final String year;
}
