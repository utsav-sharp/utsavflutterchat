import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';
class FullPhoto extends StatelessWidget {
final String url;
FullPhoto({Key key,@required this.url}):super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Text("Full Image",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
        body: FullPhotoScreen(url:url),
    );
  }
}

class FullPhotoScreen extends StatefulWidget {
  final String url;
  FullPhotoScreen({Key key,@required this.url}):super(key: key);
  @override
  State createState() => FullPhotoScreenState(url:url);
}

class FullPhotoScreenState extends State<FullPhotoScreen> {
  final String url;
  FullPhotoScreenState({Key key,@required this.url});
  @override
  void initState() {
    super.initState();
   // _createFileFromString();
  }

  @override
  Widget build(BuildContext context) {
      return Container(
        margin: EdgeInsets.all(15.0),
        child: Image.memory(
          (base64Decode(url)),
          width: MediaQuery.of(context).size.width ,
          height: MediaQuery.of(context).size.height,
          fit: BoxFit.cover,
        ),
      );
  }
 /* Future<String> _createFileFromString() async {
 //   final encodedStr = "...";
    Uint8List bytes = base64.decode(url);

    String dir = (await getApplicationDocumentsDirectory()).path;
    String fullPath = '$dir/abc.png';
    print("local file full path ${fullPath}");
    File file = File(fullPath);
    await file.writeAsBytes(bytes);
    print(file.path);

    final result = await ImageGallerySaver.saveImage(bytes);
    print(result);

    return file.path;
  }*/
}
