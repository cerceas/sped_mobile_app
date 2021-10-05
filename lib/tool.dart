import 'package:flutter/cupertino.dart';
class SizeConfig {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static double? defaultSize;
  static Orientation? orientation;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    orientation = _mediaQueryData.orientation;
  }
  double getScreenWidth(){
    return screenWidth;
  }
}
Color hexToColor(String code) {
  return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
}

double getProportionateScreenWidth(double inputWidth,BuildContext context) {
  SizeConfig sizeConfig = SizeConfig();
  sizeConfig.init(context);
  double screenWidth = sizeConfig.getScreenWidth();
  // 375 is the layout width that designer use
  return (inputWidth / 375.0) * screenWidth;
}