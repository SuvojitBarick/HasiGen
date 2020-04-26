import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  MyAppHome createState() => MyAppHome();
}

class MyAppHome extends State<MyApp> {
  var _str;

  @override
  void initState() {
    super.initState();
  }

  void getImage() {
    ImagePicker.pickImage(source: ImageSource.gallery).then(
      (image) => setState(
        () {
          requesting(image);
        },
      ),
    );
  }

  void requesting(File image) async {
    String keys = "";
    final FirebaseVisionImage visionImage =
        FirebaseVisionImage.fromFile(image);
    final ImageLabeler labeler = FirebaseVision.instance.imageLabeler();
    final List<ImageLabel> labels = await labeler.processImage(visionImage);
    for (ImageLabel label in labels) {
      if (label.confidence > 0.50) {
        keys += label.text + ",";
      }
    }
    String link = "https://demoapp200.herokuapp.com/" + keys;
    final response = await http.get(link);
    if (response.statusCode == 200) {
      setState(() {
        _str = response.body;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Hashigen"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              RaisedButton(
                child: Icon(Icons.add_a_photo),
                onPressed: getImage,
              ),
              Card(
                child:
                    (_str != null) ? Text(_str) : CircularProgressIndicator(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
