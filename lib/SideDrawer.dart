import 'package:flutter/material.dart';
import 'package:sped_mobile_app/Attendance/AttendanceScreen.dart';
import 'package:sped_mobile_app/Dashboard/DashboardScreen.dart';
import 'package:sped_mobile_app/LogAndReg/LoginScreen.dart';
import 'package:sped_mobile_app/tool.dart';

class SideDrawer extends StatefulWidget {
  String state;

  SideDrawer({required this.state});

  @override
  _SideDrawerState createState() => _SideDrawerState();
}

class _SideDrawerState extends State<SideDrawer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: hexToColor("#2c3136"),
              ),
              child: Container(
                child: Column(
                  children: <Widget>[
                    Material(
                      borderRadius: BorderRadius.all(Radius.circular(50.0)),
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Image.asset(
                          "assets/image/bagongNLogo.png",
                          width: 120,
                          height: 120,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            CustomListTile(
              title: "Dashboard",
              icon: Icons.airplay,
              onTap: () {
                widget.state == "Dashboard"
                    ? Navigator.of(context).pop()
                    : Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (c, a1, a2) => DashboardScreen(),
                          transitionsBuilder: (c, anim, a2, child) =>
                              FadeTransition(opacity: anim, child: child),
                          transitionDuration: Duration(milliseconds: 500),
                        ),
                      );
              },
            ),
            SizedBox(
              height: getProportionateScreenWidth(20, context),
            ),
            CustomListTile(
              title: "Attendance View",
              icon: Icons.assignment_turned_in_outlined,
              onTap: () {
                widget.state == "Attendance"
                    ? Navigator.of(context).pop()
                    : Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (c, a1, a2) => AttendanceScreen(),
                          transitionsBuilder: (c, anim, a2, child) =>
                              FadeTransition(opacity: anim, child: child),
                          transitionDuration: Duration(milliseconds: 500),
                        ),
                      );
              },
            ),
            SizedBox(
              height: getProportionateScreenWidth(20, context),
            ),
            CustomListTile(
              title: "Teacher Consultation",
              icon: Icons.mail_outline_rounded,
              onTap: () {},
            ),
            SizedBox(
              height: getProportionateScreenWidth(20, context),
            ),
            CustomListTile(
              title: "School Curriculum",
              icon: Icons.work_outline_rounded,
              onTap: () {
                print("School");
              },
            ),
            SizedBox(
              height: getProportionateScreenWidth(20, context),
            ),
            CustomListTile(
              title: "Academic Performance",
              icon: Icons.assignment,
              onTap: () {
                print("HELLOW");
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CustomListTile extends StatelessWidget {
  IconData icon;
  String title;
  Function onTap;

  CustomListTile(
      {required this.icon, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
      child: Container(
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.white))),
        child: InkWell(
          splashColor: Colors.white,
          onTap: () {
            onTap();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(
                    icon,
                    color: Colors.white,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      title,
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
