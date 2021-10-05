import 'package:flutter/material.dart';
import 'package:sped_mobile_app/SideDrawer.dart';
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

  @override
  void initState() {
    _chartdata = getChartData();
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
            Card(elevation: 2,
              child: SfCircularChart(
                legend: Legend(isVisible: true,overflowMode: LegendItemOverflowMode.wrap,textStyle: TextStyle(fontSize: 21)),
                series: <CircularSeries>[
                  DoughnutSeries<GDPData, String>(legendIconType: LegendIconType.seriesType,
                      dataSource: _chartdata,
                      xValueMapper: (GDPData data, _) => data.state,
                  yValueMapper: (GDPData data,_) => data.GDP,
                    dataLabelSettings: DataLabelSettings(isVisible: true,),

                  )
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }

  List<GDPData> getChartData() {
    late List<GDPData> chartdata = [];
    chartdata.add(GDPData(state: "Absent", GDP: 25));
    chartdata.add(GDPData(state: "Present", GDP: 75));
    return chartdata;
  }
}

class GDPData {
  final String state;
  final int GDP;

  GDPData({required this.state, required this.GDP});
}
