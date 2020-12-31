import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterchat/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'group_chat_page.dart';
class DatabaseService {
  var holder_2 = [];
  var holder_1 = [];
  final String uid;
  DatabaseService({
    this.uid
  });

  // Collection reference
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');
  final CollectionReference groupCollection = FirebaseFirestore.instance.collection('groups');

  // update userdata
  Future updateUserData(String fullName, String email, String password) async {
    return await userCollection.doc(uid).set({
      'fullName': fullName,
      'email': email,
      'password': password,
      'groups': [],
      'profilePic': ''
    });
  }


  // create group
  Future createGroup(String userName, String groupName,var friendUserName,var friendUserId,BuildContext context) async {
    print("createGroup and ${groupName} and ${userName} and ${uid}");

    holder_2=friendUserId;
    holder_1=friendUserName;


    print("holder_1 createGroup jointGroup first ${holder_1.toString()}");
    print("holder_2 createGroup jointGroup first${holder_2.toString()}");

    DocumentReference groupDocRef = await groupCollection.add({
      'groupName': groupName,
      'groupIcon': '',
      'admin': userName,
      'members': [],
      //'messages': ,
      'groupId': '',
      'recentMessage': '',
      'recentMessageSender': ''
    });
    Fluttertoast.showToast(msg: "${groupName} Group successfully");
    await groupDocRef.update({


      'members': FieldValue.arrayUnion([uid + '_' + userName]),
      'groupId': groupDocRef.id

    });

    jointGroup(groupDocRef.id,groupName,holder_1,holder_2,context);

    //DatabaseService(uid: '8sudMrUtWOPvDRMuYfbuTk9bf8s2').togglingGroupJoin(groupDocRef.id, groupName, "Ganesh");

//jointGroup(groupDocRef.id, groupName);

    DocumentReference userDocRef = userCollection.doc(uid);
    return await userDocRef.update({
      'groups': FieldValue.arrayUnion([groupDocRef.id + '_' + groupName]),
      'groupPhotoUrl': FieldValue.arrayUnion(['Utsav'])
    });



  }


  Future togglingGroupJoin(String groupId, String groupName, String userName,BuildContext context) async {


    print("groupId==> ${groupId} and ${groupName} and ${userName} and ${uid}");

    print("togglingGroupJoin 123");
    DocumentReference userDocRef = userCollection.doc(uid);
    DocumentSnapshot userDocSnapshot = await userDocRef.get();

    DocumentReference groupDocRef = groupCollection.doc(groupId);

    List<dynamic> groups = await userDocSnapshot.data()['groups'];
    print("groups 123456 and ${userDocSnapshot.data()['groups'].toString()}");
    print("togglingGroupJoin 123456");


    if(groups == null){
      print("I am in null part");

      await userDocRef.update({
        'groups': FieldValue.arrayUnion([groupId + '_' + groupName]),

      });

      await groupDocRef.update({
        'members': FieldValue.arrayUnion([uid + '_' + userName])
      });
      //
    }

    if(groups.contains(groupId + '_' + groupName)) {

      print('hey');
      userDocRef.update({
        'groups': FieldValue.arrayRemove([groupId + '_' + groupName]),

      });

      await groupDocRef.update({
        'members': FieldValue.arrayRemove([uid + '_' + userName])
      });
      //  Navigator.of(context).push(MaterialPageRoute(builder: (context) => GroupChatPage()));
    }
    else {
      print("togglingGroupJoin 123456789");
      print('nay');
      await userDocRef.update({
        'groups': FieldValue.arrayUnion([groupId + '_' + groupName])
      });

      await groupDocRef.update({
        'members': FieldValue.arrayUnion([uid + '_' + userName])
      });

      //
    }
    // Navigator.of(context).push(MaterialPageRoute(builder: (context) => GroupChatPage(currentUserId: uid, currentUserName: userName,comingFrom:"Create Group")));
    _popupDialog(context,uid,userName,"Create Group",groupName);
  }

