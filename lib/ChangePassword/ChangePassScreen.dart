import 'package:flutter/material.dart';
import 'package:sped_mobile_app/LogAndReg/LoginScreen.dart';
import 'package:sped_mobile_app/SideDrawer.dart';
import 'package:sped_mobile_app/tool.dart';
import 'package:flutter/services.dart';
import 'package:mysql1/mysql1.dart';
import 'package:sped_mobile_app/Globals/globals.dart' as globals;
import 'package:sped_mobile_app/Dashboard/DashboardScreen.dart';
class ChangePScreen extends StatefulWidget {
  const ChangePScreen({Key? key}) : super(key: key);

  @override
  _ChangePScreenState createState() => _ChangePScreenState();
}

class _ChangePScreenState extends State<ChangePScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          drawer: SideDrawer(state: "Change Password"),
          appBar: AppBar(
            actions: [
              IconButton(
                icon: Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
                onPressed: () {
                  globals.userName="";
                  globals.userid="";
                  globals.section="";
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                          (Route<dynamic> route) => false);
                },
              )
            ],
            iconTheme: IconThemeData(color: Colors.white),
            title: Text("Change Password"),
            // automaticallyImplyLeading: false,
            elevation: 3,
            backgroundColor: hexToColor("#2c3136"),
          ),
          body: ChangePBody(),
          backgroundColor: Colors.white,
        ));
  }
}
class ChangePBody extends StatefulWidget {
  const ChangePBody({Key? key}) : super(key: key);

  @override
  _ChangePBodyState createState() => _ChangePBodyState();
}

class _ChangePBodyState extends State<ChangePBody> {
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
  bool showPassword = true,newshowPassword = true,doesntMatchPass=false,wrongpass=false;
  late FocusNode passwordFocusNode;
  late FocusNode newPassFocusNode;
  late FocusNode conPassFocusNode;
  final passTxtfld = TextEditingController();
  final newPass = TextEditingController();
  final conPass = TextEditingController();
  final ButtonStyle style = ElevatedButton.styleFrom(
      elevation: 3,
      shape: StadiumBorder(),
      primary: hexToColor("#2c3136"),
      textStyle: const TextStyle(fontSize: 20),
      side: BorderSide(
        width: 3.0,
        color:  Colors.black,
      ));

  @override
  void initState() {
    super.initState();
    passwordFocusNode = FocusNode();
    newPassFocusNode = FocusNode();
    conPassFocusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return AutofillGroup(
        child: Column(
          children: <Widget>[
            TextFormField(
                controller: passTxtfld,
                focusNode: passwordFocusNode,
                onTap: () {
                  FocusScope.of(context).unfocus();
                  FocusScope.of(context).requestFocus(passwordFocusNode);
                },
                obscureText: showPassword,
                style: TextStyle(color: Colors.black),

                decoration:
                inputDecoration("Old Password", "Enter your old password", Icons.lock)),
            SizedBox(
              height: getProportionateScreenWidth(20, context),
            ),
            TextFormField(
                controller: newPass,
                focusNode: newPassFocusNode,
                onTap: () {
                  FocusScope.of(context).unfocus();
                  FocusScope.of(context).requestFocus(newPassFocusNode);
                },
                onChanged: (value) {
                  print(value);
                  if(conPass.text.isNotEmpty) {
                    if (value != conPass.text) {
                      setState(() {
                        doesntMatchPass = true;
                      });
                    } else {
                      setState(() {
                        doesntMatchPass = false;
                      });
                    }
                  }
                },
                obscureText: newshowPassword,
                style: TextStyle(color: Colors.black),

                decoration:
                inputDecoration("New Password", "Enter your new password", Icons.lock)),
            SizedBox(
              height: getProportionateScreenWidth(20, context),
            ),
            TextFormField(
                controller: conPass,
                focusNode: conPassFocusNode,
                onTap: () {
                  FocusScope.of(context).unfocus();
                  FocusScope.of(context).requestFocus(conPassFocusNode);
                },
                onChanged: (value) {
                  print(value);
                  if(value!=newPass.text){
                    setState(() {
                      doesntMatchPass=true;
                    });
                  }else{
                    setState(() {
                      doesntMatchPass=false;
                    });
                  }
                },
                obscureText: newshowPassword,
                style: TextStyle(color: Colors.black),

                decoration:
                inputDecoration("Confirm Password", "Re-enter your password", Icons.lock)),
            SizedBox(
              height: getProportionateScreenWidth(20, context),
            ),
            ElevatedButton(
              style: style,
              onPressed: doesntMatchPass==false && newPass.text.isNotEmpty ? () async {
                final conn = await MySqlConnection.connect(ConnectionSettings(
                  host: '10.0.2.2',
                  port: 3306,
                  user: 'root',
                  db: 'db_aims',
                ));

                var results = await conn.query(
                    'SELECT * FROM 	parent WHERE student_id = "${globals.userid}" && password = "${passTxtfld.text}"');
                if(!results.isEmpty){
                  await conn.query(
                      'UPDATE parent SET password=? where student_id=?',
                      [conPass.text, globals.userid]);
                  print("Success");
                  showDialog(
                      context: context,
                      builder: (_) => ImageDialog(check: "",)
                  );
                  passTxtfld.clear();
                  newPass.clear();
                  conPass.clear();
                  FocusScope.of(context).unfocus();
                  // Navigator.pushReplacement(context,
                  //     MaterialPageRoute(builder: (context) => DashboardScreen()));
                }else{
                  showDialog(
                      context: context,
                      builder: (_) => ImageDialog(check: "Inside fail",)
                  );
                  setState(() {
                    wrongpass=true;
                  });
                }

                print(results);
                // for (var row in results) {
                //   print('Date: ${row[6]}, email: ${row[1]} age: ${row[2]}');
                //
                // }


              }:null,
              child: const Text('Update'),
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
      labelStyle: TextStyle(color: Colors.black),
      hintText: hint,
        errorStyle: TextStyle(),
        errorText: wrongpass ? label =="Old Password" ?'Wrong Password': doesntMatchPass ? label == "Confirm Password" ? "Doesn't match":null:null:null,
      hintStyle: TextStyle(color: Colors.black,fontSize: 15),
      floatingLabelBehavior: FloatingLabelBehavior.always,
      prefixIcon: Icon(
        icon,
        color: Colors.black,
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 42, vertical: 20),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide(color: Colors.grey),
          gapPadding: 10),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide(color: Colors.grey),
          gapPadding: 10),
      suffixIcon: label == "Old Password" ? IconButton(
          icon: showPassword
              ? Icon(Icons.visibility)
              : Icon(Icons.visibility_off),
          onPressed: () => setState(() {
            showPassword = !showPassword;
          })) : IconButton(
          icon: newshowPassword
              ? Icon(Icons.visibility)
              : Icon(Icons.visibility_off),
          onPressed: () => setState(() {
            newshowPassword = !newshowPassword;
          }))

    );
  }
}


