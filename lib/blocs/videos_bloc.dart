import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter_tube/api.dart';
import 'package:flutter_tube/models/video.dart';

// sink - entra / stream - sai
class VideosBloc implements BlocBase {
  late Api api;
  late List<VideoModel> videos;

  // os dados apenas saem
  final StreamController<List<VideoModel>> _videosController =
      StreamController<List<VideoModel>>();
  Stream get outVideos => _videosController.stream;

  // os dados apenas entram
  final StreamController<String?> _searchController = StreamController<String?>();
  Sink<String?> get inSearch => _searchController.sink;

  VideosBloc() {
    api = Api();

    _searchController.stream.listen(_search);
  }

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  void _search(search) async {
    if (search != null) {
      _videosController.sink.add([]);
      videos = await api.search(search.toString());
    } else {
      videos += await api.nextPage();
    }

    _videosController.sink.add(videos);
  }

  @override
  void dispose() {
    _videosController.close();
    _searchController.close();
  }
}
