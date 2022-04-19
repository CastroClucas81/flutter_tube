import 'dart:async';
import 'dart:convert';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter_tube/models/video.dart';
import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteBloc implements BlocBase {
  late Map<String, VideoModel> _favorites = {};

  final _favController =
      BehaviorSubject<Map<String, VideoModel>>();

  Stream<Map<String, VideoModel>> get outFav => _favController.stream;

  FavoriteBloc() {
    SharedPreferences.getInstance().then((prefs) {
      if (prefs.getKeys().contains("favorites")) {
        _favorites =
            jsonDecode(prefs.getString("favorites") as String).map((k, v) {
          return MapEntry(k, VideoModel.fromJson(v));
        }).cast<String, VideoModel>();

        _favController.add(_favorites);
      }
    });
  }

  void toggleFavorite(VideoModel video) {
    if (_favorites.containsKey(video.id)) {
      _favorites.remove(video.id);
    } else {
      _favorites[video.id] = video;
    }

    _favController.sink.add(_favorites);

    _saveFav();
  }

  void _saveFav() {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString("favorites", jsonEncode(_favorites));
    });
  }

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  void dispose() {}
}
