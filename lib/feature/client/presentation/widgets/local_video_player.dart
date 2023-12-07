import 'dart:async';
import 'dart:html' as html;
import 'dart:typed_data';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:workoneerweb/configs/app_colors.dart';

class LocalVideoPlayer extends StatefulWidget {
  final Uint8List path;

  const LocalVideoPlayer(this.path, {Key? key}) : super(key: key);

  @override
  State<LocalVideoPlayer> createState() => _VideoDialogState();
}

class _VideoDialogState extends State<LocalVideoPlayer> {
  late VideoPlayerController videoPlayerController;

  late ChewieController chewieController;

  @override
  void initState() {
    super.initState();

    final blob = html.Blob([widget.path]);
    final url = html.Url.createObjectUrlFromBlob(blob);


    videoPlayerController = VideoPlayerController.network(url);

    initiatePlayer();
    chewieController = ChewieController(
        videoPlayerController: videoPlayerController,
        autoInitialize: true,
        allowFullScreen: false,
        materialProgressColors: ChewieProgressColors(
            playedColor: AppColors.primaryColor,
            backgroundColor: Colors.white,
            bufferedColor: AppColors.primaryColor.withOpacity(0.5),
            handleColor: AppColors.green));
    setState(() {});
  }

  FutureOr<void> initiatePlayer() async {
    await videoPlayerController.initialize();
    setState(() {});
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        alignment: Alignment.topLeft,
        children: [
          Container(
            margin: const EdgeInsets.all(20),
            child: chewieController.videoPlayerController.value.isInitialized
                ? Chewie(
              controller: chewieController,
            )
                : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text("Loading"),
                ],
              ),
            ),
          ),

          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.cancel_outlined,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}