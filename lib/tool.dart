import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

class ImageDialog extends StatelessWidget {
  String check;
  ImageDialog({required this.check});
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(width: 6, color: Colors.black38),
          borderRadius: BorderRadius.circular(20.0),
        ),
        height: MediaQuery.of(context).size.height/3.3,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              child: Image.asset(
                  this.check=="Outside fail" || this.check=="Inside fail"? "assets/image/lock.png": "assets/image/success.png",
                  height: MediaQuery.of(context).size.height/6,
                  width: MediaQuery.of(context).size.width/4),
            ),
           this.check=="Outside fail" ? Text("Wrong Email or Password",textAlign:TextAlign.center,style: TextStyle(
                color: Colors.black,fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: "CooperBlack"),): this.check =="Inside fail" ?Text("Wrong old Password",textAlign:TextAlign.center,style: TextStyle(
               color: Colors.black,fontSize: 18,
               fontWeight: FontWeight.bold,
               fontFamily: "CooperBlack"),) : Text("Update Success",textAlign:TextAlign.center,style: TextStyle(
               color: Colors.black,fontSize: 18,
               fontWeight: FontWeight.bold,
               fontFamily: "CooperBlack"),),

          ],
        ),
      ),
    );
  }
}