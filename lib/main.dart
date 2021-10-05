
import 'package:flutter/material.dart';
import 'package:sped_mobile_app/tool.dart';
import 'package:sped_mobile_app/LogAndReg/LoginScreen.dart';

void main() {

  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Sped Database",
      theme: ThemeData(canvasColor: hexToColor("#2c3136"),
        scaffoldBackgroundColor: hexToColor("#2c3136"),
      ),
      home: LoginScreen(),
    );
  }

}

