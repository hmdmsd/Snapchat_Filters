import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera_deep_ar/camera_deep_ar.dart';//camera deep ar plugin
import 'package:avatar_view/avatar_view.dart';//plugin to show images in a certain way
import 'package:flutter/services.dart';
import 'package:animagie_image_editor/bemeli_image_editor.dart';//plugin for editing photos
import '../screens/videoview.dart';
import '../screens/cameraview.dart';
//key : licence key for deepar.ai platfeform . it allows the application to uses
//the api to apply AR filters on images

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
  //init of deep Ar controller
  final deepArController = CameraDeepArController(config);

  String _platformVersion = 'Unknown';
  String path=''; //path of image taken by the deep ar camera
  String vid='';//path of the video taken by deep ar camera

  bool isRecording = false;
  CameraMode cameraMode = config.cameraMode;
  DisplayMode displayMode = config.displayMode;
  int currentEffect = 0;
  bool iscamerafront = true;
  bool flash = false;
  double transform = 0;
  bool hover=false;


  String dir='';

//list of effects
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
//list of files of the filters that we are going to use these
// //filters  exist in our assets
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
  void initState() { //constructor
    super.initState();
    CameraDeepArController.checkPermissions(); //check camera permissions
    deepArController.setEventHandler(DeepArEventHandler(onCameraReady: (v) {
      _platformVersion = "onCameraReady $v";
      //v is the file path
      setState(() {});
    }, onSnapPhotoCompleted: (v) { //function that shows the end of capturing photo process
      _platformVersion = " $v";
      //path
      setState(() {path=v;
      });
    }, onVideoRecordingComplete: (v) {
      _platformVersion = "onVideoRecordingComplete $v"; //function that shows
      // the end of capturing video process
      setState(() {path=v;});
    }, onSwitchEffect: (v) {
      //function that shows
      // the end of switching effect  process
      _platformVersion = "onSwitchEffect $v";
      setState(() {});
      //variable path is the path of the file captured (img, vid)
      // every time we capture a photo or a video  path changes .
    }));
  }
/*Dispose is a method triggered whenever the created object from the stateful
 widget is removed permanently from the widget tree. It is generally
 overridden and called only when
the state object is destroyed. Dispose releases the memory allocated
to the existing variables of the state.*/
  @override
  void dispose() {
    deepArController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,//remove the debug banner
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            DeepArPreview(deepArController), //deep ar controller is the class
            //that opens the camera ones this page is loaded .for
            //it is also responsible for detecting faces and applying filters
            //also this class uses the DEEPAP.AI API
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.all(0),
                //height: 250,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
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
                              //switchEffect is used when an effect is selected
                              //it is a method of deeparController that takes
                              //the the selected filter or effect and what is captured
                              //on camera  as parameters to apply the filter on the faces
                              deepArController.switchEffect(
                                  cameraMode, imgPath);
                              setState(() {});
                            },
                            child: AvatarView(
                              //images of filters shown on screen
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
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [

                                GestureDetector(
                                  onLongPress: ()  {
                                    //function that start video recording

                                    if (null == deepArController) return;
                                    deepArController.startVideoRecording();
                                    isRecording = true;
                                    setState((){});
                                    //print(_platformVersion);
                                    }
                                  ,
                                  onLongPressUp: () async {
                                    //function that stops video recording
                                    if (null == deepArController) return;
                                    deepArController.stopVideoRecording();
                                    isRecording = false;
                                    setState((){
                                    });
                                    //after capturing the video we move
                                    // to videoViewpage after one second inorder
                                    //for the video to load
                                    Future.delayed(Duration(milliseconds: 1000), (){
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
                                    //function that captures photos
                                    Future.delayed(Duration(milliseconds: 500), () async{

                                      var editedImage = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          //after captering the photo we are
                                          //going to edit it on ImageEdito
                                            builder: (builder) => ImageEditor(
                                              image: File(path),
                                            )));

                                      if (editedImage != null) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (builder) =>
                                                //the image edited is shown on
                                                //Camera view page
                                                    CameraViewPage(
                                                      path: editedImage.path
                                                      ,
                                                    )));
                                        setState(() {});

                                      }
                                    });

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
