import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tube/api.dart';
import 'package:flutter_tube/blocs/favorite_bloc.dart';
import 'package:flutter_tube/models/video.dart';
import 'package:flutter_tube/screens/video_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Favoritos"),
          centerTitle: true,
          backgroundColor: Colors.black87,
        ),
        backgroundColor: Colors.black87,
        body: StreamBuilder<Map<String, VideoModel>>(
          stream: BlocProvider.getBloc<FavoriteBloc>().outFav,
          initialData: {},
          builder: (context, snapshot) {
            return ListView(
              children: snapshot.data!.values.map(
                (v) {
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => VideoScreen(videoId: v.id),
                        ),
                      );
                    },
                    onLongPress: () {
                      BlocProvider.getBloc<FavoriteBloc>().toggleFavorite(v);
                    },
                    child: Row(
                      children: [
                        SizedBox(
                          width: 100.0,
                          height: 50.0,
                          child: Image.network(v.thumb),
                        ),
                        Expanded(
                          child: Text(
                            v.title,
                            maxLines: 2,
                            style: const TextStyle(
                              color: Colors.white70,
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
              ).toList(),
            );
          },
        ),
      ),
    );
  }
}
