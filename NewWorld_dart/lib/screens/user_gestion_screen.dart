import 'package:flutter/material.dart';
import 'package:newworld/services/user_preferences.dart';
import 'package:newworld/models/user.dart';

class YoutubeVideoScreen extends StatefulWidget {
  final String videoId;

  const YoutubeVideoScreen({Key? key, required this.videoId}) : super(key: key);

  @override
  _YoutubeVideoScreenState createState() => _YoutubeVideoScreenState();
}

class _YoutubeVideoScreenState extends State<YoutubeVideoScreen> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      params: const YoutubePlayerParams(
        showControls: true,
        mute: false,
        showFullscreenButton: true,
        loop: false,
      ),
    )..loadVideoById(videoId: widget.videoId);

    _controller.setFullScreenListener(
      (isFullScreen) {
        print('${isFullScreen ? 'Entered' : 'Exited'} Fullscreen.');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerScaffold(
      controller: _controller,
      builder: (context, player) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Youtube Video'),
            backgroundColor: UserPreferences().netflimColor,
            foregroundColor: UserPreferences().mainTextColor,
          ),
          body: player,
          backgroundColor: UserPreferences().backgroundColor,
        );
      },
    );
  }
}
