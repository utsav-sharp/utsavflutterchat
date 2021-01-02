import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:html' as html;
import 'group_chat_page.dart';
import 'auth_service1.dart';
import 'login_screen.dart';
import 'dart:io' as Io;
import 'database_service.dart';
import 'helper_functions.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth_;
import 'ChattingPage.dart';
import 'dart:typed_data';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutterchat/ImageSelect.dart';
import 'package:intl/intl.dart';
import 'package:flutterchat/Models/user.dart';
import 'package:flutterchat/Widgets/ProgressWidget.dart';
import 'package:flutterchat/auth_service.dart';
import 'package:flutter/material.dart';
import 'AccountSettingsPage.dart';
import 'package:firebase_database/firebase_database.dart';
class HomePage extends StatefulWidget {
  final String currentUserId;

  HomePage({Key key,@required this.currentUserId}):super(key:key);
  @override
  _HomePageState createState() => _HomePageState(currentUserId:currentUserId);
}

class _HomePageState extends State<HomePage> {
  final fb = FirebaseDatabase.instance;
  final AuthService1 _auth = AuthService1();
  String userNameData;
  String currentIdUserId,currentUserName;
  String _groupName;
  _HomePageState({Key key,@required this.currentUserId});
  TextEditingController serachTextEditingController=TextEditingController();
      final String currentUserId;
  Future<QuerySnapshot> futureSearchResults;

  @override
  void initState() {

    super.initState();


    final auth_.FirebaseAuth auth = auth_.FirebaseAuth.instance;
    final uid = auth.currentUser.uid;





    print("initState==>${uid}");
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .snapshots()
        .listen((DocumentSnapshot documentSnapshot)

    {

      Map<String, dynamic> firestoreInfo = documentSnapshot.data();

      setState(() async{

        String nickname = firestoreInfo['nickname'];

        String id = firestoreInfo['id'];
        String photoUrl = firestoreInfo['photoUrl'];
        print("nickname Utsav ${nickname}");
        print("id Utsav ${id}");

        currentIdUserId=id;
        currentUserName=nickname;

        print("currentIdUserId ${currentIdUserId} and currentUserName ${currentUserName}");

        SharedPreferences prefs = await SharedPreferences.getInstance();

        await prefs.setString('id', id);
        await prefs.setString('nickname', nickname);
        await prefs.setString('photoUrl', "");

      });

    });
  }


