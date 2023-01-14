import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';
import '../widgets/info_card.dart';
import '../screens/cam_masks_filters.dart';
import '../screens//CameraView.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stories_editor/stories_editor.dart';
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
          minimum: const EdgeInsets.only(top: 150),
          child: Column(
            children: <Widget>[
              // const CircleAvatar(
              //   radius: 50,
              //   backgroundImage: AssetImage('assets/avatar1.png'),
              // ),
              ClipRRect(
                borderRadius: BorderRadius.circular(15), // Image border
                child: Image.asset(
                  "assets/avatars_cards/avatar11.jpg",
                  height: 100.0,
                  width: 100.0,
                  fit:BoxFit.cover,
                ),
              ),
              const Text(
                "Supcom Student",
                style: TextStyle(
                  fontSize: 30.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                "@supcomstudent123",
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Source Sans Pro",
                ),
              ),
              const SizedBox(
                height: 20,
                width: 200,
                child: Divider(
                  color: Colors.blueGrey,
                ),
              ),

              InfoCard(text: "Take a photo", icon: Icons.photo_camera, onPressed: () async {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (builder) => CameraMasksFilters()
                    )
                );
              }),
              InfoCard(text: "Uplaod image", icon: Icons.photo_library, onPressed: () async {
                Navigator.push(context, MaterialPageRoute(builder: (context) => StoriesEditor(
                  giphyKey: 'yxpcbXSkAgeR0GHEsdghEc9S7LjmXE1i',
                  onDone: (uri){
                    debugPrint(uri);
                    Share.shareFiles([uri]);
                  },
                ))
                );

              }),
              ElevatedButton(
                child: Text("Logout"),
                onPressed: () {
                  FirebaseAuth.instance.signOut().then((value) {
                    print("Signed Out");
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  });
                },
              ),



            ],
          )),


    );
  }
}