import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'chat_page.dart';

class GroupTile extends StatelessWidget {
  final String userName;
  final String groupId;
  final String groupName;

  GroupTile({this.userName, this.groupId, this.groupName});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        print("GroupTile ${userName}");
        print("groupId ${groupId}");
        print("groupName ${groupName}");
        //Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage(groupId: groupId, userName: userName, groupName: groupName,)));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30.0,
            backgroundColor: Colors.teal,
            child: Text(groupName.substring(0, 1).toUpperCase(), textAlign: TextAlign.center, style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
          ),
          title: Text(groupName, style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text("Join the conversation as $userName", style: TextStyle(fontSize: 13.0)),
        ),
      ),
    );
  }
}