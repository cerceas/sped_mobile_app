import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:sped_mobile_app/Academic%20Performance/PerformanceScreen.dart';
import 'package:sped_mobile_app/Attendance/AttendanceScreen.dart';
import 'package:sped_mobile_app/ChangePassword/ChangePassScreen.dart';
import 'package:sped_mobile_app/Dashboard/DashboardScreen.dart';

import 'package:sped_mobile_app/SchoolCurriculum/CurriculumScreen.dart';
import 'package:sped_mobile_app/TeacherConsulation/chatdetail.dart';
import 'package:sped_mobile_app/TeacherConsulation/chatpage.dart';
import 'package:sped_mobile_app/tool.dart';

import 'package:sped_mobile_app/Globals/globals.dart' as globals;
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
           Center(child: Text("${globals.userName}",style: TextStyle(color: Colors.white,
               fontSize: 18, fontFamily: "Roboto"),),),
            SizedBox(
              height: getProportionateScreenWidth(15, context),
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
              onTap: () async {
                final conn = await MySqlConnection.connect(ConnectionSettings(
                  host: '10.0.2.2',
                  port: 3306,
                  user: 'root',
                  db: 'db_aims',
                ));
                List dataList;
                var results = await conn
                    .query('SELECT * FROM teachers WHERE section = "${globals.section}" ');
                dataList = List.generate(results.length, (i) => ["","","",""],growable: false);
                int i = 0;
                int j = 0;
                for (var row in results) {
                  print(row);
                  while (j < 4) {
                    if(j==0){
                      //teacherid
                      dataList[i][j] = "${row[1]}";
                    }else if(j==1){
                      //name
                      dataList[i][j] = "${row[2]} ${row[3]} ${row[4]}";
                    }else if(j==2){
                      dataList[i][j] = "${row[5]}";
                    }
                    else if(j==3){
                      dataList[i][j] = "${row[7]}";
                    }
                    j++;
                  }
                  i++;
                  j = 0;
                }

                widget.state == "Teacher Consultation"
                    ? Navigator.of(context).pop()
                    : Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (c, a1, a2) => ChatDetail(id:dataList[0][0],name:  dataList[0][1],
                      imageUrl: dataList[0][3] == "Male" ? "assets/image/man.png" : "assets/image/woman.png",email: dataList[0][2]),
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
              title: "School Curriculum",
              icon: Icons.work_outline_rounded,
              onTap: () {
                widget.state == "School Curriculum"
                    ? Navigator.of(context).pop()
                    : Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (c, a1, a2) => SchoolCurriculum(),
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
              title: "Academic Performance",
              icon: Icons.assignment,
              onTap: () {
                widget.state == "Academic Performance"
                    ? Navigator.of(context).pop()
                    : Navigator.push(
                    context,
                    PageRouteBuilder(
                    pageBuilder: (c, a1, a2) => AcadPerformance(),
                transitionsBuilder: (c, anim, a2, child) =>
                FadeTransition(opacity: anim, child: child),
                transitionDuration: Duration(milliseconds: 500),
                ),);
              },
            ),SizedBox(
              height: getProportionateScreenWidth(20, context),
            ),
            CustomListTile(
              title: "Change Password",
              icon: Icons.vpn_key_outlined,
              onTap: () {
                widget.state == "Change Password"
                    ? Navigator.of(context).pop()
                    : Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (c, a1, a2) => ChangePScreen(),
                    transitionsBuilder: (c, anim, a2, child) =>
                        FadeTransition(opacity: anim, child: child),
                    transitionDuration: Duration(milliseconds: 500),
                  ),);
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
