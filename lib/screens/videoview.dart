import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';//plugin for playing videos
import '/screens/profile.dart';
import 'package:share_plus/share_plus.dart';
import 'package:gallery_saver/gallery_saver.dart';

class VideoViewPage extends StatefulWidget {
  const VideoViewPage({Key ? key, required  this.path}) : super(key: key);
  final String path;

  @override
  _VideoViewPageState createState() => _VideoViewPageState();
}

class _VideoViewPageState extends State<VideoViewPage> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.path))
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: [
          IconButton(
              icon: Icon(
                Icons.home,
                size: 27,
              ),
              onPressed: () {
                Navigator.push(
                    context,MaterialPageRoute(builder: (context) => ProfileScreen()));

              }),
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - 150,
              child: _controller==null
                  ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
                  : Container(),
            ),
            Positioned(
                bottom: 0,
                child: Container(
                  color: Colors.black38,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                  child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [ElevatedButton(

                    onPressed: () {
                      GallerySaver.saveVideo(widget.path);

                    },
                    child: Icon( //<-- SEE HERE
                      Icons.file_download,
                      color: Colors.white,
                      size: 30,
                    ),
                    style: ElevatedButton.styleFrom(
                        shape: CircleBorder(), //<-- SEE HERE
                        padding: EdgeInsets.all(20),
                        backgroundColor: Colors.amberAccent
                    ),
                  ),
                    ElevatedButton(
                      onPressed: () {
                        Share.shareFiles([widget.path],text: ' ');
                      },
                      child: Icon( //<-- SEE HERE
                        Icons.cloud_upload,
                        color: Colors.white,
                        size: 30,
                      ),
                      style: ElevatedButton.styleFrom(
                          shape: CircleBorder(), //<-- SEE HERE
                          padding: EdgeInsets.all(20),
                          backgroundColor: Colors.amberAccent
                      ),
                    ),
                  ]),
                )),
            Align(
              alignment: Alignment.center,
              child: InkWell(
                onTap: () {
                  setState(() {
                    _controller.value.isPlaying
                        ? _controller.pause()
                        : _controller.play();
                  });
                },
                child: CircleAvatar(
                  radius: 33,
                  backgroundColor: Colors.black38,
                  child: Icon(
                    _controller.value.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