  void _popupDialog(BuildContext context) {

    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );
    Widget createButton = FlatButton(
      child: Text("Create"),
      onPressed:  () async {

       if(_groupName != null) {
          await HelperFunctions.getUserNameSharedPreference().then((val) {
            print("val==> ${val}");
            print("_user.uid==> ${currentIdUserId}");
            print("_groupName==> ${_groupName}");

           //DatabaseService(uid: currentIdUserId).createGroup(currentUserName, _groupName);




          });
          Navigator.of(context).pop();
        }
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Create a group"),
      content: TextField(
          onChanged: (val) {
            _groupName = val;
          },
          style: TextStyle(
              fontSize: 15.0,
              height: 2.0,
              color: Colors.black
          )
      ),
      actions: [
        cancelButton,
        createButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }


  @override
  Widget build(BuildContext context) {

    final ref = fb.reference();

   /* return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('You are logged in ${widget.currentUserId}'),
          SizedBox(height: 10.0),
          RaisedButton(
            onPressed: () {
              AuthService().signOut();
            },
            child: Center(
              child: Text('Sign out'),
            ),
            color: Colors.red,
          )
        ],
      ),
    );*/
    controlSearching(String userName){
      userNameData=userName;
      Future<QuerySnapshot> allFoundUsers=FirebaseFirestore.instance.collection("users").where("nickname",
          isGreaterThanOrEqualTo: userName).get();

      setState(() {
        futureSearchResults=allFoundUsers;

      });
    }
    homePageHeader(){
      return AppBar(
      automaticallyImplyLeading: false,  //remove back button
        actions: [
          IconButton(
            icon: Icon(Icons.settings,size: 25.0,color: Colors.white),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage()));
            },
          ),
          IconButton(
            icon: Icon(Icons.logout,size: 25.0,color: Colors.white),
            onPressed: () async{
              AuthService().signOut();
              //await _auth.signOut();
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => LoginPage()), (Route<dynamic> route) => false);

            },
          ),
          IconButton(
            icon: Icon(Icons.group,size: 25.0,color: Colors.white),
            onPressed: () {
              //_popupDialog(context);
             //Navigator.of(context).push(MaterialPageRoute(builder: (context) => GroupChatPage()));
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => GroupChatPage(currentUserId: currentIdUserId, currentUserName: currentUserName,comingFrom:"HomeScreen")));

            },
          ),
        ],
        backgroundColor: Colors.teal,
        title: Container(
          margin: EdgeInsets.only(bottom: 4.0),
          child: TextFormField(
            style: TextStyle(fontSize: 18.0,color: Colors.white),
            controller:serachTextEditingController,
            decoration: InputDecoration(
              hintText: "Search here....",
              hintStyle: TextStyle(color: Colors.white),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey)
              ),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)
                ),
              filled: true,
              prefixIcon: Icon(Icons.person,color: Colors.white,size: 30.0,),
              suffixIcon: IconButton(
                icon: Icon(Icons.person,color: Colors.white,size: 30.0,),
                onPressed: emptyTextFormField,
              ),
            ),

            onFieldSubmitted: controlSearching,
          ),
        ),
      );
    }




    return Scaffold(
      appBar: homePageHeader(),
 /*     body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('You are logged in ${widget.currentUserId}'),
          SizedBox(height: 10.0),
          RaisedButton(
            onPressed: () {

              //getData();
              AuthService().signOut();
            },
            child: Center(
              child: Text('Sign out'),
            ),
            color: Colors.red,
          )
        ],
      ),*/

     body: futureSearchResults == null? displayUserFoundScreen():displayUserFoundScreen(),
    );
  }


  displayUserFoundScreen() {
    print("I am in displayUserFoundScreen");
    List<UserResult> searchUserResult = [];

/*

    FirebaseFirestore.instance
        .collection('users')
        .where("nickname", isEqualTo: userNameData)
        .snapshots()
        .listen((data) =>
       // data.docs.forEach((doc) => print(doc["id"])));
    data.docs.forEach((doc) {
      User eachUser = User.fromDocument(doc);
      UserResult userResult = UserResult(eachUser);
      print("current Id ${doc["id"]} and ${currentUserId}");

      if (currentUserId != doc["id"]) {
        print("userResult==>${userResult.eachUser.nickname}");
        print("userResult==>${userResult.eachUser.aboutMe}");
        searchUserResult.add(userResult);
      }
    }
    ),
    );
    print("searchUserResult==>${searchUserResult.length}");
    return ListView(children: searchUserResult);
*/


print("userNameData displayUserFoundScreen==> ${userNameData}");

  if(userNameData==null){
    return FutureBuilder(

        future:  FirebaseFirestore.instance
            .collection('users')
            .where("nickname", isGreaterThanOrEqualTo: "").get(),
        builder: (context,dataSnapshot) {
          print("datasnapshot erroe ${dataSnapshot.hasError}");

          if( dataSnapshot.connectionState == ConnectionState.waiting){
            return  Center(child: Text('Please wait its loading...'));
          }else{
            if (dataSnapshot.hasError) {
              print(dataSnapshot.error);
              return Center(child: Text('Error: ${dataSnapshot.error}'));
            }
            else {
              // return Center(child: new Text('${dataSnapshot.data}'));  // snapshot.data  :- get your object which is pass from your downloadData() function
              // print("document 123 ${dataSnapshot.data.documents.toString()}");

              dataSnapshot.data.documents.forEach((document) {
                User eachUser = User.fromDocument(document);
                UserResult userResult = UserResult(eachUser);

                 print("document 12345 ${document["nickname"]}");
                print("document 12345 ${document["id"]}");
                if (currentUserId != document["id"]) {
                  searchUserResult.add(userResult);
                  print("userResult==>${userResult}");
                }
              });
              print("searchUserResult==>${searchUserResult.toString()}");
              return ListView(children: searchUserResult);
            }
          }

          if(!dataSnapshot.hasData){
            return circularProgress();
          }


        }
    );
  }
  else{
    return FutureBuilder(

        future:  FirebaseFirestore.instance
            .collection('users')
            .where("nickname", isGreaterThanOrEqualTo:userNameData).get(),
        builder: (context,dataSnapshot) {
          print("datasnapshot erroe ${dataSnapshot.hasError}");

          if( dataSnapshot.connectionState == ConnectionState.waiting){
            return  Center(child: Text('Please wait its loading...'));
          }else{
            if (dataSnapshot.hasError) {
              print(dataSnapshot.error);
              return Center(child: Text('Error: ${dataSnapshot.error}'));
            }
            else {
              // return Center(child: new Text('${dataSnapshot.data}'));  // snapshot.data  :- get your object which is pass from your downloadData() function
              // print("document 123 ${dataSnapshot.data.documents.toString()}");

              dataSnapshot.data.documents.forEach((document) {
                User eachUser = User.fromDocument(document);
                UserResult userResult = UserResult(eachUser);

                //  print("document 12345 ${document["nickname"]}");
                if (currentUserId != document["id"]) {
                  searchUserResult.add(userResult);
                    print("userResult==>${userResult}");
                }
              });
              print("searchUserResult==>${searchUserResult.toString()}");
              return ListView(children: searchUserResult);
            }
          }

          if(!dataSnapshot.hasData){
            return circularProgress();
          }


        }
    );
  }




/*    Future<QuerySnapshot> allFoundUsers=FirebaseFirestore.instance.collection("users").where("nickname",
        isGreaterThanOrEqualTo: userName).get();*/




/*  return FutureBuilder(
      future: futureSearchResults,
      builder: (context,dataSnapshot) {
        print("datasnapshot erroe ${dataSnapshot.hasError}");

        if( dataSnapshot.connectionState == ConnectionState.waiting){
          return  Center(child: Text('Please wait its loading...'));
        }else{
          if (dataSnapshot.hasError) {
            print(dataSnapshot.error);
            return Center(child: Text('Error: ${dataSnapshot.error}'));
          }
          else {
            // return Center(child: new Text('${dataSnapshot.data}'));  // snapshot.data  :- get your object which is pass from your downloadData() function

            dataSnapshot.data.documents.forEach((document) {
              User eachUser = User.fromDocument(document);
              UserResult userResult = UserResult(eachUser);
              if (currentUserId != document["id"]) {
                searchUserResult.add(userResult);
                print("userResult==>${userResult}");
              }
            });
            return ListView(children: searchUserResult);
          }
        }

        if(!dataSnapshot.hasData){
          return circularProgress();
        }


      }
        );*/
/*
        if (dataSnapshot.connectionState == ConnectionState.done) {
          if (dataSnapshot.data == null) {
            return Text('no data');
          } else {
            return Text('data present');
          }
        } else {
          return CircularProgressIndicator(); // loading
        }

      },

    );*/
  }

  displayNoSearchResultScreen(){
  //  print("I am in displayNoSearchResultScreen");
    final Orientation orientation=MediaQuery.of(context).orientation;
    return Container(
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            //Icon(Icons.group,color: Colors.teal,size: 200.0,),
         Image.asset(
              "images/missing.png",
              height: 150,
              width: 150,

              fit: BoxFit.contain,
            ),
            Text("Search user",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 25.0,color: Colors.teal,fontWeight: FontWeight.w500),)
          ],
        ),
      ),
    );
  }
  emptyTextFormField(){
    serachTextEditingController.clear();
  }

}
class UserResult extends StatelessWidget
{

