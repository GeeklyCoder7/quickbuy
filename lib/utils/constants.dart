import 'package:flutter/cupertino.dart';

class Constants {
  //Method to get the device height
  static double getDeviceHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  //Method to get the device width
  static double getDeviceWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }
}