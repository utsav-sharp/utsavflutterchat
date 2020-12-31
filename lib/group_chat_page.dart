import 'group_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'helper_functions.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth_;
import 'database_service.dart';
import 'search_page.dart';
import 'checkbox_list_title.dart';
import 'home_screen.dart';

/*class  GroupChatPage extends StatelessWidget {

  final String currentUserId;
  final String currentUserName;


  GroupChatPage({Key key, this.currentUserId,this.currentUserName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body:GroupChatPage_() ,
    );
  }
}*/

class GroupChatPage extends StatefulWidget {
  final String currentUserId;
  final String currentUserName;
final String comingFrom;
  List<Offset> pointList = <Offset>[];

  GroupChatPage({Key key, this.currentUserId,this.currentUserName,this.comingFrom}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<GroupChatPage> {
  bool _isChecked = false;
  // data
  List<String> groupList = [];
  FirebaseUser _user;
  String _groupName;
  String _userName = '';
  String _email = '';
  Stream _groups;
  Map<String, bool> numbers = {
    'One' : false,
    'Two' : false,
    'Three' : false,
    'Four' : false,
    'Five' : false,
    'Six' : false,
    'Seven' : false,
    'Eight' : false,
    'Nine' : false,

  };



  // initState
  @override
  void initState() {
    super.initState();
    _getUserAuthAndJoinedGroups();

    print("comingFrom==>${widget.comingFrom}");

  }


  // widgets
  Widget noGroupWidget() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
                onTap: () {
                  _popupDialog(context);
                },
                child: Icon(Icons.group_add, color: Colors.teal, size: 75.0)
            ),
            SizedBox(height: 20.0),
            Text("You've not joined any group, tap on the 'add' icon to create a group or search for groups by tapping on the search button below."),
          ],
        )
    );
  }



  Widget groupsList() {
    return StreamBuilder(

      stream: FirebaseFirestore.instance.collection("users").doc(widget.currentUserId).snapshots(),



      builder: (context, snapshot) {
        print("I am here utsav pustav ${snapshot.hasData}");
       // print("I am here utsav pustav ${snapshot.data['groups'].length}");
    if( snapshot.connectionState == ConnectionState.waiting){
    return  Center(child: Text('Please wait its loading...'));
    }else {
      if (snapshot.hasError) {
        print(snapshot.error);
        return Center(child: Text('Error: ${snapshot.error}'));
      }
      else {
       // getdata();
print("a I am here ");
print("I am here ${snapshot == null} and ${snapshot.data}");
        if(snapshot.hasData) {
          if(snapshot.data['groups'] != null) {
            print("I am here utsav pustav ${snapshot.data['groups'].length}");
            if(snapshot.data['groups'].length != 0) {
              return ListView.builder(
                  itemCount: snapshot.data['groups'].length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    int reqIndex = snapshot.data['groups'].length - index - 1;
                 //   int reqIndex1 = snapshot.data['groupPhotoUrl'].length - index - 1;

                    //print("adadad ${_destructureName(snapshot.data['groupPhotoUrl'][reqIndex])}");
                    String strList = snapshot.data['groups'][reqIndex];
                    print(strList.split('_'));

                   return GroupTile(userName: snapshot.data['nickname'], groupId: _destructureId(snapshot.data['groups'][reqIndex]), groupName: _destructureName(snapshot.data['groups'][reqIndex]));
                    //return GroupTile(userName: snapshot.data['nickname'], groupId: strList[0], groupName:strList[1]);

                  }
              );
            }
            else {
              return noGroupWidget();
            }
          }
          else {
            return noGroupWidget();
          }
        }
        else {
          return Center(
              child: CircularProgressIndicator()
          );
        }


      }
    }


      },
    );
  }


  // functions
  _getUserAuthAndJoinedGroups() async {
    /*  final auth_.FirebaseAuth auth = auth_.FirebaseAuth.instance;
    final uid = auth.currentUser.uid;*/
    _user =  await FirebaseAuth.instance.currentUser;
    print("I am here bro please check user id ${_user.uid}");
    await HelperFunctions.getUserNameSharedPreference().then((value) {
      setState(() {
        _userName = value;
      });
    });
    DatabaseService(uid: _user.uid).getUserGroups().then((snapshots) {
      // print(snapshots);
      setState(() {
        _groups = snapshots;
      });
    });
    await HelperFunctions.getUserEmailSharedPreference().then((value) {
      setState(() {
        _email = value;
      });
    });
  }


  String _destructureId(String res) {
    // print(res.substring(0, res.indexOf('_')));
    return res.substring(0, res.indexOf('_'));
  }


  String _destructureName(String res) {
    // print(res.substring(res.indexOf('_') + 1));
    return res.substring(res.indexOf('_') + 1);
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
            print("_user.uid==> ${widget.currentUserId}");
            print("_user.uid==> ${widget.currentUserName}");
            print("_groupName==> ${_groupName}");

          });
          Navigator.of(context).pop();
        }
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Create a group"),
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


  // Building the HomePage widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.white,
          onPressed: () {

           Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomePage(currentUserId:widget.currentUserId)));


          },

        ),

        title: Text('Groups', style: TextStyle(color: Colors.white, fontSize: 27.0, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.teal,
        elevation: 0.0,
        actions: <Widget>[
         /* IconButton(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              icon: Icon(Icons.search, color: Colors.white, size: 25.0),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchPage(userId: widget.currentUserId, userName: widget.currentUserName)));
              }
          )*/
        ],
      ),
      /*drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 50.0),
          children: <Widget>[
            Icon(Icons.account_circle, size: 150.0, color: Colors.grey[700]),
            SizedBox(height: 15.0),
            Text(_userName, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 7.0),
            ListTile(
              onTap: () {},
              selected: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              leading: Icon(Icons.group),
              title: Text('Groups'),
            ),
            ListTile(
              onTap: () {
                // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ProfilePage(userName: _userName, email: _email)));
              },
              contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              leading: Icon(Icons.account_circle),
              title: Text('Profile'),
            ),
            ListTile(
              onTap: () async {
                *//*      await _auth.signOut();
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => AuthenticatePage()), (Route<dynamic> route) => false);
             *//* },
              contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              leading: Icon(Icons.exit_to_app, color: Colors.red),
              title: Text('Log Out', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ),*/
      body: groupsList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
        //_popupDialog(context);
         // Navigator.of(context).push(MaterialPageRoute(builder: (context) => GroupChatPage()));


          displayUserFoundScreen();

         // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => CheckBox(currentUserId: widget.currentUserId, currentUserName: widget.currentUserName)));

        },
        child: Icon(Icons.group_add, color: Colors.white, size: 30.0),
        backgroundColor: Colors.teal,
        elevation: 0.0,
      ),
    );
  }
  Future<DocumentSnapshot> _getUserData(userId) async {
    return FirebaseFirestore.instance.collection('users').doc(widget.currentUserId).get();
  }
  displayUserFoundScreen() async{
    Map<String, bool> firebaseUserName={};
    Map<String, bool> firebaseUserId={};
    var tempUserId = [];
    await  FirebaseFirestore.instance.collection("users")
        .where("nickname", isGreaterThanOrEqualTo: "")
        .get()
        .then((QuerySnapshot snapshot){
      snapshot.docs.forEach((DocumentSnapshot documentSnapshot){
        print("I am in displayUserFoundScreen ${documentSnapshot.data()["nickname"]} and ${documentSnapshot.data()["id"]}"
            "and ${widget.currentUserId}");

        if (widget.currentUserId != documentSnapshot.data()["id"]) {

          firebaseUserName[documentSnapshot.data()["nickname"]] = false;
          tempUserId.add(documentSnapshot.data()["id"]);
        }
      });
    });

    print("firebaseUserName  ${firebaseUserName.toString()} and ${firebaseUserName.length} ");
    print("firebaseUserId  ${tempUserId.toString()} and ${tempUserId.length} ");

    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => CheckBox(currentUserId: widget.currentUserId, currentUserName: widget.currentUserName,firebaseUserName:firebaseUserName,
        tempUserId:tempUserId)));

  }
}

