import 'package:flutter/material.dart';

import 'src/models/adventure.dart';

class AppConfig {
  double width;
  double height;
  double blockSize;
  double blockSizeVertical;
  Color themeColor;

  setConfig(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    blockSize = width / 100;
    blockSizeVertical = height / 100;
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
}

final AppConfig appConfig = AppConfig();
