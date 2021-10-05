import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:sped_mobile_app/SideDrawer.dart';
import 'package:sped_mobile_app/Globals/globals.dart' as globals;
import 'package:sped_mobile_app/tool.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({Key? key}) : super(key: key);

  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      drawer: SideDrawer(state: "Attendance"),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text("Attendance"),
        // automaticallyImplyLeading: false,
        elevation: 3,
        backgroundColor: hexToColor("#2c3136"),
      ),
      body: Attendance_body(),
      backgroundColor: Colors.white,
    ));
  }
}

class Attendance_body extends StatefulWidget {
  const Attendance_body({Key? key}) : super(key: key);

  @override
  _Attendance_bodyState createState() => _Attendance_bodyState();
}

class _Attendance_bodyState extends State<Attendance_body> {
  late List<GDPData> _chartdata;
  late int totalclass;
  Future<List<GDPData>> getChartData() async {
    late List<GDPData> chartdata = [];
    final conn = await MySqlConnection.connect(ConnectionSettings(
      host: '10.0.2.2',
      port: 3306,
      user: 'root',
      db: 'db_aims',
    ));
    var resultsAbsent = await conn
        .query('SELECT * FROM attendance WHERE student_id="${globals.userid}"  && status ="ABSENT"');
    var resultsPresent = await conn
        .query('SELECT * FROM attendance WHERE student_id="${globals.userid}" && status ="PRESENT"');
    chartdata.add(GDPData(state: "Absent", GDP: resultsAbsent.length));
    chartdata.add(GDPData(state: "Present", GDP: resultsPresent.length));
    totalclass=resultsAbsent.length + resultsPresent.length;
    return chartdata;
  }

  @override
  void initState() {
    // _chartdata = getChartData();
    super.initState();
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
            FutureBuilder<List<GDPData>>(
                future: getChartData(),
                builder: (contexts, projectsnap) {
                  switch(projectsnap.connectionState){
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return CircularProgressIndicator();
                    default:
                      if(projectsnap.hasData){
                        _chartdata=projectsnap.data!;
                       return  Card(
                          elevation: 2,
                          child: Column(

                            children: <Widget>[
                              SfCircularChart(
                                legend: Legend(
                                    isVisible: true,
                                    overflowMode: LegendItemOverflowMode.wrap,
                                    textStyle: TextStyle(fontSize: 21,fontFamily: "Roboto")),
                                series: <CircularSeries>[
                                  DoughnutSeries<GDPData, String>(
                                    legendIconType: LegendIconType.seriesType,
                                    dataSource: _chartdata,
                                    xValueMapper: (GDPData data, _) => data.state,
                                    yValueMapper: (GDPData data, _) => data.GDP,
                                    dataLabelSettings: DataLabelSettings(
                                      isVisible: true,
                                    ),
                                  )
                                ],
                              ),

                              Text("Total class$totalclass",style: TextStyle(fontSize: 18,fontFamily: "Roboto"),),
                            ]
                          ),
                        );
                      }

                  }
                  return Container();
                }),

          ],
        ),
      ),
    ));
  }
}

class GDPData {
  final String state;
  final int GDP;

  GDPData({required this.state, required this.GDP});
}
