import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:sped_mobile_app/SideDrawer.dart';
import 'package:sped_mobile_app/TeacherConsulation/conversationlist.dart';
import 'package:sped_mobile_app/tool.dart';
import 'package:sped_mobile_app/Globals/globals.dart' as globals;
class ChartPage extends StatefulWidget {
  const ChartPage({Key? key}) : super(key: key);

  @override
  _ChartPageState createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {

  Future <List<ChatUsers>> getJsonData() async{
    late List<ChatUsers> chatUser = [];
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
        for(int i=0;i<dataList.length;i++){
          for(int j=0;j<1;j++){
            print(dataList[i][j]);
            chatUser.add(ChatUsers(id:dataList[i][j] ,name: dataList[i][j+1],email: dataList[i][j+2]
                ,imageURL: dataList[i][j+3] == "Male" ? "assets/image/man.png" : "assets/image/woman.png"));
          }
        }


    return chatUser;
  }



  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
      drawer: SideDrawer(state: "Teacher Consultation"),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text("Teacher Consultation"),elevation: 3,
        backgroundColor: hexToColor("#2c3136"),
      ),
      body: SingleChildScrollView(
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
                      "Conversations",
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),

                  ],
                ),
              ),
            ),

            FutureBuilder<List<ChatUsers>>( future: getJsonData(),
                builder: (contexts, projectsnap){
              switch(projectsnap.connectionState){
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return CircularProgressIndicator();
                default:
                  if(projectsnap.hasData){
                    var chatdata= projectsnap.data;
                    return ListView.builder(
                      itemCount: chatdata!.length,
                      shrinkWrap: true,
                      padding: EdgeInsets.only(top: 16),
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return ConversationList(
                          id: chatdata[index].id,
                          name: chatdata[index].name,
                          email: chatdata[index].email,
                          imageUrl: chatdata[index].imageURL,
                        );
                      },
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

class ChatUsers {
  String id;
  String name;
  String email;
  String imageURL;

  ChatUsers(
      {required this.id,required this.name,
      required this.imageURL,
      required this.email});
}
