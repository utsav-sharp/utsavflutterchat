import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterchat/home_screen.dart';
import 'package:flutterchat/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_screen1.dart';
class AuthService {
  //Handle Authentication
  final fb = FirebaseDatabase.instance;
  String UserId ='';
  final DBRef = FirebaseDatabase.instance.reference().child('Users');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  handleAuth() {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final FirebaseAuth auth = FirebaseAuth.instance;
          final uid = auth.currentUser.uid;
          print("I am in home screen ${uid}");
          return HomePage(currentUserId:auth.currentUser.uid);
        } else {
          return LoginPage();
        //  return RegistrationScr();
        }
      },
    );
  }

  //Sign Out
  signOut() {
    print("signOut signOut");
    FirebaseAuth.instance.signOut();


  }

  //Sign in
  signIn(email, password) {
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((user) async{
      print('Signed in');
    /*  FirebaseUser user = await FirebaseAuth.instance.currentUser();
      print("result==>123 ${user.uid}");
      Firestore.instance.collection("users").document(user.uid).setData({
        "nickname":"Utsav",
        "photoUrl":"",
        "id":user.uid,
        "aboutMe":"I learn flutter web application",
        "createdAt":DateTime.now().microsecondsSinceEpoch.toString(),
        "chattingWith":null,
      });*/
    }).catchError((e) {
      print("I am here ${e}");
    });
  }
}
