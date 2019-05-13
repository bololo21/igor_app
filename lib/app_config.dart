import 'package:flutter/material.dart';

class AppConfig {
  double width;
  double height;
  double blockSize;
  double blockSizeVertical;

  setConfig(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    blockSize = width / 100;
    blockSizeVertical = height / 100;
  }
}

final AppConfig appConfig = AppConfig();
