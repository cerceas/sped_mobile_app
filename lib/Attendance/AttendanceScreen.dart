import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mysql1/mysql1.dart';
import 'package:sped_mobile_app/LogAndReg/LoginScreen.dart';
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
  late var totalStudentData;
  late int jan = 0,
      feb = 0,
      mar = 0,
      apr = 0,
      may = 0,
      jun = 0,
      jul = 0,
      aug = 0,
      sep = 0,
      oct = 0,
      nov = 0,
      dec = 0;
  late int presJan = 0,
      presFeb = 0,
      presMar = 0,
      presApr = 0,
      presMay = 0,
      presJun = 0,
      presJul = 0,
      presAug = 0,
      presSep = 0,
      presOct = 0,
      presNov = 0,
      presDec = 0;
  late int absJan = 0,
      absFeb = 0,
      absMar = 0,
      absApr = 0,
      absMay = 0,
      absJun = 0,
      absJul = 0,
      absAug = 0,
      absSep = 0,
      absOct = 0,
      absNov = 0,
      absDec = 0;

  void computerMonth(DateTime dateTime,String status) {
    switch (dateTime.month) {
      case 1:
        jan++;
        if(status.toLowerCase() == "present"){
          presJan++;
        }else{
          absJan++;
        }
        break;
      case 2:
        feb++;
        if(status.toLowerCase() == "present"){
          presFeb++;
        }else{
          absFeb++;
        }
        break;
      case 3:
        mar++;
        if(status.toLowerCase() == "present"){
          presMar++;
        }else{
          absMar++;
        }
        break;
      case 4:
        apr++;
        if(status.toLowerCase() == "present"){
          presApr++;
        }else{
          absApr++;
        }
        break;
      case 5:
        may++;
        if(status.toLowerCase() == "present"){
          presMay++;
        }else{
          absMay++;
        }
        break;
      case 6:
        jun++;
        if(status.toLowerCase() == "present"){
          presJun++;
        }else{
          absJun++;
        }
        break;
      case 7:
        jul++;
        if(status.toLowerCase() == "present"){
          presJul++;
        }else{
          absJul++;
        }
        break;
      case 8:
        aug++;
        if(status.toLowerCase() == "present"){
          presAug++;
        }else{
          absAug++;
        }
        break;
      case 9:
        sep++;
        if(status.toLowerCase() == "present"){
          presSep++;
        }else{
          absSep++;
        }
        break;
      case 10:
        oct++;
        if(status.toLowerCase() == "present"){
          presOct++;
        }else{
          absOct++;
        }
        break;
      case 11:
        nov++;
        if(status.toLowerCase() == "present"){
          presNov++;
        }else{
          absNov++;
        }
        break;
      case 12:
        dec++;
        if(status.toLowerCase() == "present"){
          presDec++;
        }else{
          absDec++;
        }
        break;
    }
  }

  Future<List<GDPData>> getChartData() async {
    late List<GDPData> chartdata = [];
    final conn = await MySqlConnection.connect(ConnectionSettings(
      host: '10.0.2.2',
      port: 3306,
      user: 'root',
      db: 'db_aims',
    ));
    var resultsAbsent = await conn.query(
        'SELECT * FROM attendance WHERE student_id="${globals.userid}"  && status ="ABSENT"');
    var resultsPresent = await conn.query(
        'SELECT * FROM attendance WHERE student_id="${globals.userid}" && status ="PRESENT"');
    chartdata.add(GDPData(state: "Present", GDP: resultsPresent.length));
    chartdata.add(GDPData(state: "Absent", GDP: resultsAbsent.length));
    totalclass = resultsAbsent.length + resultsPresent.length;
    var totalresults = await conn
        .query('SELECT * FROM attendance WHERE student_id="${globals.userid}"');
    var dataList;
    dataList =
        List.generate(totalresults.length, (i) => ["", ""], growable: false);
    int i = 0;
    int j = 0;
    for (var row in totalresults) {
      while (j < 2) {
        if (j == 0) {
          //date
          DateTime _datetime = row[3];
          DateFormat formatter = DateFormat.MMMMd('en_US');
          computerMonth(_datetime,row[4]);
          String formatted = formatter.format(_datetime);
          dataList[i][j] = "$formatted";
          print(row[3]);
        } else if (j == 1) {
          //status
          dataList[i][j] = row[4];
          print(row[4]);
        }
        j++;
      }
      i++;
      j = 0;
    }
    totalStudentData = dataList;
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
                  switch (projectsnap.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return CircularProgressIndicator();
                    default:
                      if (projectsnap.hasData) {
                        _chartdata = projectsnap.data!;
                        return Card(
                          elevation: 2,
                          child: Column(children: <Widget>[
                            SfCircularChart(
                              legend: Legend(
                                  isVisible: true,
                                  overflowMode: LegendItemOverflowMode.wrap,
                                  textStyle: TextStyle(
                                      fontSize: 21, fontFamily: "Roboto")),
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
                            Text(
                              "Days total: $totalclass",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: "Roboto",
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: getProportionateScreenWidth(10, context),
                            ),
                            Table(
                              border: TableBorder(
                                  left: BorderSide.none,
                                  right: BorderSide.none,
                                  top: BorderSide(color: Colors.black54),
                                  bottom: BorderSide(color: Colors.black54),
                                  horizontalInside:
                                      BorderSide(color: Colors.black54)),
                              columnWidths: <int, TableColumnWidth>{
                                0: FlexColumnWidth(),
                                1: FlexColumnWidth(),
                                2: FlexColumnWidth(),
                                3: FlexColumnWidth(),
                              },
                              defaultVerticalAlignment:
                                  TableCellVerticalAlignment.fill,
                              children: <TableRow>[
                                TableRow(
                                  children: <Widget>[
                                    TableCell(
                                      child: Container(
                                        color: Colors.green,
                                        child: Text(
                                          "Months",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                              fontFamily: "Roboto"),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      verticalAlignment:
                                          TableCellVerticalAlignment.fill,
                                      child: Container(
                                        color: Colors.green,
                                        child: Text(
                                          "SchoolDays",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontFamily: "Roboto"),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      verticalAlignment:
                                          TableCellVerticalAlignment.top,
                                      child: Container(
                                        color: hexToColor("#4a87b9"),
                                        child: Text(
                                          "Present",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                              fontFamily: "Roboto"),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      verticalAlignment:
                                          TableCellVerticalAlignment.top,
                                      child: Container(
                                        color: hexToColor("#c06b84"),
                                        child: Text(
                                          "Absent",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                              fontFamily: "Roboto"),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                tableRow("Jan", jan,presJan, absJan),
                                tableRow("Feb", feb, presFeb, absFeb),
                                tableRow("Mar", mar, presMar, absMar),
                                tableRow("Apr", apr, presApr, absApr),
                                tableRow("May", may, presMay, absMay),
                                tableRow("Jun", jun, presJun, absJun),
                                tableRow("Jul", jul, presJul, absJul),
                                tableRow("Aug", aug, presAug, absAug),
                                tableRow("Sep", sep, presSep, absSep),
                                tableRow("Oct", oct, presOct, absOct),
                                tableRow("Nov", nov, presNov, absNov),
                                tableRow("Dec", dec, presDec, absDec),
                              ],
                            ),
                            SizedBox(
                              height: getProportionateScreenWidth(20, context),
                            ),
                            Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Text(
                                      "Date",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 25),
                                    ),
                                    Text(
                                      "Status",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 25),
                                    )
                                  ],
                                ),
                                Container(
                                  child: SingleChildScrollView(
                                    physics: BouncingScrollPhysics(),
                                    child: ListView.builder(
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: totalclass,
                                        itemBuilder: (_, i) {
                                          print(totalStudentData);
                                          print(totalclass);
                                          return CustomListTile(
                                              Date: "${totalStudentData[i][0]}",
                                              status:
                                                  "${totalStudentData[i][1]}");
                                        }),
                                  ),
                                )
                              ],
                            ),
                          ]),
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

  TableRow tableRow(String date, int schooldays, int pres, int abs) {
    return TableRow(
      children: <Widget>[
        TableCell(
          child: Container(
            color: Colors.white,
            child: Text(
              "$date",
              style: TextStyle(
                  color: Colors.black, fontSize: 18, fontFamily: "Roboto"),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.fill,
          child: Container(
            color: Colors.white,
            child: Text(
              "$schooldays",
              style: TextStyle(
                  color: Colors.black, fontSize: 16, fontFamily: "Roboto"),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.top,
          child: Container(
            color: Colors.white,
            child: Text(
              "$pres",
              style: TextStyle(
                  color: Colors.black, fontSize: 18, fontFamily: "Roboto"),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.top,
          child: Container(
            color: Colors.white,
            child: Text(
              "$abs",
              style: TextStyle(
                  color: Colors.black, fontSize: 18, fontFamily: "Roboto"),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}

class GDPData {
  final String state;
  final int GDP;

  GDPData({required this.state, required this.GDP});
}

class CustomListTile extends StatefulWidget {
  String Date;
  String status;

  CustomListTile({required this.Date, required this.status});

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
          color: widget.status == "PRESENT"
              ? hexToColor("#4a87b9")
              : hexToColor("#c06b84"),
        ),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    widget.Date,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontFamily: "Roboto"),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    widget.status,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontFamily: "Roboto"),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
