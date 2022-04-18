import 'dart:convert';

import 'package:flutter_tube/models/video.dart';
import 'package:http/http.dart' as http;

const API_KEY = "AIzaSyCxUaIpc0eWTHFU-HBEhFo_9C1ocBY59EA";

/*
  https://www.googleapis.com/youtube/v3/search?part=snippet&q=$search&type=video&key=$API_KEY&maxResults=10
  https://www.googleapis.com/youtube/v3/search?part=snippet&q=$_search&type=video&key=$API_KEY&maxResults=10&pageToken=$_nextToken
  http://suggestqueries.google.com/complete/search?hl=en&ds=yt&client=youtube&hjson=t&cp=1&q=$search&format=5&alt=json
*/

class Api {
  late String _search;
  late String _nextToken;

  Future<List<VideoModel>> search(String search) async {
    _search = search;

    http.Response response = await http.get(Uri.parse(
        "https://www.googleapis.com/youtube/v3/search?part=snippet&q=$search&type=video&key=$API_KEY&maxResults=10"));

    return decode(response);
  }

  Future<List<VideoModel>> nextPage() async {
    http.Response response = await http.get(Uri.parse(
        "https://www.googleapis.com/youtube/v3/search?part=snippet&q=$_search&type=video&key=$API_KEY&maxResults=10&pageToken=$_nextToken"));

    return decode(response);
  }

  decode(http.Response response) {
    if (response.statusCode == 200) {
      var decoded = jsonDecode(response.body);

      _nextToken = decoded["nextPageToken"];

      List<VideoModel> videos = decoded["items"].map<VideoModel>((map) {
        return VideoModel.fromJson(map);
      }).toList();

      return videos;
    } else {
      throw Exception("Failed to load videos");
    }
  }
}
