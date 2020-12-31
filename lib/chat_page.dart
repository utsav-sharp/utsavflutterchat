import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'database_service.dart';
import 'message_tile.dart';
import 'dart:async';
import 'dart:html' as html;
import 'dart:math';

import 'package:open_file/open_file.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path/path.dart' as Path;
import 'package:firebase/firebase.dart' as fb;
import 'dart:io' as Io;
import 'dart:io';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';
import 'package:firebase/firebase.dart';
import 'package:mime_type/mime_type.dart';
import 'package:path/path.dart' as Path;
import 'dart:convert';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutterchat/Widgets/FullImageWidget.dart';
import 'package:flutterchat/Widgets/ProgressWidget.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatPage extends StatefulWidget {

  final String groupId;
  final String userName;
  final String groupName;

  ChatPage({
    this.groupId,
    this.userName,
    this.groupName
  });

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  bool isDisplaySticker;
  var listMessage;
  var currentSelfie;
  var imageString="";
  bool isLoading;
  String imageUrl;
  FocusNode focusNode=FocusNode();
  Stream<QuerySnapshot> _chats;
  TextEditingController messageEditingController = new TextEditingController();
   ScrollController listScrollController=ScrollController();


  onFocusChange(){
    print("focus textField ${focusNode.hasFocus}");
    if(focusNode.hasFocus){
      setState(() {
        //hide sticker when keyboard appear
        isDisplaySticker=false;
      });
    }
  }
  Widget _chatMessages(){
    return StreamBuilder(

      stream: _chats,

      builder: (context, snapshot){
        print("I AM IN CHAT PAGE ${snapshot.hasData}");
       // listMessage=snapshot.data.documents;
        if( snapshot.connectionState == ConnectionState.waiting){
          return  Center(child: Text('Please wait its loading...'));
        }
        else {
          if (snapshot.hasError) {
            print(snapshot.error);
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          else {
            // getdata();

            if (snapshot.hasData) {
              print("snapshot.data.documents.length ${snapshot.data.documents.length}");
              if(snapshot.data.documents.length!=0){

                Timer(
                  Duration(microseconds: 1),
                      () => listScrollController.jumpTo(listScrollController.position.maxScrollExtent),
                );

                return
      ListView.builder(
        padding: EdgeInsets.all(10.0),


         itemBuilder: (context, index) {

           int type=snapshot.data.documents[index]["type"];
               String   message=snapshot.data.documents[index]["message"];
           String sender=snapshot.data.documents[index]["sender"];


           if(type==2) {
             print("sentByMe MessageTile I am in messageTile");
             return widget.userName ==
                 snapshot.data.documents[index]["sender"] ?
             Container(
               // margin: EdgeInsets.only(bottom: 30,top: 30),
               padding: EdgeInsets.only(
                   top: 4,
                   bottom: 4,
                   left: widget.userName ==
                       snapshot.data.documents[index]["sender"] ? 0 : 24,
                   right: widget.userName ==
                       snapshot.data.documents[index]["sender"] ? 24 : 0),
               alignment: widget.userName ==
                   snapshot.data.documents[index]["sender"] ? Alignment.centerRight : Alignment.centerLeft,
               /**/
               child: Column(
                 children: [
                   Text(sender.toUpperCase(), textAlign: TextAlign.start,
                       style: TextStyle(fontSize: 13.0,
                           fontWeight: FontWeight.bold,
                           color: Colors.black,
                           letterSpacing: -0.5)),
                   SizedBox(height: 7.0),
                   Container(
                     child: Image.asset("images/${message}.gif",
                       height: 100.0,
                       width: 100.0,
                       fit: BoxFit.cover,),
                     margin: EdgeInsets.only(bottom: 30),

                   ),
                 ],
               ),)


                 : Container(
               // margin: EdgeInsets.only(bottom: 30,top: 30),
               padding: EdgeInsets.only(
                   top: 4,
                   bottom: 4,
                   left: widget.userName ==
                       snapshot.data.documents[index]["sender"] ? 0 : 24,
                   right: widget.userName ==
                       snapshot.data.documents[index]["sender"] ? 24 : 0),
               alignment: widget.userName ==
                   snapshot.data.documents[index]["sender"] ? Alignment.centerRight : Alignment.centerLeft,
               child: Column(
                 children: [
                   Text(sender.toUpperCase(), textAlign: TextAlign.start,
                       style: TextStyle(fontSize: 13.0,
                           fontWeight: FontWeight.bold,
                           color: Colors.black,
                           letterSpacing: -0.5)),
                   SizedBox(height: 7.0),
                   Container(
                     child: Image.asset("images/${message}.gif",
                       height: 100.0,
                       width: 100.0,
                       fit: BoxFit.cover,),
                     margin: EdgeInsets.only(bottom: 30),

                   ),
                 ],
               ),
             );
           }
           else if(type==1){

             return widget.userName ==
                 snapshot.data.documents[index]["sender"] ?
             Container(
               // margin: EdgeInsets.only(bottom: 30,top: 30),
               padding: EdgeInsets.only(
                   top: 4,
                   bottom: 4,
                   left: widget.userName ==
                       snapshot.data.documents[index]["sender"] ? 0 : 24,
                   right: widget.userName ==
                       snapshot.data.documents[index]["sender"] ? 24 : 0),
               alignment: widget.userName ==
                   snapshot.data.documents[index]["sender"] ? Alignment.centerRight : Alignment.centerLeft,
               /**/
               child: Column(
                 children: [
                   Text(sender.toUpperCase(), textAlign: TextAlign.start,
                       style: TextStyle(fontSize: 13.0,
                           fontWeight: FontWeight.bold,
                           color: Colors.black,
                           letterSpacing: -0.5)),
                   SizedBox(height: 7.0),
                   Container(
                       child: FlatButton(
                           child:Material(

                             child: Image.memory(
                               (base64Decode(message)),
                               width: 200.0,
                               height: 200.0,
                               fit: BoxFit.cover,
                             ),
                             borderRadius: BorderRadius.all(Radius.circular(8.0)),
                             clipBehavior: Clip.hardEdge,
                           ),
                           onPressed: () {
                             Navigator.push(context, MaterialPageRoute(builder: (context)=> FullPhoto(url:message),),);

                           } )

                   ),
                 ],
               ),
             ):Container(
               // margin: EdgeInsets.only(bottom: 30,top: 30),
               padding: EdgeInsets.only(
                   top: 4,
                   bottom: 4,
                   left: widget.userName ==
                       snapshot.data.documents[index]["sender"] ? 0 : 24,
                   right: widget.userName ==
                       snapshot.data.documents[index]["sender"] ? 24 : 0),
               alignment: widget.userName ==
                   snapshot.data.documents[index]["sender"] ? Alignment.centerRight : Alignment.centerLeft,
               /**/
               child: Column(
                 children: [
                   Text(sender.toUpperCase(), textAlign: TextAlign.start,
                       style: TextStyle(fontSize: 13.0,
                           fontWeight: FontWeight.bold,
                           color: Colors.black,
                           letterSpacing: -0.5)),
                   SizedBox(height: 7.0),
                   Container(
                       child: FlatButton(
                           child:Material(

                             child: Image.memory(
                               (base64Decode(message)),
                               width: 200.0,
                               height: 200.0,
                               fit: BoxFit.cover,
                             ),
                             borderRadius: BorderRadius.all(Radius.circular(8.0)),
                             clipBehavior: Clip.hardEdge,
                           ),
                           onPressed: () {
                             Navigator.push(context, MaterialPageRoute(builder: (context)=> FullPhoto(url:message),),);

                           } )

                   ),
                 ],
               ),
             );
           }


           else{
             return Container(
               // margin: EdgeInsets.only(bottom: 30),
               padding: EdgeInsets.only(
                   top: 4,
                   bottom: 4,
                   left: widget.userName ==
                       snapshot.data.documents[index]["sender"] ? 0 : 24,
                   right: widget.userName ==
                       snapshot.data.documents[index]["sender"] ? 24 : 0),
               alignment: widget.userName ==
                   snapshot.data.documents[index]["sender"] ? Alignment.centerRight : Alignment.centerLeft,
               child: Container(
                 margin: widget.userName ==
                     snapshot.data.documents[index]["sender"] ? EdgeInsets.only(left: 30) : EdgeInsets.only(right: 30),
                 padding: EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
                 decoration: BoxDecoration(
                     borderRadius: widget.userName ==
                         snapshot.data.documents[index]["sender"] ? BorderRadius.only(
                         topLeft: Radius.circular(23),
                         topRight: Radius.circular(23),
                         bottomLeft: Radius.circular(23)
                     )
                         :
                     BorderRadius.only(
                         topLeft: Radius.circular(23),
                         topRight: Radius.circular(23),
                         bottomRight: Radius.circular(23)
                     ),
                     color: widget.userName ==
                         snapshot.data.documents[index]["sender"] ? Colors.lightBlueAccent : Colors.greenAccent
                 ),
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: <Widget>[

                     Text(sender.toUpperCase(), textAlign: TextAlign.start, style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.bold, color: Colors.black, letterSpacing: -0.5)),
                     SizedBox(height: 7.0),
                     Text(message, textAlign: TextAlign.start, style: TextStyle(fontSize: 15.0, color: Colors.white)),
                   ],
                 ),
               ),
             );
           }



           /*      return MessageTile(

             message: snapshot.data.documents[index]["message"],
             sender: snapshot.data.documents[index]["sender"],
             sentByMe: widget.userName ==
                 snapshot.data.documents[index]["sender"],
             type:snapshot.data.documents[index]["type"],


           );*/

         },

         //itemCount: snapshot.data.documents.length,
        // reverse: false,
         //controller: listScrollController,


        itemCount: snapshot.data.documents.length,


        controller: listScrollController,


    );

              }
              else{
                return Container();
              }

            }
            else {
              return Center(
                  child: CircularProgressIndicator()
              );
            }
          }

            }



          }

    );
  }

  _sendMessage(String txt,int type) {
    print("_sendMessage 123 ${txt} and ${type}");
    if(type==2){
      isDisplaySticker=false;
    }
    if (messageEditingController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {

        "message": messageEditingController.text,
        "sender": widget.userName,
        'time': DateTime.now().millisecondsSinceEpoch,
        "type":type,
      };


      print("chat page ${widget.groupId}");
      DatabaseService().sendMessage(widget.groupId, chatMessageMap);

      setState(() {
        messageEditingController.text = "";
      });
      listScrollController.animateTo(0.0,duration: Duration(microseconds: 300),curve: Curves.easeOut);
    }

    else{

      if(type==1){
        print("I am in type 1");
        Map<String, dynamic> chatMessageMap = {

          "message": txt,
          "sender": widget.userName,
          'time': DateTime.now().millisecondsSinceEpoch,
          "type":type,
        };


        print("chat page ${widget.groupId}");
        DatabaseService().sendMessage(widget.groupId, chatMessageMap);

        setState(() {
          //   messageEditingController.text = "";
        });
      }
      else{
        Map<String, dynamic> chatMessageMap = {

          "message": txt,
          "sender": widget.userName,
          'time': DateTime.now().millisecondsSinceEpoch,
          "type":type,
        };


        print("chat page ${widget.groupId}");
        DatabaseService().sendMessage(widget.groupId, chatMessageMap);

        setState(() {
          //   messageEditingController.text = "";
        });
      }

    }
    listScrollController.animateTo(0.0,duration: Duration(microseconds: 300),curve: Curves.easeOut);
  }

  @override
  void initState() {
    super.initState();
    focusNode.addListener(onFocusChange);
    isDisplaySticker=false;
//    listScrollController.animateTo(listScrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 500), curve: Curves.easeOut);

    DatabaseService().getChats(widget.groupId).then((val) {
      // print(val);
      setState(() {

        _chats = val;

      });
    });
  }

  @override
  Widget build(BuildContext context) {
/*Timer(
    Duration(microseconds:  1),
        () => listScrollController.jumpTo(listScrollController.position.maxScrollExtent),
  );*/

    //istScrollController.animateTo(0.0,duration: Duration(microseconds: 300),curve: Curves.easeOut);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.groupName, style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.teal,
        elevation: 0.0,
      ),
      body: Container(
        child: Stack(
          children: <Widget>[
          Image.asset(
              "images/background3.png",
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
           // _chatMessages(),
Container(
  margin: EdgeInsets.only(bottom: 60,top: 30),

 child: _chatMessages(),


),
            (isDisplaySticker?createSticker():Container()),
            // Container(),
            Container(
              alignment: Alignment.bottomCenter,
              width: MediaQuery.of(context).size.width,

              child: Container(
               padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                color: Colors.white,
                child: Row(
                  children: <Widget>[
                    Material(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 1.0),
                        child: IconButton(icon:Icon( Icons.image),
                          color: Colors.teal,
                          onPressed: () {

                            setState(() {
                              getPhotos();
                            });

                          },
                        ),
                      ),
                      color: Colors.white,
                    ),

                    Material(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 1.0),
                        child: IconButton(icon:Icon( Icons.face),
                          color: Colors.teal,
                          onPressed: () {
                            // isDisplaySticker=true;

                            print("face click event ${isDisplaySticker}");
                            if(isDisplaySticker){
                              isDisplaySticker=false;
                            }
                            else{
                              isDisplaySticker=true;
                            }
                            setState(() {
                              getSticker;
                            });

                          },
                        ),
                      ),
                      color: Colors.white,
                    ),

                    Expanded(
                      child: TextField(
                        controller: messageEditingController,
                        style: TextStyle(
                          color: Colors.black
                        ),
                        decoration: InputDecoration(
                          hintText: "Send a message ...",
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                          border: InputBorder.none
                        ),
                      ),
                    ),

                    SizedBox(width: 12.0),

                    GestureDetector(
                      onTap: () {
                        _sendMessage(messageEditingController.text,0);
                      },
                      child: Container(
                        height: 50.0,
                        width: 50.0,
                        decoration: BoxDecoration(
                          color: Colors.teal,
                          borderRadius: BorderRadius.circular(50)
                        ),
                        child: Center(child: Icon(Icons.send, color: Colors.white)),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  createSticker(){
    print("I am in createSticker");
    return Align(
        alignment: FractionalOffset.bottomCenter,
      child:Container(
        margin: EdgeInsets.only(bottom: 70.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FlatButton(
                  //onPressed: () =>onSendMessage("mimi1",2),
                  onPressed: () {
                    if(isDisplaySticker){
                      isDisplaySticker=false;
                    }
                    else{
                      isDisplaySticker=true;
                    }
                    setState(() {
                      //onSendMessage("mimi1",2);
                     // print("I am click on mimi 1_sendMessage ");
                      _sendMessage("mimi1",2);
                    });

                  },
                  child: Image.asset(
                    "images/mimi1.gif",
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                ),
                FlatButton(
                  onPressed: () {
                    if(isDisplaySticker){
                      isDisplaySticker=false;
                    }
                    else{
                      isDisplaySticker=true;
                    }
                    setState(() {
                      _sendMessage("mimi2",2);
                    });

                  },
                  child: Image.asset(
                    "images/mimi2.gif",
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                ),
                FlatButton(
                  onPressed: () {
                    if(isDisplaySticker){
                      isDisplaySticker=false;
                    }
                    else{
                      isDisplaySticker=true;
                    }
                    setState(() {
                      _sendMessage("mimi3",2);
                    });

                  },
                  child: Image.asset(
                    "images/mimi3.gif",
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),


            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FlatButton(
                  onPressed: () {
                    if(isDisplaySticker){
                      isDisplaySticker=false;
                    }
                    else{
                      isDisplaySticker=true;
                    }
                    setState(() {
                      _sendMessage("mimi4",2);
                    });

                  },
                  child: Image.asset(
                    "images/mimi4.gif",
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                ),
                FlatButton(
                  onPressed: () {
                    if(isDisplaySticker){
                      isDisplaySticker=false;
                    }
                    else{
                      isDisplaySticker=true;
                    }
                    setState(() {
                      _sendMessage("mimi5",2);
                    });

                  },
                  child: Image.asset(
                    "images/mimi5.gif",
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                ),
                FlatButton(
                  onPressed: () {
                    if(isDisplaySticker){
                      isDisplaySticker=false;
                    }
                    else{
                      isDisplaySticker=true;
                    }
                    setState(() {
                      _sendMessage("mimi6",2);
                    });

                  },
                  child: Image.asset(
                    "images/mimi6.gif",
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FlatButton(
                  onPressed: () {
                    if(isDisplaySticker){
                      isDisplaySticker=false;
                    }
                    else{
                      isDisplaySticker=true;
                    }
                    setState(() {
                      _sendMessage("mimi7",2);
                    });

                  },
                  //onPressed: onSendMessage("mimi7",2),
                  child: Image.asset(
                    "images/mimi7.gif",
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                ),
                FlatButton(
                  onPressed: () {
                    if(isDisplaySticker){
                      isDisplaySticker=false;
                    }
                    else{
                      isDisplaySticker=true;
                    }
                    setState(() {
                      _sendMessage("mimi8",2);
                    });

                  },
                  child: Image.asset(
                    "images/mimi8.gif",
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                ),
                FlatButton(
                  onPressed: () {
                    if(isDisplaySticker){
                      isDisplaySticker=false;
                    }
                    else{
                      isDisplaySticker=true;
                    }
                    setState(() {
                      _sendMessage("mimi9",2);
                    });

                  },
                  child: Image.asset(
                    "images/mimi9.gif",
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        ),
        decoration: BoxDecoration(
          border: Border(
              top: BorderSide(color: Colors.grey,width: 0.5)
          ),
          color: Colors.white,

        ),
        padding: EdgeInsets.all(5.0),
        height: 180.0,
      )

    );
  }
  void getSticker(){
    print("I am in getSticker ${isDisplaySticker}");
    focusNode.unfocus();
    setState(() {
      isDisplaySticker=!isDisplaySticker;
    });
    print("I am in getSticker123 ${isDisplaySticker}");
  }
/*  bool isLastMsgLeft(int index){
    if((index>0 && listMessage != null && listMessage[index-1] ["idFrom"] == id ) || index==0){
      return true;
    }
    else{
      return false;
    }
  }
  bool isLastMsgRight(int index){
    if((index>0 && listMessage != null && listMessage[index-1] ["idFrom"] != id ) || index==0){
      return true;
    }
    else{
      return false;
    }
  }*/

  Future getPhotos() async{


    var mediaData = await ImagePickerWeb.getImageInfo;

    String mimeType = mime(Path.basename(mediaData.fileName));
    html.File mediaFile =
    new html.File(mediaData.data, mediaData.fileName, {'type': mimeType});

    print("imageFile123 ${mediaData.toString()}");

    if (mediaData != null) {
      currentSelfie = mediaData.data;
      imageString = base64Encode(currentSelfie);
      //print("utsav  ${currentSelfie.toString()}");
      print("utsav  ${imageString.toString()}");
    }

    String url;
    // var bytes = await mediaData.data.readAsBytes();
    try {
      String fileName=DateTime.now().millisecondsSinceEpoch.toString();
      fb.StorageReference _storage = fb.storage().ref().child('Chat Images').child(fileName);
      fb.UploadTaskSnapshot uploadTaskSnapshot = await _storage.put(mediaData.data, fb.UploadMetadata(contentType: 'image/png')).future;
      var imageUri = await uploadTaskSnapshot.ref.getDownloadURL();
      imageUrl = imageUri.toString();
      print("url 123 ${imageUrl}");
      setState(() {
        isLoading=false;
        _sendMessage(imageString,1);
      });
    } catch (e) {
      setState(() {
        isLoading=false;

      });
      Fluttertoast.showToast(msg: "Error: "+e);
      print(e);
    }
/*    if (mediaData != null) {
      currentSelfie = mediaData.data;
      imageString = base64Encode(currentSelfie);
      print("utsav  ${currentSelfie.toString()}");

    }*/
  }
}
