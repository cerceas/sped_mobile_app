import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sped_mobile_app/LogAndReg/LoginScreen.dart';
import 'package:sped_mobile_app/tool.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0,
            backgroundColor: hexToColor("#2c3136"),
          ),
          body: Register_body(),
        ));
  }
}

class Register_body extends StatelessWidget {
  const Register_body({Key? key}) : super(key: key);

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
                Text(
                  "Sample Register",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: getProportionateScreenWidth(28, context),
                      fontWeight: FontWeight.bold),
                ),
                SignForm(),
              ],
            ),
          ),
        ));
  }
}

class SignForm extends StatefulWidget {
  const SignForm({Key? key}) : super(key: key);

  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {

  bool showPassword = true;
  late FocusNode passwordFocusNode;
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
                autofillHints: [AutofillHints.email],
                keyboardType: TextInputType.emailAddress,
                decoration:
                inputDecoration("Email", "Enter your Email", Icons.email)),
            SizedBox(
              height: getProportionateScreenWidth(20, context),
            ),
            TextFormField(
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
              onPressed: () {},
              child: const Text('Sign Up'),
            ),
            SizedBox(
              height: getProportionateScreenWidth(20, context),
            ),
            RichText(
              text: TextSpan(
                style: TextStyle(color: Colors.grey, fontSize: 15.0),
                children: <TextSpan>[
                  TextSpan(text: "Already have an account? "),
                  TextSpan(
                      text: 'Sign In',
                      style: TextStyle(color: Colors.blue),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pop(context);
                        }),
                ],
              ),
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


