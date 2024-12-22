import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:kpi_demo/models/filter_model.dart';
import 'dart:convert';

import '../../models/track.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Api {
  static final String baseUrl = Platform.isAndroid
      ? dotenv.env['BASE_URL'] ?? 'localhost:3000'
      : 'localhost:3000';

  static Future<List<Track>> fetchTracks({
    required Map<String, dynamic> filterMap,
  }) async {
    final uri = Uri.http(baseUrl, '/api/search', filterMap);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final data = jsonData['data'] as List;
      final List<Track> tracks = [];
      for (var track in data) {
        try {
          tracks.add(Track.fromJson(track));
        } catch (_) {}
      }
      return tracks;
    } else {
      throw Exception('Failed to load data');
    }
  }

  static Future<FilterModel> fetchFilters() async {
    final uri = Uri.http(baseUrl, '/api/statistics');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return FilterModel.fromJson(data);
    } else {
      throw Exception('Failed to load filters');
    }
  }
}
