import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mysql1/mysql1.dart';
import 'package:sped_mobile_app/SideDrawer.dart';
import 'package:sped_mobile_app/tool.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {


  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      drawer: SideDrawer(state: "Dashboard"),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text("Dashboard"),
        // automaticallyImplyLeading: false,
        elevation: 3,
        backgroundColor: hexToColor("#2c3136"),
      ),
      body: Dashboard_body(),
      backgroundColor: Colors.white,
    ));
  }


}

class Dashboard_body extends StatefulWidget {


  @override
  _Dashboard_bodyState createState() => _Dashboard_bodyState();
}

class _Dashboard_bodyState extends State<Dashboard_body> {

  Future<List> generateAdminData() async {
    final conn = await MySqlConnection.connect(ConnectionSettings(
      host: '10.0.2.2',
      port: 3306,
      user: 'root',
      db: 'db_aims',
    ));
    var dataList;
    var results = await conn
        .query('SELECT * FROM 	announcement WHERE message_from="admin" ORDER BY announce_date DESC');
    dataList = List.generate(results.length, (i) => ["", "", "", "", ""],
        growable: false);
    int i = 0;
    int j = 0;
    for (var row in results) {
      while (j < 5) {
        if(j==0){
          dataList[i][j] = "${row[2]}";
        }else if(j==1){
          DateTime _datetime=row[6];
          DateFormat formatter = DateFormat.yMMMMd('en_US');
          String formatted = formatter.format(_datetime);
          dataList[i][j] = "$formatted";
        }else if(j==2){
          dataList[i][j] = "${row[4]}";
        }else if(j==3){
          dataList[i][j] = "${row[5]}";
        }
        else if(j==4){
          dataList[i][j] = "${row[0]}";
        }
        j++;
      }
      i++;
      j = 0;
    }
    return dataList;
  }

  Future<List> generateTeacherData() async {
    final conn = await MySqlConnection.connect(ConnectionSettings(
      host: '10.0.2.2',
      port: 3306,
      user: 'root',
      db: 'db_aims',
    ));
    var dataList;
    var results = await conn
        .query('SELECT * FROM 	announcement WHERE message_from="teacher" ORDER BY announce_date DESC');
    dataList = List.generate(results.length, (i) => ["", "", "", "", ""],
        growable: false);
    int i = 0;
    int j = 0;
    for (var row in results) {
      while (j < 5) {
        if(j==0){
          dataList[i][j] = "${row[2]}";
        }else if(j==1){
          DateTime _datetime=row[6];
          DateFormat formatter = DateFormat.yMMMMd('en_US');
           String formatted = formatter.format(_datetime);
          dataList[i][j] = "$formatted";
        }else if(j==2){
          dataList[i][j] = "${row[4]}";
        }else if(j==3){
          dataList[i][j] = "${row[5]}";
        }
        else if(j==4){
          dataList[i][j] = "${row[0]}";
        }
        j++;
      }
      i++;
      j = 0;
    }
    return dataList;
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(20, context),
            vertical: getProportionateScreenWidth(10, context)),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.topCenter,
                child: Card(
                  color: hexToColor("#2C5F2D"),
                  elevation: 3,
                  child: Container(
                    height: 50,
                    width: 600,
                    child: Center(
                      child: Text(
                        "ADMIN ANNOUNCEMENT",
                        style: TextStyle(
                            color: Colors.black,fontFamily: "Roboto",
                            fontSize: getProportionateScreenWidth(28, context),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
              FutureBuilder<List>(future: generateAdminData(),
                  builder: (context,projectSnap){
                switch(projectSnap.connectionState){
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return CircularProgressIndicator();
                  default:
                    if(projectSnap.hasData){
                      var listdata=projectSnap.data;
                      print(listdata![0][0]);
                      return Card(
                        elevation: 5,
                        child: Container(
                          height: 400,
                          child: ListView.builder(
                              itemCount: listdata.length,
                              shrinkWrap: true,
                              itemBuilder: (_, i) {
                                print("item builder $i");
                                print("JSD");
                                return CustomListTile(
                                  title: "${listdata[i][2]}",
                                  message:
                                  "${listdata[i][3]}",
                                  date:  "${listdata[i][1]}",
                                );

                              }),
                        ),
                      );
                    }

                }
                return Container();
              }),
              SizedBox(
                height: getProportionateScreenWidth(20, context),
              ),
              SizedBox(
                height: getProportionateScreenWidth(20, context),
              ),

              Align(
                alignment: Alignment.topCenter,
                child: Card(
                  color: hexToColor("#2C5F2D"),
                  elevation: 3,
                  child: Container(

                    child: Center(
                      child: Text(
                        "ANNOUNCEMENT FROM TEACHER",
                        style: TextStyle(
                            color: Colors.black,fontFamily: "Roboto",
                            fontSize:  getProportionateScreenWidth(28, context),
                            fontWeight: FontWeight.bold),textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),

              FutureBuilder<List>(future: generateTeacherData(),
                  builder: (context,projectSnap){
                    switch(projectSnap.connectionState){
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                        return CircularProgressIndicator();
                      default:
                        if(projectSnap.hasData){
                          var listdata=projectSnap.data;
                          print(listdata![0][0]);
                          return Card(
                            elevation: 5,
                            child: Container(
                              height: 400,
                              child: ListView.builder(
                                  itemCount: listdata.length,
                                  shrinkWrap: true,
                                  itemBuilder: (_, i) {
                                    print("item builder $i");
                                    print("JSD");
                                    return CustomListTile(
                                      title: "${listdata[i][2]}",
                                      message:
                                      "${listdata[i][3]}",
                                      date:  "${listdata[i][1]}",
                                    );

                                  }),
                            ),
                          );
                        }

                    }
                    return Container();
                  }),

              // Container(
              //   height: 600,
              //   child: ListView.builder(
              //       itemCount: 30,
              //       shrinkWrap: true,
              //       itemBuilder: (_, i) {
              //         return Card(
              //           elevation: 3,
              //           child: ListTile(
              //             title: Text("This is item #$i"),
              //             subtitle: Text("2021-06-4 14:07:44"),
              //             trailing: IconButton(
              //               icon: Icon(Icons.message),
              //               onPressed: () {},
              //             ),
              //           ),
              //         );
              //       }),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomListTile extends StatefulWidget {
  String title;
  String message;
  String date;

  CustomListTile({required this.title, required this.message,required this.date});

  @override
  _CustomListTileState createState() => _CustomListTileState();
}

class _CustomListTileState extends State<CustomListTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 0, 0.0, 0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey.shade500,
            border: Border(bottom: BorderSide(color: Colors.grey))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Image.asset(
                  "assets/image/loudspeaker.png",
                  width: 24,
                  height: 24,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.date,
                      style: TextStyle(fontSize: 12, color: Colors.black),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                      child: Text(
                        widget.title,
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(50.0, 0, 0, 20.0),
              child: Text(
                widget.message,
                style: TextStyle(fontSize: 13, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
