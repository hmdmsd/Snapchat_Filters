import 'dart:io';
import "dart:math" show pi;
import '../widgets/alert.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
//import 'package:camera/camera.dart';
import 'package:camera_deep_ar/camera_deep_ar.dart';
import 'dart:io' as Platform;
import 'package:avatar_view/avatar_view.dart';
import 'package:flutter/services.dart';


import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../widgets/error.dart';
import '../screens/videoview.dart';
import '../screens/cameraview.dart';

DeepArConfig config = const DeepArConfig(
  androidKey:'47fc590129975d4218caa8c4d15c2db8b0a51ba7c163c52b7bd822f9b8cae08e9fdc90ffc4c144aa',
  ioskey: '030405d9baf1883ed4882d78b8a5ac14f687bc19859b99f3e8bef78574886532f625115382e3e314',
  displayMode: DisplayMode.camera,
);

class CameraMasksFilters extends StatefulWidget {
  const CameraMasksFilters({Key? key}) : super(key: key);

  @override
  _CameraMasksFiltersState createState() => _CameraMasksFiltersState();
}

class _CameraMasksFiltersState extends State<CameraMasksFilters> {
  //CameraController? controller;
  final deepArController = CameraDeepArController(config);

  String _platformVersion = 'Unknown';
  String path='';
  String vid='';

  bool isRecording = false;
  CameraMode cameraMode = config.cameraMode;
  DisplayMode displayMode = config.displayMode;
  int currentEffect = 0;
  bool iscamerafront = true;
  bool flash = false;
  double transform = 0;
  bool hover=false;


  String dir='';


  List get effectList {
    switch (cameraMode) {
      case CameraMode.mask:
        dir = 'd1';
        return masks;
      case CameraMode.effect:
        dir ='d2';
        return effects;
      case CameraMode.filter:
        dir = 'd3';
        return filters;
      default:
        dir='d1';
        return masks;
    }
  }

  List masks = [
    "none",
    "assets/aviators",
    "assets/bigmouth",
    "assets/Vendetta_Mask.deepar",
    "assets/viking_helmet.deepar",
    "assets/Neon_Devil_Horns.deepar",
    "assets/flower_face.deepar",
    "assets/Humanoid.deepar"
  ];

  List effects = [
    "none",
    "assets/burning_effect.deepar"
    "assets/8bitHearts.deepar",
    "assets/Hope.deepar",
    "assets/Emotion_Meter.deepar"
  ];
  List filters = [
    "none",
    "assets/drawingmanga",
    "assets/sepia",
    "assets/galaxy_background.deepar",
    "assets/Fire_Effect.deepar",
  ];

  @override
  void initState() {
    super.initState();
    //_controller = CameraDeepArController();
    CameraDeepArController.checkPermissions();
    deepArController.setEventHandler(DeepArEventHandler(onCameraReady: (v) {
      _platformVersion = "onCameraReady $v";
      setState(() {});
    }, onSnapPhotoCompleted: (v) {
      _platformVersion = " $v";

      setState(() {path=v;});
    }, onVideoRecordingComplete: (v) {
      _platformVersion = "onVideoRecordingComplete $v";
      setState(() {path=v;});
    }, onSwitchEffect: (v) {
      _platformVersion = "onSwitchEffect $v";
      setState(() {});
    }));
  }

