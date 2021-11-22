import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mysql1/mysql1.dart';
import 'package:sped_mobile_app/Globals/globals.dart' as globals;
import 'package:sped_mobile_app/Dashboard/DashboardScreen.dart';
import 'package:sped_mobile_app/tool.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _Login_ScreenState createState() => _Login_ScreenState();
}

class _Login_ScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: hexToColor("#2c3136"),
      ),
      body: Login_body(),
    ));
  }
}

class Login_body extends StatefulWidget {
  @override
  _Login_bodyState createState() => _Login_bodyState();
}

class _Login_bodyState extends State<Login_body> {
  bool keyboardCondition = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SizedBox(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(20, context)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Flexible(
              // your image goes here which will take as much height as possible.
              child: Image.asset('assets/image/bagongNLogo.png', fit: BoxFit.contain),
            ),
            SizedBox(
              height: getProportionateScreenWidth(20, context),
            ),
            SignForm(),
          ],
        ),
      ),
    ));
  }

}

class SignForm extends StatefulWidget {

  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  bool showPassword = true;
  late FocusNode passwordFocusNode;
  final emailTxtfld = TextEditingController();
  final passTxtfld = TextEditingController();
  final ButtonStyle style = ElevatedButton.styleFrom(
      elevation: 3,
      shape: StadiumBorder(),
      primary: hexToColor("#2c3136"),
      textStyle: const TextStyle(fontSize: 20),
      side: BorderSide(
        width: 3.0,
        color: Colors.white,
      ));

  @override
  void initState() {
    super.initState();
    passwordFocusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return AutofillGroup(
        child: Column(
      children: <Widget>[
        TextFormField(
            style: TextStyle(color: Colors.white),
            controller: emailTxtfld,
            autofillHints: [AutofillHints.email],
            keyboardType: TextInputType.emailAddress,
            decoration:
                inputDecoration("Email", "Enter your Email", Icons.email)),
        SizedBox(
          height: getProportionateScreenWidth(20, context),
        ),
        TextFormField(
          controller: passTxtfld,
            focusNode: passwordFocusNode,
            onTap: () {
              FocusScope.of(context).unfocus();
              FocusScope.of(context).requestFocus(passwordFocusNode);
            },
            obscureText: showPassword,
            style: TextStyle(color: Colors.white),
            autofillHints: [AutofillHints.password],
            onEditingComplete: () => TextInput.finishAutofillContext(),
            decoration:
                inputDecoration("Password", "Enter your password", Icons.lock)),
        SizedBox(
          height: getProportionateScreenWidth(20, context),
        ),
        ElevatedButton(
          style: style,
          onPressed: () async {
            final conn = await MySqlConnection.connect(ConnectionSettings(
              host: '10.0.2.2',
              port: 3306,
              user: 'root',
              db: 'db_aims',
            ));

            var results = await conn.query(
                'SELECT * FROM 	parent WHERE email = "${emailTxtfld.text}" && password = "${passTxtfld.text}"');
            if(!results.isEmpty){
              for(var row in results) {
                globals.userid = "${row[1]}";
                globals.userName = "${row[4]}, ${row[2]} ${row[3]}";
                globals.section="${row[9]}";
              }
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => DashboardScreen()));
            }

            print(results);
            // for (var row in results) {
            //   print('Date: ${row[6]}, email: ${row[1]} age: ${row[2]}');
            //
            // }


          },
          child: const Text('Sign in'),
        ),
        SizedBox(
          height: getProportionateScreenWidth(20, context),
        ),
      ],
    ));
  }

  InputDecoration inputDecoration(String label, String hint, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.white),
      hintText: hint,
      hintStyle: TextStyle(color: Colors.white),
      floatingLabelBehavior: FloatingLabelBehavior.always,
      prefixIcon: Icon(
        icon,
        color: Colors.white,
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 42, vertical: 20),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide(color: hexToColor("#f8f5f0")),
          gapPadding: 10),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide(color: hexToColor("#f8f5f0")),
          gapPadding: 10),
      suffixIcon: label == "Password"
          ? IconButton(
              icon: showPassword
                  ? Icon(Icons.visibility)
                  : Icon(Icons.visibility_off),
              onPressed: () => setState(() {
                    showPassword = !showPassword;
                  }))
          : null,
    );
  }
}
