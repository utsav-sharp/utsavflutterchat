import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutterchat/Widgets/FullImageWidget.dart';



class MessageTile extends StatelessWidget {

  final String message;
  final String sender;
  final bool sentByMe;
  final int type;

  MessageTile({this.message, this.sender, this.sentByMe,this.type});


  @override
  Widget build(BuildContext context) {
    print("sentByMe MessageTile ${sentByMe} and ${type} and ${message}");

    if(type==2) {
      print("sentByMe MessageTile I am in messageTile");
      return sentByMe ?
      Container(
       // margin: EdgeInsets.only(bottom: 30,top: 30),
        padding: EdgeInsets.only(
            top: 4,
            bottom: 4,
            left: sentByMe ? 0 : 24,
            right: sentByMe ? 24 : 0),
        alignment: sentByMe ? Alignment.centerRight : Alignment.centerLeft,
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
            left: sentByMe ? 0 : 24,
            right: sentByMe ? 24 : 0),
        alignment: sentByMe ? Alignment.centerRight : Alignment.centerLeft,
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

      return sentByMe ?
      Container(
        // margin: EdgeInsets.only(bottom: 30,top: 30),
        padding: EdgeInsets.only(
            top: 4,
            bottom: 4,
            left: sentByMe ? 0 : 24,
            right: sentByMe ? 24 : 0),
        alignment: sentByMe ? Alignment.centerRight : Alignment.centerLeft,
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
            left: sentByMe ? 0 : 24,
            right: sentByMe ? 24 : 0),
        alignment: sentByMe ? Alignment.centerRight : Alignment.centerLeft,
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
    left: sentByMe ? 0 : 24,
    right: sentByMe ? 24 : 0),
    alignment: sentByMe ? Alignment.centerRight : Alignment.centerLeft,
    child: Container(
    margin: sentByMe ? EdgeInsets.only(left: 30) : EdgeInsets.only(right: 30),
    padding: EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
    decoration: BoxDecoration(
    borderRadius: sentByMe ? BorderRadius.only(
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
    color: sentByMe ? Colors.lightBlueAccent : Colors.greenAccent
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



  }
}