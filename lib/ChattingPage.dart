import 'dart:async';
import 'dart:html' as html;
import 'dart:math';
//import 'package:universal_html/html.dart';
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

class Chat extends StatelessWidget {
  String receiverId;

  String receiverAvatar;
  String receiverName;
  var currentSelfieReceiver;
  FileType fileType=FileType.any;
  Chat({
Key key,@required this.receiverId,@required this.receiverAvatar,@required this.receiverName
  });

  @override
  Widget build(BuildContext context) {
    final decodedBytes = base64Decode(receiverAvatar);
    print("decodedBytes ${decodedBytes}");
     var currentSelfie=decodedBytes;
    currentSelfieReceiver=decodedBytes;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        actions: [
          Padding(padding: EdgeInsets.all(8.0),
              child: ClipOval(child:currentSelfie.length !=0? new Image.memory(currentSelfie):new Image.asset(
                "images/profile.png",
                   fit: BoxFit.contain,
              ),)
          )
        ],
        iconTheme: IconThemeData(
          color: Colors.white,

        ),
        title: Text(receiverName,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
centerTitle: true,
      ),
      body: ChatScreen(receiverId:receiverId,receiverAvatar:receiverAvatar),
    );
  }
}

class ChatScreen extends StatefulWidget {
  String receiverId;
  String receiverAvatar;
  var pdfString;
  String _filePath;
  ChatScreen({
    Key key,@required this.receiverId,@required this.receiverAvatar
  }):super(key:key);


  @override
  State createState() => ChatScreenState(receiverId:receiverId,receiverAvatar:receiverAvatar);
}




class ChatScreenState extends State<ChatScreen> {
  String receiverId;
  String receiverAvatar;
  String pdfBytesString;
  var currentSelfie;
  var imageString="";
  String imageUrl;
  String chatId;
  var listMessage;
  SharedPreferences preferences;

  ChatScreenState({
    Key key,@required this.receiverId,@required this.receiverAvatar
  });
   TextEditingController textEditingController=TextEditingController();
   final ScrollController listScrollController=ScrollController();

   FocusNode focusNode=FocusNode();
   bool isDisplaySticker;
   bool isLoading;
  String id;

   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    focusNode.addListener(onFocusChange);
    isDisplaySticker=false;
    isLoading=false;
    chatId="";


