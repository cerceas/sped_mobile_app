import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:sped_mobile_app/tool.dart';
import 'package:sped_mobile_app/Globals/globals.dart' as globals;

class TeacherRecom extends StatefulWidget {
  String quarter;

  TeacherRecom({required this.quarter, Key? key}) : super(key: key);

  @override
  _TeacherRecomState createState() => _TeacherRecomState();
}

class _TeacherRecomState extends State<TeacherRecom> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(widget.quarter),
        // automaticallyImplyLeading: false,
        elevation: 3,
        backgroundColor: hexToColor("#2c3136"),
      ),
      body: TeacherBody(),
      backgroundColor: Colors.white,
    );
  }
}

class TeacherBody extends StatefulWidget {
  const TeacherBody({Key? key}) : super(key: key);

  @override
  _TeacherBodyState createState() => _TeacherBodyState();
}

class _TeacherBodyState extends State<TeacherBody> {
  late Future<String> teacherRecom;

  Future<String> generateRecom() async {
    final conn = await MySqlConnection.connect(ConnectionSettings(
      host: '10.0.2.2',
      port: 3306,
      user: 'root',
      db: 'db_aims',
    ));

    var results = await conn.query(
        'SELECT * FROM 	grades_report_card WHERE student_id="${globals.userid}" and quarter="${5}"');
    late String output;
    for (var row in results) {
      output = "${row[7]}";
    }

    return output;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    teacherRecom = generateRecom();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  Card(
                    elevation: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 20, 20, 5),
                          child: Text("LRN: ${globals.userid}",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontFamily: "Roboto")),
                        ),
                        Padding(
                            padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                            child: Text("Name: ${globals.userName}",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontFamily: "Roboto"))),
                        Padding(
                            padding: EdgeInsets.fromLTRB(20, 5, 20, 20),
                            child: Text("Sped Level: ${globals.section}",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontFamily: "Roboto"))),

                        // Padding(
                        //     padding: EdgeInsets.fromLTRB(20, 5, 5, 20),
                        //     child: Text("School year: ")),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  FutureBuilder<String>(
                      future: teacherRecom,
                      builder: (context, projectSnap) {
                        switch (projectSnap.connectionState) {
                          case ConnectionState.none:
                          case ConnectionState.waiting:
                          return Center(child: CircularProgressIndicator());
                          default:
                          if (projectSnap.hasData) {
                            String? remarks=projectSnap.data;
                            return DataTable(dataRowHeight: 150, columnSpacing: 2, columns: [
                              DataColumn(
                                  label: Text('Quarter',
                                      style: TextStyle(
                                          fontSize: 20, fontWeight: FontWeight.bold))),
                              DataColumn(
                                  label: Text('',
                                      style: TextStyle(
                                          fontSize: 20, fontWeight: FontWeight.bold))),
                            ], rows: [
                              DataRow(cells: [
                                DataCell(Text('First Quarter',
                                    style: TextStyle(
                                        fontSize: 18, fontWeight: FontWeight.bold))),
                                DataCell(SizedBox(
                                  width: 290,
                                  child: Text(
                                      "$remarks"),
                                )),
                              ]),
                              DataRow(cells: [
                                DataCell(Text('Second Quarter',
                                    style: TextStyle(
                                        fontSize: 18, fontWeight: FontWeight.bold))),
                                DataCell(SizedBox(
                                  width: 290,
                                  child: Text(
                                      "$remarks"),
                                )),
                              ]),
                              DataRow(cells: [
                                DataCell(Text('Third Quarter',
                                    style: TextStyle(
                                        fontSize: 18, fontWeight: FontWeight.bold))),
                                DataCell(SizedBox(
                                  width: 290,
                                  child: Text(
                                      "$remarks"),
                                )),
                              ]),
                              DataRow(cells: [
                                DataCell(Text('Fourth Quarter',
                                    style: TextStyle(
                                        fontSize: 18, fontWeight: FontWeight.bold))),
                                DataCell(SizedBox(
                                  width: 290,
                                  child: Text(
                                      "$remarks"),
                                )),
                              ]),
                            ]);
                          }else{
                            return Container();
                          }
                        }
                      }),

                ])));
  }
}
