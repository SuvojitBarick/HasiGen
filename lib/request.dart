import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Request extends StatelessWidget {
  final image;

  Request(this.image);

  Future<String> requesting() async {
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
      return response.body;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<String>(
        future: requesting(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            print(snapshot.data);
            return Card(
              child: Text(snapshot.data),
            );
          }
          else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
