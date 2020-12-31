import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterchat/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'home_screen.dart';
class LoginPage extends StatefulWidget {
  LoginPage({Key key}):super(key:key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email, password;
  TextEditingController userNameController=new TextEditingController();
  TextEditingController passwordController=new TextEditingController();

  String UserId ='';
  final DBRef = FirebaseDatabase.instance.reference().child('Users');
  final fb = FirebaseDatabase.instance;
  final FirebaseAuth firebaseAuth=FirebaseAuth.instance;
  SharedPreferences preferences;
  bool isLoging=false;
  bool isLoading=false;
  FirebaseUser currentUser;


  var retrievedName="";
  String name = "";
  final formKey = new GlobalKey<FormState>();


  @override
  void initState(){
    super.initState();

  }

  checkFields() {
    final form = formKey.currentState;
    if (form.validate()) {
      return true;
    } else {
      return false;
    }
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }

  @override
  Widget build(BuildContext context) {
    final ref=fb.reference().child("Student");
    return Scaffold(
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.fromLTRB(0, 100, 0, 10),
            child:Center(
              child: Container(
                child:Form(
                  key: formKey,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Image.asset(
                          'images/loginUser.png',
                        ),
                        Padding(padding: EdgeInsets.all(5.0),),
                        new Text("Welcome,Please Sign in",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25.0,color: Colors.teal),),
                        Padding(padding: EdgeInsets.all(10.0),),
                        Container(
                          margin: EdgeInsets.fromLTRB(100.0, 30, 100.0, 0),
                          child: new TextFormField(
                            controller: userNameController,

                            validator: (value) => value.isEmpty
                                ? 'Email is required'
                                : validateEmail(value.trim()),
                            decoration:InputDecoration(
                              labelText: "Email Id",
                              hintText: "Enter Email Id",
                            ),style: TextStyle(color: Colors.black,fontSize: 15.0,fontWeight: FontWeight.bold,
                          ),
                          ),
                        ),
                        Padding(padding: EdgeInsets.all(10.0),),
                        Container(
                          margin: EdgeInsets.fromLTRB(100.0, 30, 100.0, 0),
                          child: new TextFormField(
                            controller: passwordController,
                            obscureText: true,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please Enter Password';
                              }
                              else if(value.length<=3){
                                return 'Please Enter Valid Password';
                              }
                              return null;
                            },

                            decoration:InputDecoration(
                              labelText: "Password",
                              hintText: "Enter Password",

                              // border: new OutlineInputBorder(
                              //   borderSide: new BorderSide(color: Colors.teal)),

                            ),style: TextStyle(color: Colors.black,fontSize: 15.0,fontWeight: FontWeight.bold,
                          ),
                          ),
                        ),
                        Padding(padding: EdgeInsets.all(10.0),),

                        Container(
                          margin: EdgeInsets.fromLTRB(100.0, 40, 100.0, 0),

                          width: 300,height: 40,
                          child:RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  side: BorderSide(color: Colors.teal)),
                              color: Colors.teal,
                              elevation: 10.0,
                              child: Text("Log In",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20.0,)),
                              onPressed: () {
                                if (formKey.currentState.validate()) {
                                  // If the form is valid, display a snackbar. In the real world,
                                  // you'd often call a server or save the information in a database.

                                  print("UserName ${userNameController.text}");
                                  print("Password ${passwordController.text}");
                                  var userName_=userNameController.text;
                                  var password_=passwordController.text;
    if (checkFields()) {
      controlSignIn();
    }

                                  /**/
                                }
                              }

                            //
                          ),
                        ),


                      ]
                  ),

                ),
              ),
            ),
          ),

        )
    );
  }

  Future<Null> controlSignIn() async{


    preferences=await SharedPreferences.getInstance();
    this.setState((){
    isLoading=true;
    });

    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('dd-MMM-yyyy hh:mm:aa');
    final String formatted = formatter.format(now);
    print("formatted==> ${formatted}");

    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: userNameController.text, password: passwordController.text)
        .then((user) async {
      print('Signed in 123 ${userNameController.text}');
      final FirebaseAuth auth = FirebaseAuth.instance;
      final uid = auth.currentUser.uid;
     print("createUserWithEmailAndPassword ${uid}");
     FirebaseFirestore.instance.collection("users").doc(auth.currentUser.uid).set({
        "nickname":userNameController.text,
        "photoUrl":"",
        "id":uid,
        "aboutMe":"I flutter web developer",
        "createdAt":formatted,
        "chattingWith":null,
      });
    //  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => HomePage(currentUserId:user.uid)), (Route<dynamic> route) => false);

/*     await preferences.setString("id", uid);
      await preferences.setString("nickname", name);
      await preferences.setString("photoUrl", "");*/
/*
      */

    }).catchError((e) async{

      print("I am here ${e}");
      Fluttertoast.showToast(msg: "Email already Register in firebase");
      _signInWithEmailAndPassword();
    }
    );
  }
  void _signInWithEmailAndPassword() async {
    print("I am in _signInWithEmailAndPassword");
    final User user = (await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: this.userNameController.text,
      password: this.passwordController.text,
    )).user;
print("email verified${user.email}");
print("email user id ${user.uid}");

    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => HomePage(currentUserId:user.uid)), (Route<dynamic> route) => false);


  }


}