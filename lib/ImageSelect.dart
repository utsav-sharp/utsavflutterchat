import 'dart:async';
import 'dart:io';
import 'package:mime_type/mime_type.dart';
import 'package:path/path.dart' as Path;
import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'dart:html' as html;



class ImageSelect extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var currentSelfie;

  Future<void> getPhotos() async {
    var mediaData = await ImagePickerWeb.getImageInfo;
    String mimeType = mime(Path.basename(mediaData.fileName));
    html.File mediaFile =
    new html.File(mediaData.data, mediaData.fileName, {'type': mimeType});

    print("imageFile123 ${mediaData.toString()}");

    if (mediaData != null) {
      currentSelfie = mediaData.data;
      var utsav=mediaData.base64.trim();


     // print("currentSelfie123 ${currentSelfie.toString()}");
      print("utsav  ${utsav}");



      setState(() {

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            currentSelfie == null
                ? Container()
                : Image.memory(
              (currentSelfie),
              fit: BoxFit.fill,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getPhotos,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}