  @override
  void dispose() {
    deepArController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            DeepArPreview(deepArController),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.all(0),
                //height: 250,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [

                    /*SizedBox(
                      height: 20,
                    ),*/
                    SingleChildScrollView(
                      padding: EdgeInsets.all(10),
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(effectList.length, (p) {
                          bool active = currentEffect == p;
                          String imgPath = effectList[p];
                          return GestureDetector(
                            onTap: () async {
                              if (!deepArController.value.isInitialized) return;
                              currentEffect = p;
                              deepArController.switchEffect(
                                  cameraMode, imgPath);
                              setState(() {});
                            },
                            child: AvatarView(
                              //margin: EdgeInsets.all(6),
                              //width: active ? 70 : 55,
                              //height: active ? 70 : 55,
                              //alignment: Alignment.center,
                              radius: active ? 45 : 20,

                              borderColor:active ? Colors.amber : Colors.white,
                              borderWidth: 3,
                              isOnlyText: false,
                              backgroundColor: Colors.pink[400],
                              imagePath: "assets/${dir}/${p.toString()}.png",

                              placeHolder: Text(
                                "$p",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: active ? FontWeight.bold : null,
                                    fontSize: active ? 16 : 14,
                                    color:
                                    active ? Colors.white : Colors.black),
                              ),
                              /*decoration: BoxDecoration(
                                  color: active ? Colors.orange : Colors.white,
                                  border: Border.all(
                                      color:
                                          active ? Colors.orange : Colors.white,
                                      width: active ? 2 : 0),
                                  shape: BoxShape.circle)*/
                            ),
                          );
                        }),
                      ),
                    ),

                    Row(
                      children: List.generate(CameraMode.values.length, (p) {
                        CameraMode mode = CameraMode.values[p];
                        bool active = cameraMode == mode;
                        CameraMode prev_mode = cameraMode;
                        String imgPath = effectList[0];


                        return Expanded(
                          child: Container(
                            height: 30,
                            margin: EdgeInsets.all(1),
                            child: TextButton(
                              onPressed: () async {
                                cameraMode = mode;
                                if (!deepArController.value.isInitialized) return;

                                deepArController.switchEffect(
                                    prev_mode, imgPath);
                                setState(() {});
                              },
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.black,
                                primary: Colors.black,
                                // shape: CircleBorder(
                                //     side: BorderSide(
                                //         color: Colors.white, width: 3))
                              ),
                              child: Text(
                                describeEnum(mode),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: active ? FontWeight.bold : null,
                                    fontSize: active ? 9 : 7,
                                    color: Colors.white
                                        .withOpacity(active ? 1 : 0.6)),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),



                    SizedBox(
                      height: 3,
                    ),


                    // camera video icons

                    Positioned(
                      bottom: 0.0,
                      child: Container(
                        //color: Colors.black,
                        padding: EdgeInsets.only(top: 5, bottom: 5),
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                IconButton(
                                    icon: Icon(
                                      flash ? Icons.flash_on : Icons.flash_off,
                                      color: Colors.white,
                                      size: 28,
                                    ),
                                  //onPressed: () async {
                                 //   await deepArController.setFlashMode();
                                   // setState(() {});
                                 // },
                                   onPressed:() {
                                      setState(() {
                                        flash = !flash;
                                      });

                                    }),
                                GestureDetector(
                                  onLongPress: ()  {

                                    if (null == deepArController) return;
                                    deepArController.startVideoRecording();
                                    isRecording = true;
                                    setState((){});
                                    //print(_platformVersion);
                                    }
                                  ,
                                  onLongPressUp: () async {
                                    if (null == deepArController) return;
                                    deepArController.stopVideoRecording();
                                    isRecording = false;
                                    setState((){
                                    });
                                    //print(deepArController.stopVideoRecording());
                                    Future.delayed(Duration(milliseconds: 800), (){
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (builder) => VideoViewPage(
                                                path: path,
                                              )));});

                                  },
                                  onTap: () async {
                                    if (null == deepArController) return;
                                    if (isRecording) return;
                                     deepArController.snapPhoto();
                                    //path= _platformVersion;
                                     //deepArController.snapPhoto();
                                    Future.delayed(Duration(milliseconds: 500), (){

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (builder) => CameraViewPage(
                                              path: path,
                                            )));});

                                    },

                                    child: isRecording
                                        ? Icon(
                                      Icons.radio_button_on,
                                      color: Colors.red,
                                      size: 80,
                                    )
                                        :Icon(
                                      Icons.panorama_fish_eye,
                                      color: Colors.white,
                                      size: 70,
                                    ),
                                  ///////
                                ),
                                    IconButton(
                                    icon: Transform.rotate
                                    (
                                      angle: transform,
                                      child: Icon(
                                        Icons.flip_camera_ios,
                                        color: Colors.white,
                                        size: 28,
                                      ),
                                    ),
                                    onPressed: () async {
                                      //deepArController.flipCamera();
                                      setState(() {

                                      });
                                    }),
                              ],
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              "Hold for Video, tap for photo",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      ),
                    ),



                    ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }



}
