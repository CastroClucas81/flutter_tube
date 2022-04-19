import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoScreen extends StatelessWidget {
  final String videoId;

  const VideoScreen({Key? key, required this.videoId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    YoutubePlayerController _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Vídeo"),
          centerTitle: true,
          backgroundColor: Colors.black87,
        ),
        backgroundColor: Colors.black87,
        body: Container(
          padding: const EdgeInsets.all(4.0),
          width: double.infinity,
          height: 300.0,
          child: YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: true,
            progressIndicatorColor: Colors.red,
            progressColors: const ProgressBarColors(
              playedColor: Colors.amber,
              handleColor: Colors.amberAccent,
            ),
          ),
        ),
      ),
    );
  }
}
