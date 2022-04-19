import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tube/blocs/favorite_bloc.dart';
import 'package:flutter_tube/blocs/videos_bloc.dart';
import 'package:flutter_tube/delegates/data_search.dart';
import 'package:flutter_tube/models/video.dart';
import 'package:flutter_tube/screens/favorites_screen.dart';
import 'package:flutter_tube/widgets/video_tile.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Container(
              height: 30.0,
              child: Image.network(
                  "https://www.seekpng.com/png/full/124-1245971_inscreva-se-em-nosso-canal-youtube-logo-png.png")),
          elevation: 0,
          backgroundColor: Colors.black87,
          actions: [
            Align(
              alignment: Alignment.center,
              child: StreamBuilder<Map<String, VideoModel>>(
                stream: BlocProvider.getBloc<FavoriteBloc>().outFav,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                      "${snapshot.data!.length}",
                      style: const TextStyle(
                        fontSize: 18.0,
                      ),
                    );
                  }

                  return Container();
                },
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const FavoritesScreen(),
                  ),
                );
              },
              icon: const Icon(
                Icons.star,
              ),
            ),
            IconButton(
              onPressed: () async {
                String? result = await showSearch(
                  context: context,
                  delegate: DataSearch(),
                );

                if (result != null) {
                  BlocProvider.getBloc<VideosBloc>().inSearch.add(result);
                }
              },
              icon: const Icon(
                Icons.search,
              ),
            )
          ],
        ),
        backgroundColor: Colors.black87,
        body: StreamBuilder(
          initialData: [],
          stream: BlocProvider.getBloc<VideosBloc>().outVideos,
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length + 1,
                itemBuilder: (context, index) {
                  if (index < snapshot.data!.length) {
                    return VideoTile(
                      video: snapshot.data[index],
                    );
                  } else if (index > 0) {
                    BlocProvider.getBloc<VideosBloc>().inSearch.add(null);

                    return Container(
                      height: 40.0,
                      width: 40.0,
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
