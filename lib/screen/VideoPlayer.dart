import 'package:chewie/chewie.dart';
import 'package:external_video_player_launcher/external_video_player_launcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:video_player/video_player.dart';
import 'package:keep_screen_on/keep_screen_on.dart';

class VideoPlayer extends StatefulWidget {
  final String url;
  final String? refer;
  final String title;
  final String time;
  final String mx_player_link;

  const VideoPlayer(
      {super.key,
      required this.url,
      this.refer,
      required this.title,
      required this.time,
      required this.mx_player_link});

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  late ChewieController chewieController;
  late VideoPlayerController videoPlayerController;
  final spin = Container(
    color: Colors.black,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: SpinKitCircle(
            size: 60.0,
            duration: const Duration(seconds: 2),
            itemBuilder: (BuildContext context, int index) {
              final colors = [
                Colors.white,
                Colors.pink,
                Colors.yellow,
                Colors.blue
              ];
              final color = colors[index % colors.length];
              return DecoratedBox(
                  decoration:
                      BoxDecoration(color: color, shape: BoxShape.rectangle));
            },
          ),
        ),
        const Text("Loading...",
            style: TextStyle(color: Colors.white, fontSize: 12))
      ],
    ),
  );
  @override
  void initState() {
    videoChewieController();
    KeepScreenOn.turnOn();
    super.initState();
  }

  videoChewieController() {
    late String agent =
        "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.3578.99 Safari/537.36";
    if (widget.refer != '') {
      // ignore: deprecated_member_use
      videoPlayerController = VideoPlayerController.network(
        widget.url,
        httpHeaders: {'Referer': widget.refer.toString(), 'User-Agent': agent},
      );
    } else {
      // ignore: deprecated_member_use
      videoPlayerController = VideoPlayerController.network(
        widget.url,
      );
    }

    // an arbitrary value, this can be whatever you need it to be

    double getScale() {
      double videoContainerRatio = 0.5;
      double videoRatio = videoPlayerController.value.aspectRatio;
      if (videoRatio < videoContainerRatio) {
        return videoContainerRatio / videoRatio;
      } else {
        return videoRatio / videoContainerRatio;
      }
    }

    setState(() {
      chewieController = ChewieController(
          videoPlayerController: videoPlayerController,
          // aspectRatio: getScale(),
          allowedScreenSleep: false,
          autoPlay: true,
          looping: false,
          isLive: false,
          startAt: const Duration(milliseconds: 1),
          showControls: true,
          allowFullScreen: true,
          autoInitialize: true,
          customControls: const CupertinoControls(
            backgroundColor: Colors.black,
            iconColor: Colors.white,
            showPlayButton: false,
          ),
          errorBuilder: (context, errorMessage) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.white,
                      size: 50,
                    ),
                    const Text(
                      "Please Try Again!",
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.grey[900],
                                borderRadius: BorderRadius.circular(5.0)),
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Back",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        GestureDetector(
                          onTap: () {
                            // videoPlayerController.initialize();
                            // chewieController.play();
                            videoChewieController();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.grey[900],
                                borderRadius: BorderRadius.circular(5.0)),
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Retry",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
          placeholder:
              Container(color: Colors.black87, child: Center(child: spin)));
    });
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
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Buu Mal(ဘူးမယ်)",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(children: [
        Expanded(child: Chewie(controller: chewieController)),
        Expanded(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.all(8.0),
                  child: Text(widget.title,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20)),
                ),
                Container(
                  margin: const EdgeInsets.only(
                      top: 4, bottom: 4, right: 8, left: 8),
                  padding: const EdgeInsets.all(8.0),
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10.0),
                          bottomLeft: Radius.circular(10.0))),
                  child: Text(
                    widget.time,
                    style: const TextStyle(color: Colors.black),
                    textAlign: TextAlign.justify,
                  ),
                ),
                Expanded(
                    flex: 2,
                    child: Container(
                      color: Colors.black,
                    ))
              ],
            ))
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ExternalVideoPlayerLauncher.launchMxPlayer(
              widget.mx_player_link, MIME.applicationMp4, {
            "title": widget.title,
          });
        },
        child: const Icon(
          Icons.play_arrow,
          size: 20,
        ),
      ),
    );
  }
}
