import 'dart:convert';
import 'package:sped_mobile_app/Globals/globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mysql1/mysql1.dart';
import 'package:sped_mobile_app/Dashboard/item_list.dart';
import 'package:sped_mobile_app/LogAndReg/LoginScreen.dart';
import 'package:sped_mobile_app/SideDrawer.dart';
import 'package:sped_mobile_app/tool.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  List<Widget> bottomNav = <Widget>[DashboardTeacher(),DashboardAdmin()];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      drawer: SideDrawer(state: "Dashboard"),
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
        title: Text("Dashboard"),
        // automaticallyImplyLeading: false,
        elevation: 3,
        backgroundColor: hexToColor("#2c3136"),
      ),
      body: bottomNav.elementAt(_selectedIndex),
      backgroundColor: Colors.white,
          bottomNavigationBar: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.school),
                label: 'Teacher',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_circle),
                label: 'Admin',
              ),
            ],currentIndex: _selectedIndex,
            selectedItemColor: Colors.amber[800], unselectedItemColor: Colors.white,
            onTap: _onItemTapped,
          ),
    ));
  }


}

class DashboardAdmin extends StatefulWidget {
  @override
  _DashboardAdminState createState() => _DashboardAdminState();
}

class _DashboardAdminState extends State<DashboardAdmin> {
  late Future<List<Item>> AdminTotaldata;

  Future<List<Item>> generateAdminData() async {
    late List<Item> _data_item = <Item>[];
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
          //messagefrom
          dataList[i][j] = "${row[2]}";
        }else if(j==1){
          //date
          DateTime _datetime=row[6];
          DateFormat formatter = DateFormat.MMMMd('en_US');
          String formatted = formatter.format(_datetime);
          dataList[i][j] = "$formatted";
        }else if(j==2){
          //title
          dataList[i][j] = "${row[4]}";
        }else if(j==3){
          //message
          dataList[i][j] = "${row[5]}";
        }
        else if(j==4){
          //id
          dataList[i][j] = "${row[0]}";
        }
        j++;
      }
      i++;
      j = 0;
    }
    for(int i=0;i<dataList.length;i++){
      for(int j=0;j<1;j++){
        print(dataList[i][j]);
       _data_item.add(Item(expandedValue: dataList[i][j+3], headerValue: dataList[i][j+2],isExpanded: false,date: dataList[i][j+1]));
      }
    }

    return _data_item;
  }



  @override
  void initState() {
    super.initState();
    AdminTotaldata=generateAdminData();
  }

  @override
  Widget build(BuildContext context) {
    return  RefreshIndicator(color: Colors.white,
    strokeWidth: 5,
    displacement: 200,
    edgeOffset: 20,
    triggerMode: RefreshIndicatorTriggerMode.onEdge,
    backgroundColor: Colors.blue,
    onRefresh: ()  async{
      AdminTotaldata=generateAdminData();
    },
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SafeArea(
                  child: Padding(
                    padding: EdgeInsets.only(left: 16, right: 16, top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Admin Announcement",
                          style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                        ),

                      ],
                    ),
                  ),
                ),
                FutureBuilder<List<Item>>(future: AdminTotaldata,
                    builder: (context,projectSnap){
                  switch(projectSnap.connectionState){
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return Center(child: CircularProgressIndicator());
                    default:
                      if(projectSnap.hasData){
                        var listdata=projectSnap.data;

                        return ExpansionPanelList(
                          expansionCallback: (int index, bool isExpanded) {
                            setState(() {
                              listdata![index].isExpanded = !isExpanded;
                            });
                          },
                          children: listdata!.map<ExpansionPanel>((Item item) {
                            return ExpansionPanel(
                              headerBuilder: (BuildContext context, bool isExpanded) {
                                return ListTile(
                                  title: Text(item.headerValue, style: TextStyle(fontSize: 18.0,color: isExpanded ? Colors.teal : Colors.black)),
                                  trailing: Text(item.date),
                                  subtitle:isExpanded ? Text(""):RichText(
                                    overflow: TextOverflow.ellipsis,
                                    strutStyle: StrutStyle(fontSize: 12.0),
                                    text: TextSpan(
                                        style: TextStyle(color: Colors.grey.shade500),
                                        text: item.expandedValue,
                                  ),
                                ),);
                              },
                              body: Column(
                                children: <Widget>[
                                  Container(
                                      padding: EdgeInsets.only(left: 15.0, right: 30.0, bottom: 15.0),
                                      child: Text(item.expandedValue, style: TextStyle(wordSpacing: 2.0), textAlign: TextAlign.justify,))
                                ],

                              ),
                              isExpanded: item.isExpanded,
                            );
                          }).toList(),
                        );
                      }

                  }
                  return Container();
                }),
              ],
            ),
          ),
    );
  }
}
class DashboardTeacher extends StatefulWidget {
  @override
  _DashboardTeacherState createState() => _DashboardTeacherState();
}