    readLocal();
  }

  readLocal() async{

    SharedPreferences prefs = await SharedPreferences.getInstance();
    id=prefs.getString("id")??  "";
    print("id welcome==> ${id}   ");
    print("id welcome==> ${receiverId}   ");
    if(id.hashCode <= receiverId.hashCode){
      chatId='$id-$receiverId';
      print("id welcome chatId if==> ${chatId}  ");
    }
    else{
      chatId='$receiverId-$id';
      print("id welcome chatId else==> ${chatId}  ");
    }
    FirebaseFirestore.instance.collection("users").doc(id).update({
    'chattingWith':receiverId
    });
    setState(() {
     //createListMessage;
    });
  }

  onFocusChange(){
     print("focus textField ${focusNode.hasFocus}");
     if(focusNode.hasFocus){
     setState(() {
       //hide sticker when keyboard appear
       isDisplaySticker=false;
     });
     }
  }
  @override
  Widget build(BuildContext context) {
    print("isDisplaySticker  123 ${isDisplaySticker}");
      return WillPopScope(

        child: Stack(

        children: [
          Image.asset(
            "images/background3.png",
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
       Column(
         children: [
           //create list of message

           createListMessage(),
          //show stickers


           (isDisplaySticker?createSticker():Container()),

           //input controllers
           createInputs(),
         ],
       ),
        createLoading(),
        ],
        ),
        onWillPop: onBackPress,
      );
  }

  createLoading(){
     return Positioned(
       child: isLoading?CircularProgressIndicator():Container(),
     );
  }
  Future<bool> onBackPress(){
  if(isDisplaySticker){
    setState(() {
      isDisplaySticker=false;
    });
  }
  else{
    Navigator.pop(context);
  }
  return Future.value(false);
  }
  createSticker(){
     print("I am in createSticker");
     return Container(
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
              onSendMessage("mimi1",2);
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
              onSendMessage("mimi2",2);
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
              onSendMessage("mimi3",2);
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
                     onSendMessage("mimi4",2);
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
                     onSendMessage("mimi5",2);
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
                     onSendMessage("mimi6",2);
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
                     onSendMessage("mimi7",2);
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
                     onSendMessage("mimi8",2);
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
                     onSendMessage("mimi9",2);
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
     );
  }

  createListMessage(){
     print("I am in createListMessage Method chatId ${chatId}");
    return Flexible(

      child: chatId ==""?
       Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.lightBlueAccent),
        ),
      )
      : StreamBuilder(

        stream: FirebaseFirestore.instance.collection("messages").doc(chatId).collection(chatId).orderBy("timestamp",descending: true).
          limit(20).snapshots(),

        builder: (context,snapshot){
          print("createListMessage has data utsav ${snapshot.hasData}");
          if(!snapshot.hasData){
            print("listMessage utsav 12 ");
            return  Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.lightBlueAccent),
              ),
            );
          }
          else{

            listMessage=snapshot.data.documents;
            print("listMessage utsav else 123 ${snapshot.data.documents.length}");
            return ListView.builder(
              padding: EdgeInsets.all(10.0),
              itemBuilder: (context, index) {
                print("listMessage utsav else 123 itemBuilder ${snapshot.data.documents[index]["type"]}");
               // createItem(index,snapshot.data.documents[index]);
                print("document createItem ${snapshot.data.documents[index]["idFrom"] }");
                print("document createItem id ${id}");
               print("document createItem id ${snapshot.data.documents[index]["idFrom"] == id}");

                 print("utsav is doing ${snapshot.data.documents[index]["type"]} and ${snapshot.data.documents[index]["content"]}");
                 if(snapshot.data.documents[index]["idFrom"] == id){
                  return Row(
                    children: [

                      snapshot.data.documents[index]["type"]== 0
                      //text message

                          ?
                      Container(
                        child: Text(snapshot.data.documents[index]["content"],style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500),),
                        padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                        width: 200.0,
                        decoration: BoxDecoration(color: Colors.lightBlueAccent,borderRadius: BorderRadius.circular(8.0)),
                        margin: EdgeInsets.only(bottom: isLastMsgRight(index)?20.0:10.0,right: 10.0),
                      )
                      //img file
                          :snapshot.data.documents[index]["type"]==1?
                      Container(
                        child: FlatButton(
                          child:Material(

                            child: Image.memory(
                              (base64Decode(snapshot.data.documents[index]["content"])),
                              width: 200.0,
                              height: 200.0,
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(8.0)),
                            clipBehavior: Clip.hardEdge,
                          ),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> FullPhoto(url:snapshot.data.documents[index]["content"])
                            ));
                          },
                        ),
                        margin: EdgeInsets.only(bottom: isLastMsgRight(index)?20.0:10.0,right: 10.0),

                      ):snapshot.data.documents[index]["type"]==3?
                      Container(
                        child: FlatButton(
                          child:Material(

                            child: Image.asset(
                              "images/pdf.png",
                              width: 100.0,
                              height: 200.0,
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(8.0)),
                            clipBehavior: Clip.hardEdge,
                          ),
                          onPressed: () {
//                            Navigator.push(context, MaterialPageRoute(builder: (context)=> FullPhoto(url:snapshot.data.documents[index]["content"])
  //                          ));
                        //   var str = snapshot.data.documents[index]["content"].replace(snapshot.data.documents[index]["content"].substring(snapshot.data.documents[index]["content"].length()-1), "");
                            print("I am on sender on pressed button");
                            //print("_bytesData  I am here ==>"+_bytesData.toString());
/*
                            var result = snapshot.data.documents[index]["content"];
                            result = result.replaceAll(RegExp('"'), ''); // abc*/
                            Uint8List  _bytesData = Base64Decoder().convert(snapshot.data.documents[index]["content"].split(",").last);
                            final pdfBytes=_bytesData;
                            final blob = html.Blob([pdfBytes], 'application/pdf');
                            final url = html.Url.createObjectUrlFromBlob(blob);
                            html.window.open(url, "_blank");
                            html.Url.revokeObjectUrl(url);


                          },
                        ),
                        margin: EdgeInsets.only(bottom: isLastMsgRight(index)?20.0:10.0,right: 10.0),

                      )
                      //sticker gif
                          :  Container(
                        child: Image.asset("images/${snapshot.data.documents[index]['content']}.gif",
                          height: 100.0,
                          width: 100.0,
                          fit:BoxFit.cover,),
                        margin: EdgeInsets.only(bottom: isLastMsgRight(index)?20.0:10.0,right: 10.0),

                      ),

                    ],
                    mainAxisAlignment: MainAxisAlignment.end,
                  );
    }
                else{
                   final decodedBytes = base64Decode(receiverAvatar);
                   print("decodedBytes ${decodedBytes}");
                   var currentSelfieReceiver=decodedBytes;
                  return Container(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            isLastMsgLeft(index)?Material(

                              //display receiver profile image
                        child: ClipOval(child:currentSelfieReceiver.length !=0? new Image.memory(currentSelfieReceiver,     width: 35.0,
                          height: 35.0,
                          fit: BoxFit.cover,):new Image.asset(
                          "images/profile.png",
                          fit: BoxFit.contain,
                          width: 35.0,
                          height: 35.0,
                        ),),
                        borderRadius: BorderRadius.all(Radius.circular(18.0)),
                clipBehavior: Clip.hardEdge,
                            )
                                :Container(width: 35.0,),

                            //display messages
                            snapshot.data.documents[index]["type"]==0
                            //text message
                                ?     Container(
                              child: Text(snapshot.data.documents[index]["content"],style: TextStyle(color: Colors.black,fontWeight: FontWeight.w400),),
                              padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                              width: 200.0,
                              decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(8.0)),
                              margin: EdgeInsets.only(left: 10.0),
                            )
                                :snapshot.data.documents[index]["type"]==1?
                            Container(
                              child: FlatButton(
                                child:Material(
                                  child: Image.memory(
                                    (base64Decode(snapshot.data.documents[index]["content"])),
                                    width: 200.0,
                                    height: 200.0,
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                  clipBehavior: Clip.hardEdge,
                                ),
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> FullPhoto(url:snapshot.data.documents[index]["content"])
                                  ));
                                },
                              ),
                              margin: EdgeInsets.only(left: 10.0),

                            )
                                :snapshot.data.documents[index]["type"]==3?
                            Container(
                              child: FlatButton(
                                child:Material(
                                  child: Image.asset(
                                    "images/pdf.png",
                                    width: 100.0,
                                    height: 200.0,
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                  clipBehavior: Clip.hardEdge,
                                ),
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> FullPhoto(url:snapshot.data.documents[index]["content"])
                                  ));
                                },
                              ),
                              margin: EdgeInsets.only(left: 10.0),

                            )

                                :  Container(
                              child: Image.asset("images/${snapshot.data.documents[index]['content']}.gif",
                                height: 100.0,
                                width: 100.0,
                                fit:BoxFit.cover,),
                              margin: EdgeInsets.only(bottom: isLastMsgRight(index)?20.0:10.0,right: 10.0),

                            ),


                          ],
                        ),
                        //msg time

                        isLastMsgLeft(index)
                            ?Container(
                          child: Text(
                            DateFormat("dd MMMM,yyyy - hh:mm:aa").format(DateTime.fromMillisecondsSinceEpoch(int.parse(snapshot.data.documents[index]["timestamp"]))),
                            style: TextStyle(fontStyle: FontStyle.italic,fontSize:12.0,color: Colors.grey),
                          ),
                          margin: EdgeInsets.only(left: 50.0,top: 50.0,bottom: 5.0),
                        )
                            :Container()
                      ],
                      crossAxisAlignment: CrossAxisAlignment.start,
                    ),
                    margin: EdgeInsets.only(bottom: 10.0),
                  );
                }





              },
                itemCount: snapshot.data.documents.length,
              reverse: true,
              controller: listScrollController,
            );
          }

        },
      ),
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

  createInputs(){
    return Container(
      child: Row(
        children: [
          //pick image
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
      //emoji
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
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1.0),
              child: IconButton(icon:Icon( Icons.attach_file),
                color: Colors.teal,
                onPressed: () {

                  setState(() {
                    //getPdfAndUpload();
                   // getFilePath;
                    startWebFilePicker();

                   // Navigator.of(context).push(MaterialPageRoute(builder: (context) => FilePicker()));

                  });

                },
              ),
            ),
            color: Colors.white,
          ),
          //TextField
          Flexible(
            child: Container(
              child: TextField(
    style: TextStyle(color: Colors.black,fontSize: 15.0),
                controller: textEditingController,
                decoration: InputDecoration.collapsed(
                  hintStyle: TextStyle(color: Colors.grey),
                  hintText: "Write here....."
                ),
                focusNode: focusNode,
    ),

            )
          ),
          //send message icon button
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8.0),
              child: IconButton(
                icon: Icon(Icons.send),
                color: Colors.teal,
                onPressed: () {
                  onSendMessage(textEditingController.text,0);
                },
              ),
            ),
            color: Colors.white,
          )
        ],
      ),
      width: double.infinity,
      height: 50.0,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.grey,
            width: 0.5,
          )
        ),
        color: Colors.white
      ),
    );
  }
  startWebFilePicker() async {


    html.InputElement uploadInput = html.FileUploadInputElement();
    uploadInput.multiple = true;
    uploadInput.draggable = true;
    uploadInput.click();

    uploadInput.onChange.listen((e) {
      final files = uploadInput.files;
      final file = files[0];
      final reader = new html.FileReader();

      reader.onLoadEnd.listen((e) {
        _handleResult(reader.result);
      });
      reader.readAsDataUrl(file);

    });

    // String path = await FilePicker.getFilePath(type: fileType? fileType: FileType.any, allowedExtensions: extensions);



  }
  void _handleResult(Object result) {
    print("I am in _handleResult  ${result.toString()}");

    setState(() {




      Uint8List  _bytesData = Base64Decoder().convert(result.toString().split(",").last);
      //print("_bytesData  I am here ==>"+_bytesData.toString());
      final pdfBytes=_bytesData;
      List<int> _selectedFile = _bytesData;
     // print("_handleResult==>${_bytesData.toString()}");
      var base64Str = base64.encode(_bytesData);
     // print("base64Strring==>${pdfBytes.toString()}");
     // print("I am here 123");
      onSendMessage(result.toString(), 3);


  //    pdfBytesString=pdfBytes.toString();

  /*    var base64Str = base64.encode(_bytesData);
      print("base64Strring==>${base64Str.toString()}");*/
    //
/*    final blob=html.Blob(pdfBytes,'application/pdf');
      final url=html.Url.createObjectUrl(blob);
      html.window.open(url,'_blank');*/


/*   final base64Str=base64Encode(_selectedFile);
   html.window.open("data:application/pdf;base64,$base64Str", '_blank');*/

/*

      //view pdf file
      final blob = html.Blob([pdfBytes], 'application/pdf');
      final url = html.Url.createObjectUrlFromBlob(blob);
    //  html.window.open(url, "_blank");
    //  html.Url.revokeObjectUrl(url);


     // final url1 = html.Url.createObjectUrlFromBlob(blob);

      //download pdf file
      final anchor =
      html.document.createElement('a') as html.AnchorElement
        ..href = url
        ..style.display = 'none'
        ..download = 'some_name.pdf';
      html.document.body.children.add(anchor);
      anchor.click();
      html.document.body.children.remove(anchor);
        html.Url.revokeObjectUrl(url);
*/

        });
  }

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
        onSendMessage(imageString,1);
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

  void onSendMessage(String contentMsg,int type){
      //type=0   it is text message
    //type=1  it is image File
    //type=2 it is git file

    print("content message ${contentMsg} and type ${type}");
print("type utsav123==> ${type} and ${isDisplaySticker}");
    if(type==2){
      isDisplaySticker=false;
    }
    if(contentMsg != ""){



      textEditingController.clear();
      var docRef=FirebaseFirestore.instance.collection("messages").doc(chatId).collection(chatId).doc(DateTime.now().millisecondsSinceEpoch.toString());
  FirebaseFirestore.instance.runTransaction((transaction) async{
    await transaction.set(docRef, {
      "idFrom":id,
      "idTo":receiverId,
      "timestamp":DateTime.now().millisecondsSinceEpoch.toString(),
      "content":contentMsg,
      "type":type
    },);
  });
      listScrollController.animateTo(0.0,duration: Duration(microseconds: 300),curve: Curves.easeOut);
    }
    else{
      Fluttertoast.showToast(msg: "Empty Message.Can not be send");
    }
  }
 /* Widget createItem(int index,DocumentSnapshot document){
   //My message  Right side
print("document createItem ${document["idFrom"] }");
print("document createItem id ${id}");
print("document createItem id ${document["idFrom"] == id}");
    if(document["idFrom"] == id){
   print("utsav is doing ${document["type"]} and ${document["content"]}");
      return Row(
        children: [

          document["type"]== 0
              //text message

              ?    Container(
            child: Text("Utsav Pajave"),
          )
        *//*  Container(
            child: Text(document["content"],style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500),),
            padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 500.0),
            width: 200.0,
            decoration: BoxDecoration(color: Colors.lightBlueAccent,borderRadius: BorderRadius.circular(8.0)),
            margin: EdgeInsets.only(bottom: isLastMsgRight(index)?20.0:10.0,right: 10.0),
          )*//*
          //img file
        *//*      :document["type"]==1?
          Container(
            child: FlatButton(
              child:Material(
                child:CachedNetworkImage(
                  placeholder: (context,url) => Container(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.lightBlueAccent),
                    ),
                    height: 200.0,
                    width: 200.0,
                    padding: EdgeInsets.all(70.0),
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),

                    ),
                  ),
                  errorWidget: (context,url,error)=>Material(
                    child: Image.asset(
                      "images/img_not_available.jpeg",
                      width: 200.0,
                      height: 200.0,
                      fit: BoxFit.cover,
                    ),
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    clipBehavior: Clip.hardEdge,
                  ),


                  imageUrl: document["content"],
                  height: 200.0,
                  width: 200.0,
                  fit: BoxFit.cover,

                ),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                clipBehavior: Clip.hardEdge,
              ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> FullPhoto(url:document["content"])
                    ));
                  },
            ),
            margin: EdgeInsets.only(bottom: isLastMsgRight(index)?20.0:10.0,right: 10.0),

          )*//*
          //sticker gif
              :  Container(
            child: Image.asset("images/${document['content']}.gif",
              height: 100.0,
              width: 100.0,
              fit:BoxFit.cover,),
            margin: EdgeInsets.only(bottom: isLastMsgRight(index)?20.0:10.0,right: 10.0),

          ),

        ],
        mainAxisAlignment: MainAxisAlignment.end,
      );
    }
    //receiver side message  Left side
    else{
      return Container(
        child: Column(
          children: [
            Row(
            children: [
              isLastMsgLeft(index)?Material(
                //display receiver profile image
                child: CachedNetworkImage(
                  placeholder: (context,url) => Container(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.lightBlueAccent),
                    ),
                    height: 35.0,
                    width: 35.0,
                    padding: EdgeInsets.all(10.0),

                  ),
                  errorWidget: (context,url,error)=>Material(
                    child: Image.asset(
                      "images/img_not_available.jpeg",
                      height: 35.0,
                      width: 35.0,
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    clipBehavior: Clip.hardEdge,
                  ),
                  imageUrl: receiverAvatar,
                  width: 35.0,
                  height: 35.0,
                  fit: BoxFit.cover,

                ),
                borderRadius: BorderRadius.all(Radius.circular(18.0)),
                clipBehavior: Clip.hardEdge,
              )
                  :Container(width: 35.0,),

              //display messages
              document["type"]==0
              //text message
                  ?     Container(
                child: Text(document["content"],style: TextStyle(color: Colors.black,fontWeight: FontWeight.w400),),
                padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                width: 200.0,
                decoration: BoxDecoration(color: Colors.grey[200],borderRadius: BorderRadius.circular(8.0)),
                margin: EdgeInsets.only(left: 10.0),
              )
                  :document["type"]==1?
              Container(
                child: FlatButton(
                  child:Material(
                    child:CachedNetworkImage(
                      placeholder: (context,url) => Container(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.lightBlueAccent),
                        ),
                        height: 200.0,
                        width: 200.0,
                        padding: EdgeInsets.all(70.0),
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),

                        ),
                      ),
                      errorWidget: (context,url,error)=>Material(
                        child: Image.asset(
                          "images/img_not_available.jpeg",
                          width: 200.0,
                          height: 200.0,
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        clipBehavior: Clip.hardEdge,
                      ),
                      imageUrl: document["content"],
                      height: 200.0,
                      width: 200.0,
                      fit: BoxFit.cover,

                    ),
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    clipBehavior: Clip.hardEdge,
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> FullPhoto(url:document["content"])
                    ));
                  },
                ),
                margin: EdgeInsets.only(left: 10.0),

              )
                  :  Container(
                child: Image.asset("images/${document['content']}.gif",
                  height: 100.0,
                  width: 100.0,
                  fit:BoxFit.cover,),
                margin: EdgeInsets.only(bottom: isLastMsgRight(index)?20.0:10.0,right: 10.0),

              ),


            ],
            ),
        //msg time

            isLastMsgLeft(index)
            ?Container(
              child: Text(
                DateFormat("dd MMMM,yyyy - hh:mm:aa").format(DateTime.fromMillisecondsSinceEpoch(int.parse(document["timestamp"]))),
                style: TextStyle(fontStyle: FontStyle.italic,fontSize:12.0,color: Colors.grey),
              ),
              margin: EdgeInsets.only(left: 50.0,top: 50.0,bottom: 5.0),
            )
                :Container()
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        margin: EdgeInsets.only(bottom: 10.0),
      );
    }
  }*/
  bool isLastMsgLeft(int index){
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
  }

  Future getPdfAndUpload()async{
    print("I am in getPdfAndUpload Method==>");
    var mediaData = await ImagePickerWeb.getImageInfo;
    String mimeType = mime(Path.basename(mediaData.fileName));
    html.File mediaFile =
    new html.File(mediaData.data, mediaData.fileName, {'type': mimeType});

    print("imageFile123 ${mediaData.toString()}");


    var rng = new Random();
    String randomName="";
    for (var i = 0; i < 20; i++) {
      print(rng.nextInt(100));
      randomName += rng.nextInt(100).toString();
    }
    File file = await FilePicker.getFile(type: FileType.custom);
    String fileName = '${randomName}.pdf';
    print("I am in getPdfAndUpload fileName==> ${fileName.toString()}");
   // print("I am in getPdfAndUpload==> ${file.readAsBytesSync()}");
   // savePdf(file.readAsBytesSync(), fileName);
  }

 /* Future savePdf(List<int> asset, String name) async {
    String fileName=DateTime.now().millisecondsSinceEpoch.toString();
    fb.StorageReference _storage1  = fb.storage().ref().child("Pdf").child(fileName);
    fb.StorageUploadTask uploadTask = _storage1.putData(asset);
    String url = await (await uploadTask.onComplete).ref.getDownloadURL();
    print(url);
    documentFileUpload(url);
    return  url;


    String fileName=DateTime.now().millisecondsSinceEpoch.toString();
    fb.StorageReference _storage = fb.storage().ref().child('Chat Images').child(fileName);
    fb.UploadTaskSnapshot uploadTaskSnapshot = await _storage.put(mediaData.data, fb.UploadMetadata(contentType: 'image/png')).future;
  }*/


}