import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:html' as html;
import 'group_chat_page.dart';
import 'dart:async';
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
class CheckBox extends StatelessWidget {
  String currentUserId;
  String currentUserName;
  Map<String, bool> firebaseUserName={};
  var tempUserId=[];
  CheckBox({
    Key key,@required this.currentUserId,@required this.currentUserName,this.firebaseUserName,@required this.tempUserId
  });

  @override
  Widget build(BuildContext context) {

    return new WillPopScope(
      onWillPop: () async => Navigator.of(context).push(MaterialPageRoute(builder: (context) => GroupChatPage(currentUserId: currentUserId, currentUserName: currentUserName,comingFrom:"Create Group"))),


      child:   MaterialApp(
        debugShowCheckedModeBanner: false,

        home: Scaffold(

            appBar: AppBar(
              leading: BackButton(
                color: Colors.white,
                onPressed: () {

                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => GroupChatPage(currentUserId: currentUserId, currentUserName: currentUserName,comingFrom:"Create Group")));


                },

              ),
              title: Text("Create Group", style: TextStyle(color: Colors.white),),
              // centerTitle: true,
              backgroundColor: Colors.teal,
              elevation: 0.0,
            ),
            body: SafeArea(
                child : Center(

                  child:CheckboxWidget(currentUserId:currentUserId,currentUserName:currentUserName,firebaseUserName:firebaseUserName,tempUserId:tempUserId),

                )
            )
        ),
      ),
    );


  }
}

class CheckboxWidget extends StatefulWidget {
  String currentUserId;
  String currentUserName;
  Map<String, bool> firebaseUserName={};
  var tempUserId=[];
  CheckboxWidget({
    Key key,@required this.currentUserId,@required this.currentUserName,@required this.firebaseUserName,@required this.tempUserId
  }):super(key:key);



  @override
  CheckboxWidgetState createState() => new CheckboxWidgetState(currentUserId:currentUserId,currentUserName:currentUserName,firebaseUserName:firebaseUserName,tempUserId:tempUserId);
}

class CheckboxWidgetState extends State {
  String currentUserId;
  String currentUserName;
  String _groupName;
  Map<String, bool> firebaseUserName={};
  var tempUserId=[];

  CheckboxWidgetState({
    Key key,@required this.currentUserId,@required this.currentUserName,@required this.firebaseUserName,@required this.tempUserId
  });

  @override
  void initState() {
    super.initState();
    // _createFileFromString();
    print("I am in displayUserFoundScreen method 1 ${tempUserId.toString()}");

    //displayUserFoundScreen();
  }

  Map<String, bool> numbers = {
    'One' : false,
    'Two' : false,
    'Three' : false,
    'Four' : false,
    'Five' : false,
    'Six' : false,
    'Seven' : false,
    'eight' : false,
    'Nine' : false,
    'Ten' : false,
    'Eleven' : false,
    'Twele' : false,
    'Thirteen' : false,
    'Fourteen' : false,
    'Fifteen' : false,
    'Sixteen' : false,
    'Seventeen' : false,
    'Eighteen' : false,
    'Nineteen' : false,
    'Twenty' : false,
    'Twenty One' : false,
  };

  var holder_1 = [];
  var holder_2 = [];


  getItems(){
    print("I AM in getItem method");

  }

  @override
  Widget build(BuildContext context) {
    return Column (children: <Widget>[
      Container(
        margin: EdgeInsets.all(15.0),
        child:TextField(
            onChanged: (val) {
              _groupName = val;
            },
            style: TextStyle(
                fontSize: 15.0,
                height: 2.0,
                color: Colors.black
            )
        ),
      ),


      Expanded(
        child:Container(
          margin: EdgeInsets.all(15.0),
          child :
          ListView(
            children: firebaseUserName.keys.map((String key) {
              return new CheckboxListTile(
                title: new Text(key),
                value: firebaseUserName[key],
                activeColor: Colors.pink,
                checkColor: Colors.white,
                onChanged: (bool value) {
                  setState(() {
                    firebaseUserName[key] = value;
                    //firebaseUserId[key]=value;
                  });
                },
              );
            }).toList(),
          ),
        ),
      ),

      Container(
        margin: EdgeInsets.fromLTRB(100.0, 0, 100.0, 30),

        width: 300,height: 40,
        child:RaisedButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: BorderSide(color: Colors.teal)),
            color: Colors.teal,
            elevation: 10.0,
            child: Text("Join  Group",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20.0,)),
            onPressed: () {
              // print("I create ${_groupName} and My user id ${currentUserId} and userName ${currentUserName}");
              /* print("firebaseUserName  ${firebaseUserName.toString()} and ${firebaseUserName.length} ");
              print("firebaseUserId  ${tempUserId.toString()} and ${tempUserId.length} ");*/


              /*    firebaseUserName.forEach((key, value) {
         if(value == true)
         {
           print("sfsffedf ${firebaseUserName[key]}");
           holder_1.add(key);
         }
       });
*/

              var _list = firebaseUserName.values.toList();
              var _list1 = firebaseUserName.keys.toList();
              var _list2 = tempUserId.toList();


              /*       print("_list  ${_list.toString()}");
              print("_list  ${_list1.toString()}");
              print("_list  ${_list2.toString()}");

              print("_list  ${_list.length} and ${_list1.length} and ${_list2.length}");*/


              for(int i=0;i<_list.length;i++){
                if(_list[i] == true){
                  print("selected Name ==> ${_list1[i]}");
                  print("selected Id ==> ${_list2[i]}");
                  holder_1.add(_list1[i]);
                  holder_2.add(_list2[i]);
                }
              }

              // Printing all selected items on Terminal screen.
              print("holder 1 ==> ${holder_1}");
              print("holder 2 ==> ${holder_2}");

              DatabaseService(uid: currentUserId).createGroup(currentUserName, _groupName,holder_1,holder_2,context);




              //  _popupDialog(context);



              //

              // Here you will get all your selected Checkbox items.

              // Clear array after use.
              //holder_1.clear();
              //holder_2.clear();
              /*   setState(() {
              getItems;
            });*/

              //print("onpressed ${firebaseUserName.toString()}");
            }

          //
        ),
      ),

    ]);

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



        ///Navigator.of(context).pop();

      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Create a group Succssfully"),
      /* content: */
      content: SingleChildScrollView(
        child:Container(
          width: 300,
          height: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [



              TextField(
                  onChanged: (val) {
                    _groupName = val;
                  },
                  style: TextStyle(
                      fontSize: 15.0,
                      height: 2.0,
                      color: Colors.black
                  )
              ),


            ],
          ),
        ),
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

}