class _DashboardTeacherState extends State<DashboardTeacher> {

  late Future<List<Item>> TeacherTotaldata;
  Future<List<Item>> generateTeacherData() async {
    late List<Item> _data_item = <Item>[];
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
          DateFormat formatter = DateFormat.MMMMd('en_US');
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
    for(int i=0;i<dataList.length;i++){
      for(int j=0;j<1;j++){
        print(dataList[i][j]);
        _data_item.add(Item(expandedValue: dataList[i][j+3], headerValue: dataList[i][j+2],isExpanded: false,date: dataList[i][j+1]));
      }
    }


    return _data_item;
  }


  @override
  void initState() {
    super.initState();
    TeacherTotaldata=generateTeacherData();
  }

  @override
  Widget build(BuildContext context) {
    return  RefreshIndicator(color: Colors.white,
      strokeWidth: 5,
      displacement: 200,
      edgeOffset: 20,
      triggerMode: RefreshIndicatorTriggerMode.onEdge,
      backgroundColor: Colors.blue,
      onRefresh: ()  async{
        TeacherTotaldata=generateTeacherData();
      },
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SafeArea(
              child: Padding(
                padding: EdgeInsets.only(left: 16, right: 16, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Teacher Announcement",
                      style:
                      TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),

                  ],
                ),
              ),
            ),
            FutureBuilder<List<Item>>(future: TeacherTotaldata,
                builder: (context,projectSnap){
                  switch(projectSnap.connectionState){
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                    return Center(child: CircularProgressIndicator());
                    default:
                      if(projectSnap.hasData){
                        var listdata=projectSnap.data;
                        return ExpansionPanelList(
                          expansionCallback: (int index, bool isExpanded) {
                            setState(() {
                              listdata![index].isExpanded = !isExpanded;
                            });
                          },
                          children: listdata!.map<ExpansionPanel>((Item item) {
                            return ExpansionPanel(
                              headerBuilder: (BuildContext context, bool isExpanded) {
                                return ListTile(
                                  title: Text(item.headerValue, style: TextStyle(fontSize: 18.0,color: isExpanded ? Colors.teal : Colors.black)),
                                  trailing: Text(item.date),
                                  subtitle:isExpanded ? Text(""):RichText(
                                    overflow: TextOverflow.ellipsis,
                                    strutStyle: StrutStyle(fontSize: 12.0),
                                    text: TextSpan(
                                      style: TextStyle(color: Colors.grey.shade500),
                                      text: item.expandedValue,
                                    ),
                                  ),);
                              },
                              body: Column(
                                children: <Widget>[
                                  Container(
                                      padding: EdgeInsets.only(left: 15.0, right: 30.0, bottom: 15.0),
                                      child: Text(item.expandedValue, style: TextStyle(wordSpacing: 2.0), textAlign: TextAlign.justify,))
                                ],

                              ),
                              isExpanded: item.isExpanded,
                            );
                          }).toList(),
                        );
                      }

                  }
                  return Container();
                }),

          ],
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
