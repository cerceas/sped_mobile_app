import 'package:flutter/material.dart';
import 'package:sped_mobile_app/LogAndReg/LoginScreen.dart';
import 'package:sped_mobile_app/SideDrawer.dart';
import 'package:sped_mobile_app/tool.dart';
import 'package:sped_mobile_app/Globals/globals.dart' as globals;

class AcadPerformance extends StatefulWidget {
  const AcadPerformance({Key? key}) : super(key: key);

  @override
  _AcadPerformanceState createState() => _AcadPerformanceState();
}

class _AcadPerformanceState extends State<AcadPerformance> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      drawer: SideDrawer(state: "Academic Performance"),
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
        title: Text("Academic Performance"),
        // automaticallyImplyLeading: false,
        elevation: 3,
        backgroundColor: hexToColor("#2c3136"),
      ),
      body: Column(
        children:<Widget> [
          SizedBox(
            height: 60,
          ),
          AcadPerBody(),
          SizedBox(
            height: 18,
          ),
      Container(
        height: 180,
        width: 180,
        child: Flexible(
          child: Material(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              color: Colors.blue[700],
              elevation: 10,
              child: InkWell(
                onTap: (){},
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        "assets/image/finals.png",
                        width: 100,
                        fit: BoxFit.fitWidth,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                       "Finals",
                        style:TextStyle(
                            color: Colors.green[100],
                            fontSize: 16,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              )
          ),
        ),
      )
        ],
      ),
    );
  }
}
class AcadPerBody extends StatelessWidget {
   AcadPerBody({Key? key}) : super(key: key);
  Items item1 = new Items(
    title: "First Quarter",
    img: "assets/image/books.png",
    toch: () {

    },
  );

  Items item2 = new Items(
    title: "Second Quarter",
    img: "assets/image/rulers.png",
    toch: () {

    },
  );
  Items item3 = new Items(
    title: "Third Quarter",
    img: "assets/image/globe.png",
    toch: () {

    },
  );
  Items item4 = new Items(
    title: "Fourth Quarter",
    img: "assets/image/board.png",
    toch:() {

    },
  );
  @override
  Widget build(BuildContext context) {
    List<Items> myList = [item1, item2, item3, item4];
      return Flexible(child: GridView.count(
        childAspectRatio: 1.0,
        padding: EdgeInsets.only(left: 16, right: 16),
        crossAxisCount: 2,
        crossAxisSpacing: 18,
        shrinkWrap: true,
        mainAxisSpacing: 18,
        children: myList.map((data) {
          return Material(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              color: Colors.blue[700],
              elevation: 10,
              child: InkWell(
                onTap: data.toch,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        data.img,
                        width: 100,
                        fit: BoxFit.fitWidth,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        data.title,
                        style:TextStyle(
                            color: Colors.green[100],
                            fontSize: 16,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              )
          );
        }).toList()),
    );
  }
}

class AcadPerformBody extends StatefulWidget {
  const AcadPerformBody({Key? key}) : super(key: key);

  @override
  _AcadPerformBodyState createState() => _AcadPerformBodyState();
}

class _AcadPerformBodyState extends State<AcadPerformBody> {
  Items item1 = new Items(
    title: "First Quarter",
    img: "assets/image/books.png",
    toch: () {

    },
  );

  Items item2 = new Items(
    title: "Second Quarter",
    img: "assets/image/rulers.png",
    toch: () {

    },
  );
  Items item3 = new Items(
    title: "Third Quarter",
    img: "assets/image/globe.png",
    toch: () {

    },
  );
  Items item4 = new Items(
    title: "Fourth Quarter",
    img: "assets/image/board.png",
    toch:() {

    },
  );
  Items item5 = new Items(
    title: "Finals",
    img: "assets/image/finals.png",
    toch:() {

    },
  );
  late List<Items> myList;
@override
  void initState() {
    // TODO: implement initState
    super.initState();
   myList = [item1, item2, item3, item4,item5];
  }
  @override
  Widget build(BuildContext context) {

    return Flexible(child: GridView.count(
        childAspectRatio: 1.0,
        padding: EdgeInsets.only(left: 16, right: 16),
        crossAxisCount: 2,
        crossAxisSpacing: 18,
        mainAxisSpacing: 18,
        children: myList.map((data) {
          return Material(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              color: Colors.blue[700],
              elevation: 10,
              child: InkWell(
                onTap: data.toch,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        data.img,
                        width: 100,
                        fit: BoxFit.fitWidth,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        data.title,
                        style:TextStyle(
                                color: Colors.green[100],
                                fontSize: 16,
                                fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              )
          );
        }).toList()),
    );
  }
}
class Items {
  String title;
  String img;
  GestureTapCallback toch;
  Items({required this.title,required this.img,required this.toch});
}