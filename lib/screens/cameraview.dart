import 'dart:io';
import 'package:flutter/material.dart';
import '/screens/profile.dart';
import 'package:share_plus/share_plus.dart';//plugin responsible for sharing photos
import 'package:gallery_saver/gallery_saver.dart'; //plugin resposible for saving photos

class CameraViewPage extends StatelessWidget {
  const CameraViewPage({Key ? key, required this.path}) : super(key: key);
  final String path;
  //class tha takes file path ( image or video) to showw it on screen

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
              child: Image.file(
                File(path),
                fit: BoxFit.cover,
              ),
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
                      GallerySaver.saveImage(path);
                      //download edited photo to gallery

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
                      //share photo on social media or drive
                      Share.shareFiles([path],text: ' ');
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
          ],
        ),
      ),
    );
  }
}