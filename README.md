# snapchat_filters

Mobile application that has two main features 
 1- the app uses the plugin offered by deepAr.ai to apply filters on the user's face .this plug in 
    uses AI to detect the user's face then AR to apply the filter
2- the app offers the possibilty to edit the photo from gallery or even the phots taken from the app camera

the user can also save the edited photos or even share them 
plugins used in this app:
{   camera_deep_ar: //responsible for applying filters on the face
    git:
        url: https://github.com/KalanaPerera/FlutterDeepAR
    avatar_view: ^1.0.1 // show round images 
    video_player: ^2.4.9 //play videos on the app

    path_provider: ^2.0.5 
        path:
    image_picker: ^0.8.6 //pick images from galllery 
    share_plus: ^6.3.0 //share files
    animagie_image_ editor: ^0.0.1 // image editor
    gallery_saver: ^2.3.2  // save images to gallery
}
 configuraions :{
compileSdkVersion 33
minSdkVersion 23
targetSdkVersion 29
Flutter 3.3.10
Tools • Dart 2.18.6 • DevTools 2.15.0
}