  // has user joined the group
  Future<bool> isUserJoined(String groupId, String groupName, String userName) async {

    DocumentReference userDocRef = userCollection.doc(uid);
    DocumentSnapshot userDocSnapshot = await userDocRef.get();

    List<dynamic> groups = await userDocSnapshot.data()['groups'];


    if(groups.contains(groupId + '_' + groupName)) {
      //print('he');
      return true;
    }
    else {
      //print('ne');
      return false;
    }
  }


  // get user data
  Future getUserData(String email) async {
    QuerySnapshot snapshot = await userCollection.where('email', isEqualTo: email).get();
    print(snapshot.docs[0].data);
    return snapshot;
  }


  // get user groups
  getUserGroups() async {
    print("uid getUserGroups==>${uid}");
    // return await Firestore.instance.collection("users").where('email', isEqualTo: email).snapshots();
    return FirebaseFirestore.instance.collection("users").doc(uid).snapshots();
  }


  // send message
  sendMessage(String groupId, chatMessageData) {
    FirebaseFirestore.instance.collection('groups').doc(groupId).collection('messages').add(chatMessageData);
    FirebaseFirestore.instance.collection('groups').doc(groupId).update({
      'recentMessage': chatMessageData['message'],
      'recentMessageSender': chatMessageData['sender'],
      'recentMessageTime': chatMessageData['time'].toString(),
    });
  }


  // get chats of a particular group
  getChats(String groupId) async {
    return FirebaseFirestore.instance.collection('groups').doc(groupId).collection('messages').orderBy('time').snapshots();
  }


  // search groups
  searchByName(String groupName) {
    return FirebaseFirestore.instance.collection("groups").where('groupName', isEqualTo: groupName).get();
  }
}

void jointGroup(String groupId,String groupName,var holder_1,var holder_2,BuildContext context) async{
  String userGroups="";
  print("holder_1 createGroup jointGroup ${holder_1}");
  print("holder_2 createGroup jointGroup ${holder_2}");
  for(int i=0;i<holder_2.length;i++){

    print("togglingGroupJoin for loop ${holder_2[i]} and ${holder_1[i]}");
    userGroups+=","+holder_1[i];
    DatabaseService(uid: holder_2[i]).togglingGroupJoin(groupId, groupName, holder_1[i],context);

  }

  Fluttertoast.showToast(msg: "${userGroups} Users add ${groupName} successfully");

}
void _popupDialog(BuildContext context,String currentUserId,String currentUserName,String comingFrom,String groupName) {
/*  Widget createButton = FlatButton(
    child: Text("Create"),
    onPressed:  () async {

      if(groupName != null) {

        Navigator.of(context).pop();
      }
    },
  );*/


  AlertDialog alert = AlertDialog(
    title: Text(" ${groupName} group Created Succssfully"),
    /* content: */
    content: SingleChildScrollView(
      child:Container(

        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ButtonTheme(

              height: 50.0,
              child:      RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(color: Colors.teal)),
                  color: Colors.teal,
                  elevation: 10.0,
                  child: Text("Submit",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20.0,)),
                  onPressed: () async {
                    print("I am in data base dialog service click");
                    // Navigator.pop(context);
                    //  Navigator.of(context).pop(false);
                    // Navigator.of(context, rootNavigator: true).pop();
                    Navigator.of(context, rootNavigator: true).pop();
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => GroupChatPage(currentUserId: currentUserId, currentUserName: currentUserName,comingFrom:comingFrom)));

                    //Navigator.of(context).pop();
                    /*  await Navigator.of(context)
                      .push(new MaterialPageRoute(builder: (context) =>  GroupChatPage(currentUserId: currentUserId, currentUserName: currentUserName,comingFrom:comingFrom)));
*/
                  }

                //
              ),
            ),


          ],
        ),
      ),
    ),

    /*   actions: [
     // cancelButton,
      createButton,
    ],*/


  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}