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
  var imgfile;
  @override
  void initState() {
    super.initState();
  }

  void getImage() {
    ImagePicker.pickImage(source: ImageSource.gallery).then(
      (image) => setState(
        () {
          imgfile = image;
          requesting(image);
        },
      ),
    );
  }

  void requesting(File image) async {
    String keys = "";
    final FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(image);
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
          title: Text(
            "Hashigen",
            style: TextStyle(fontSize: 24),
          ),
          centerTitle: true,
          backgroundColor: Colors.deepPurple,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Text(
                    'Tap below icon to chose your image',
                  ),
                ),
                RaisedButton(
                  child: Icon(Icons.add_a_photo),
                  onPressed: getImage,
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  child: (_str != null)
                      ? Column(
                          children: <Widget>[
                            SizedBox(
                              height: 200,
                              width: 200,
                              child: imgfile != null
                                  ? Image.file(
                                      imgfile,
                                      fit: BoxFit.contain,
                                    )
                                  : Icon(
                                      Icons.image,
                                      size: 100,
                                    ),
                            ),
                            Divider(),
                            SelectableText(
                              '$_str',
                              // maxLines: 10,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.blueAccent,
                              ),
                              toolbarOptions: ToolbarOptions(
                                  copy: true,
                                  selectAll: true,
                                  cut: false,
                                  paste: false),
                            )
                          ],
                        )
                      : imgfile == null
                          ? Center(
                              child: Text('input an image to get you hashtags'))
                          : CircularProgressIndicator(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
