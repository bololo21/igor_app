import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'src/models/adventure.dart';

class AppConfig {
  double width;
  double height;
  double blockSize;
  double blockSizeVertical;
  Color themeColor;
  FirebaseMessaging firebaseMessaging = new FirebaseMessaging();

  setConfig(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    blockSize = width / 100;
    blockSizeVertical = height / 100;
    configFirebaseMessaging(context);
  }

  setThemeColor(Adventure adventure) {
    if (adventure.imagePath == 'Coast') {
      themeColor = const Color(0xfff9a073);
    } else if (adventure.imagePath == 'Corvali') {
      themeColor = const Color(0xff0f857e);
    } else if (adventure.imagePath == 'Heartlands') {
      themeColor = const Color(0xff1a3f51);
    } else if (adventure.imagePath == 'Krevast') {
      themeColor = const Color(0xff6c203e);
    } else {
      themeColor = const Color(0xff1e2843);
    }
  }

  void configFirebaseMessaging(context) {
    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) {
        print('on message $message');
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text(message['notification']['title']),
                elevation: 0,
                backgroundColor: const Color(0xffffffff),
                content: Text(message['notification']['body'], textAlign: TextAlign.center,),
                actions: <Widget>[
                  FlatButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("OK")),
                ],
              ),
        );
      },
      onResume: (Map<String, dynamic> message) {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) {
        print('on launch $message');
      },
    );
    firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
  }
}

final AppConfig appConfig = AppConfig();
