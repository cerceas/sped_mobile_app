import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:sped_mobile_app/Dashboard/item_list.dart';
import 'package:sped_mobile_app/tool.dart';
import 'package:sped_mobile_app/Globals/globals.dart' as globals;

class QuarterModel extends StatefulWidget {
  String quarter;
  int intQuarter;

  QuarterModel({required this.quarter, required this.intQuarter, Key? key})
      : super(key: key);

  @override
  State<QuarterModel> createState() => _QuarterModelState();
}

class _QuarterModelState extends State<QuarterModel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(
              Icons.help,
              color: Colors.white,
            ),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext buildcontext) {
                    return Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(width: 6, color: Colors.black38),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        height: MediaQuery.of(context).size.height / 3.3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Text(
                              "Student's Skills Development",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontFamily: "Roboto"),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Table(
                              border: TableBorder(
                                  left: BorderSide.none,
                                  right: BorderSide.none,
                                  top: BorderSide.none,
                                  bottom: BorderSide.none,
                                  verticalInside:
                                      BorderSide(color: Colors.black54)),
                              columnWidths: <int, TableColumnWidth>{
                                0: FixedColumnWidth(80),
                                1: FlexColumnWidth(),
                              },
                              defaultVerticalAlignment:
                                  TableCellVerticalAlignment.middle,
                              children: <TableRow>[
                                tableRow("A", "Improving"),
                                tableRow("B", "Developing"),
                                tableRow("C", "Beginning"),
                                tableRow("D", "Needs improvement"),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  });
            },
          )
        ],
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(widget.quarter),
        // automaticallyImplyLeading: false,
        elevation: 3,
        backgroundColor: hexToColor("#2c3136"),
      ),
      // backgroundColor: Colors.orange,
      body: ProgressReport(
        progressQuarter: widget.intQuarter,
      ),
    );
  }
}

TableRow tableRow(String grade, String description) {
  return TableRow(
    children: <Widget>[
      TableCell(
        child: Container(
          color: Colors.white,
          child: Text(
            "$grade",
            style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontFamily: "Roboto",
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.fill,
        child: Container(
          color: Colors.white,
          child: Text(
            " $description",
            style: TextStyle(
                color: Colors.black, fontSize: 16, fontFamily: "Roboto"),
            textAlign: TextAlign.start,
          ),
        ),
      ),
    ],
  );
}

class ProgressReport extends StatefulWidget {
  int progressQuarter;

  ProgressReport({required this.progressQuarter, Key? key}) : super(key: key);

  @override
  _ProgressReportState createState() => _ProgressReportState();
}

class _ProgressReportState extends State<ProgressReport> {
  late Future<List<Item>> progressReport;

  Future<List<Item>> getReport() async {
    late List<Item> _data_item = <Item>[];
    final conn = await MySqlConnection.connect(ConnectionSettings(
      host: '10.0.2.2',
      port: 3306,
      user: 'root',
      db: 'db_aims',
    ));
    var dataList;
    var results = await conn.query(
        'SELECT * FROM 	grades_report_card WHERE student_id="${globals.userid}" and quarter="${widget.progressQuarter}"');
    dataList = List.generate(
        results.length,
        (i) => [
              "",
              "",
              "",
            ],
        growable: false);

    int i = 0;
    int j = 0;
    for (var row in results) {
      while (j < 3) {
        if (j == 0) {
          //title
          dataList[i][j] = "${row[2]}";
        } else if (j == 1) {
          //grade
          dataList[i][j] = "${row[3]}";
        } else if (j == 2) {
          //remarks
          dataList[i][j] = "${row[6]}";
        }
        j++;
      }
      i++;
      j = 0;
    }
    for (int i = 0; i < dataList.length; i++) {
      for (int j = 0; j < 1; j++) {
        print(dataList[i][j]);
        _data_item.add(Item(
            expandedValue: dataList[i][j + 2],
            headerValue: dataList[i][j],
            isExpanded: false,
            date: dataList[i][j + 1]));
      }
    }
    return _data_item;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    progressReport = getReport();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
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
                          fontSize: 16,
                          fontFamily: "Roboto")),
                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                    child: Text("Name: ${globals.userName}",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: "Roboto"))),
                Padding(
                    padding: EdgeInsets.fromLTRB(20, 5, 20, 20),
                    child: Text("Sped Level: ${globals.section}",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
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
          FutureBuilder<List<Item>>(
              future: progressReport,
              builder: (context, projectSnap) {
                switch (projectSnap.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Center(child: CircularProgressIndicator());
                  default:
                    if (projectSnap.hasData) {
                      print("HAHA");
                      var listdata = projectSnap.data;

                      if (listdata!.length != 0) {
                        print("Inside");
                        return ExpansionPanelList(
                          expansionCallback: (int index, bool isExpanded) {
                            setState(() {
                              listdata[index].isExpanded = !isExpanded;
                            });
                          },
                          children: listdata.map<ExpansionPanel>((Item item) {
                            return ExpansionPanel(
                              headerBuilder:
                                  (BuildContext context, bool isExpanded) {
                                return ListTile(
                                  title: Text(item.headerValue,
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          color: isExpanded
                                              ? Colors.teal
                                              : Colors.black)),
                                  trailing: Text(item.date,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0,
                                          color: Colors.black)),
                                  subtitle: isExpanded
                                      ? Text("")
                                      : RichText(
                                          overflow: TextOverflow.ellipsis,
                                          strutStyle:
                                              StrutStyle(fontSize: 12.0),
                                          text: TextSpan(
                                            style: TextStyle(
                                                color: Colors.grey.shade500),
                                            text: item.expandedValue,
                                          ),
                                        ),
                                );
                              },
                              body: Column(
                                children: <Widget>[
                                  Container(
                                      padding: EdgeInsets.only(
                                          left: 15.0,
                                          right: 30.0,
                                          bottom: 15.0),
                                      child: Text(
                                        " Remarks: ${item.expandedValue == "" ? "none" : item.expandedValue}",
                                        style: TextStyle(wordSpacing: 2.0),
                                        textAlign: TextAlign.justify,
                                      ))
                                ],
                              ),
                              isExpanded: item.isExpanded,
                            );
                          }).toList(),
                        );
                      } else {
                        return Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Container(
                                child: Image.asset("assets/image/file.png",
                                    height:
                                        MediaQuery.of(context).size.height / 5,
                                    width:
                                        MediaQuery.of(context).size.width / 4),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "No data",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "CooperBlack"),
                              ),
                            ],
                          ),
                        );
                      }
                    }
                }
                return Container();
              }),
        ],
      ),
    ));
  }
}


