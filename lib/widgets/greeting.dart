import 'package:flutter/material.dart';

class Greetings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Text(
        timeChecker(),
        style:
            TextStyle(color: Colors.white, fontFamily: "gilroy", fontSize: 35),
      ),
    );
  }

  String timeChecker() {
    int hour = DateTime.now().hour.toInt();
    int min = DateTime.now().minute.toInt();
    if (0 <= hour && hour <= 12)
      return "Good morning";
    else if ((hour == 12 && min > 1) || hour < 17) return "Good afternoon";
    return "Good Evening";
  }
}
