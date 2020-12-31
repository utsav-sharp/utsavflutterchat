import 'dart:async';
import 'dart:io';
import 'package:firebase/firebase.dart';
import 'login_screen.dart';
import 'package:flutterchat/auth_service.dart';
import 'package:mime_type/mime_type.dart';
import 'package:path/path.dart' as Path;
import 'dart:html' as html;
import 'dart:io' as Io;
import 'dart:convert';
import 'package:flutter_web_image_picker/flutter_web_image_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_web_image_picker/flutter_web_image_picker.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:quiver/cache.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutterchat/Widgets/ProgressWidget.dart';
import 'package:flutterchat/main.dart';
import 'package:fluttertoast/fluttertoast.dart';
//import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'myData.dart';



class SettingsPage extends StatelessWidget {
 // final String currentUserId;
 // Settings({Key key,@required this.currentUserId}):super(key:key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Colors.teal,
        title: Text("Account Settings",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
        centerTitle: true,
      ) ,
      body: SettingsScreen(),
    );
  }
}


class SettingsScreen extends StatefulWidget {
  @override
  State createState() => SettingsScreenState();
}



class SettingsScreenState extends State<SettingsScreen> {
  var currentSelfie;
  var imageString="";
String id="";
String nickname="";
String aboutMe="";
String photoUrl="";
File imageFileAvatar;
bool isLoading=false;
final FocusNode nickNameFocusNode=FocusNode();
  final FocusNode aboutMeFocusNode=FocusNode();

TextEditingController nickNameEditingController;
TextEditingController aboutMeEditingController;
  @override
  void initState() {
super.initState();
final FirebaseAuth auth = FirebaseAuth.instance;
final uid = auth.currentUser.uid;
FirebaseFirestore.instance
    .collection('users')
    .doc(uid)
    .snapshots()
    .listen((DocumentSnapshot documentSnapshot)

    {

  Map<String, dynamic> firestoreInfo = documentSnapshot.data();

  setState(() {

     nickname = firestoreInfo['nickname'];
     aboutMe = firestoreInfo['aboutMe'];
     id = firestoreInfo['id'];
     photoUrl = firestoreInfo['photoUrl'];

     print("nickname ${nickname}");
     print("aboutMe ${aboutMe}");
     print("id ${id}");
     print("photoUrl ${photoUrl.trim().length}");

     if(photoUrl.length==0){
       print("I am in null ");
     }
     else{
       final decodedBytes = base64Decode(photoUrl);
       print("decodedBytes ${decodedBytes}");
       currentSelfie=decodedBytes;
       imageString = base64Encode(currentSelfie);
     }

   //
   //  Uint8List base64Decode(String source) => base64.decode(source);

     nickNameEditingController=TextEditingController(text: nickname);
     aboutMeEditingController=TextEditingController(text: aboutMe);
  });

}
)
    .onError((e) => print(e));
  }
  @override
  Widget build(BuildContext context) {

   /* return Scaffold(
       body: Center(
      child:   Container(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
             Text("i AM IN Setting Page",style: TextStyle(fontSize: 30,color: Colors.grey,fontWeight: FontWeight.bold),),
            RaisedButton(
              child: Text("check what happen",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20.0),),
            onPressed: () {


            },
            )


          ],
        )
       //

      ),

    )


    );*/



    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
children: [
  Container(
    child: Center(
      child: Stack(
        children: [
          (currentSelfie == null)
              ? (photoUrl != "")
              ? Material(
            child: Image.memory(
              (currentSelfie),
              width: 200.0,
              height: 200.0,
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.all(Radius.circular(125.0)),
            clipBehavior: Clip.hardEdge,
          )
              : Icon(Icons.account_circle,size: 90.0,color: Colors.grey,)
              :Material(

            child: Image.memory(
              (currentSelfie),
              width: 200.0,
              height: 200.0,
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.all(Radius.circular(125.0)),
            clipBehavior: Clip.hardEdge,
          ),
          IconButton(
            icon: Icon(Icons.camera_alt,size: 100.0,color: Colors.white54.withOpacity(0.3),),
            onPressed: () {
              getPhotos();
            },
            padding: EdgeInsets.all(0.0),
            splashColor: Colors.transparent,
            highlightColor: Colors.grey,
            iconSize: 200.0,
          ),

        ],
      ),
    ),
    width: double.infinity,
    margin: EdgeInsets.all(20.0),

  ),
  Column(
    children: [
      Padding(
        padding: EdgeInsets.all(1.0),
        child: isLoading?circularProgress():Container(),
      ),

      //this for user name TextEditingController
      Container(
        child: Text("Profile Name",style: TextStyle(fontWeight: FontWeight.bold,fontStyle:FontStyle.italic,color: Colors.teal),),
        margin: EdgeInsets.only(left: 10.0,top: 5.0,bottom: 5.0),
      ),
      Container(
        child: Theme(
        data: Theme.of(context).copyWith(primaryColor: Colors.teal),
          child: TextField(
            decoration: InputDecoration(
              hintText: "e.g.Utsav Pajave",
              hintStyle: TextStyle(color: Colors.grey),
              contentPadding: EdgeInsets.all(5.0),
            ),
            controller: nickNameEditingController,
            onChanged: (value) {
          nickname=value;
            },
            focusNode: nickNameFocusNode,
          ),
        ),
        margin: EdgeInsets.only(left: 30.0,right: 30.0),
      ),

      //this for about me controller
      Container(
        child: Text("About Me",style: TextStyle(fontWeight: FontWeight.bold,fontStyle:FontStyle.italic,color: Colors.teal),),
        margin: EdgeInsets.only(left: 10.0,top: 30.0,bottom: 5.0),
      ),
      Container(
        child: Theme(
          data: Theme.of(context).copyWith(primaryColor: Colors.teal),
          child: TextField(
            decoration: InputDecoration(
              hintText: "e.g.Utsav Pajave",
              hintStyle: TextStyle(color: Colors.grey),
              contentPadding: EdgeInsets.all(5.0),
            ),
            controller: aboutMeEditingController,
            onChanged: (value) {
              aboutMe=value;
            },
            focusNode: aboutMeFocusNode,
          ),
        ),
        margin: EdgeInsets.only(left: 30.0,right: 30.0),
      )

    ],
    crossAxisAlignment: CrossAxisAlignment.start,
  ),

  //Button--Update Button
  Container(
    margin: EdgeInsets.fromLTRB(100.0, 40, 100.0, 0),

    width: 300,height: 40,
    child:RaisedButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: BorderSide(color: Colors.teal)),
        color: Colors.teal,
        elevation: 10.0,
        child: Text("Update",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20.0,)),
        onPressed: () {
          uploadImageFileStoreAndStorage();
        }

      //
    ),
  ),
/*  Container(
      child: FlatButton(
        onPressed: () {
          uploadImageFileStoreAndStorage();
        },
        child: Text(
          "update",style: TextStyle(fontSize: 16.0),
        ),
        color: Colors.teal,
        highlightColor: Colors.grey,
        splashColor: Colors.transparent,
        textColor: Colors.white,
        padding: EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
      ),
    margin: EdgeInsets.only(top: 50.0,bottom: 1.0),
  ),*/
     /*   Padding(
          padding: EdgeInsets.only(left: 50.0,right: 50.0),
          child: RaisedButton(
            color: Colors.red,
            onPressed: () {
              print("on pressed signOut");
              setState(() {
                AuthService().signOut();
                isLoading=false;

                Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginPage()));
              });

         *//*    *//*
            },
            child: Text("sign out",style: TextStyle(color: Colors.white,fontSize: 14.0),),
          ),
        )*/


],

    ),
  padding: EdgeInsets.only(left: 15.0,right: 15.0),
        )
      ],
    );

  }

  Future<void> getPhotos() async {
    var mediaData = await ImagePickerWeb.getImageInfo;
    String mimeType = mime(Path.basename(mediaData.fileName));
    html.File mediaFile =
    new html.File(mediaData.data, mediaData.fileName, {'type': mimeType});

    print("imageFile123 ${mediaData.toString()}");

    if (mediaData != null) {
      currentSelfie = mediaData.data;
      imageString = base64Encode(currentSelfie);

      setState(() {});

      print("utsav  ${currentSelfie.toString()}");

    }
  }
Future uploadImageFileStoreAndStorage() async{
    String mFileName=id;
    print("aboutme Text ${aboutMeEditingController.text}");
    print("nickname Text ${nickNameEditingController.text}");
    FirebaseFirestore.instance
        .collection('users')
        .doc(mFileName)
        .update({
      "photoUrl":imageString,
      "nickname":nickNameEditingController.text,
      "aboutMe":aboutMeEditingController.text
    }).then((result){
      Fluttertoast.showToast(msg: "Data Update successful");

    }).catchError((onError){
      print("onError");
    });

}
  _signOut() async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    await _firebaseAuth.signOut();
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginPage()));
  }
}