  final User eachUser;
  var currentSelfie;
  UserResult(this.eachUser);

  @override
  Widget build(BuildContext context) {
   // Uint8List profile = base64.decode(eachUser.photoUrl);
  //  final decodedBytes = base64Decode(eachUser.photoUrl);
 //   var currentSelfie=decodedBytes;
   // print("user currentSelfie ${currentSelfie}");

    String photoUrlData="";
 //print("photoUrel123==> ${eachUser.photoUrl}");
    final decodedBytes = base64Decode(eachUser.photoUrl);
   // print("decodedBytes ${decodedBytes}");
     currentSelfie=decodedBytes;
  //  print("photoUrel123==> ${currentSelfie.length}");



    return Padding(
      padding: EdgeInsets.all(4.0),
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                sendUserToChatPage(context);
              },
              child: ListTile(
                leading: CircleAvatar(

                   radius: 40, child: ClipOval(child:currentSelfie.length !=0? new Image.memory(currentSelfie):new Image.asset(
                  "images/profile.png",
                /*  height: 150,
                  width: 150,*/

                  fit: BoxFit.contain,
                ),)
                ),
                title: Text(
                  eachUser.nickname,style: TextStyle(color: Colors.black,fontSize: 16.0,fontWeight: FontWeight.bold),
                ),
                subtitle: Text("joined: "+ eachUser.createdAt,
                  style: TextStyle(
                    color: Colors.grey,fontSize: 14.0,fontStyle: FontStyle.italic

                  ),

                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  sendUserToChatPage(BuildContext context){

    Navigator.push(context, MaterialPageRoute(builder: (context) => Chat(receiverId:eachUser.id,receiverAvatar:eachUser.photoUrl,
    receiverName:eachUser.nickname)));


  }

}
