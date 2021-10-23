import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mysql1/mysql1.dart';
import 'package:sped_mobile_app/Globals/globals.dart' as globals;

class ChatDetail extends StatefulWidget {
  String name;
  String imageUrl;
  String id;
  String email;

  ChatDetail(
      {required this.id,
      required this.name,
      required this.imageUrl,
      required this.email});

  @override
  _ChatDetailState createState() => _ChatDetailState();
}

class _ChatDetailState extends State<ChatDetail> {
  late StreamController<List<ChatMessage>> _streamMessages;
  void getJsonData() async {
    var timeList = [];
    late List<ChatMessage> messages = [];
    final conn = await MySqlConnection.connect(ConnectionSettings(
      host: '10.0.2.2',
      port: 3306,
      user: 'root',
      db: 'db_aims',
    ));
    List parentmess;
    var parentmessage = await conn.query(
        'SELECT * FROM feedback WHERE message_from = "${globals.userid}" && message_to = "${widget.id}"');
    parentmess = List.generate(parentmessage.length, (i) => ["", DateTime],
        growable: false);
    var teachermessage = await conn.query(
        'SELECT * FROM feedback WHERE message_from = "${widget.id}" && message_to = "${globals.userid}"');
    List totalmessages = List.generate(
        parentmessage.length + teachermessage.length, (i) => ["", DateTime, ""],
        growable: false);
    int i = 0;
    int j = 0;
    for (var row in parentmessage) {
      while (j < 3) {
        if (j == 0) {
          //message
          parentmess[i][j] = "${row[4]}";
          totalmessages[i][j] = "${row[4]}";
        } else if (j == 1) {
          //date
          var newStr = row[5].toString().substring(0, 10) +
              ' ' +
              row[5].toString().substring(11, 23);
          DateTime dt = DateTime.parse(newStr);
          timeList.add(dt);
          parentmess[i][j] = dt;
          totalmessages[i][j] = dt;
        } else if (j == 2) {
          totalmessages[i][j] = "sender";
        }
        j++;
      }
      i++;
      j = 0;
    }

    List teachermess;

    teachermess = List.generate(teachermessage.length, (k) => ["", DateTime],
        growable: false);
    int k = 0;
    int l = 0;

    for (var row in teachermessage) {
      while (l < 3) {
        if (l == 0) {
          //message
          teachermess[k][l] = "${row[4]}";
          totalmessages[k + i][l] = "${row[4]}";
        } else if (l == 1) {
          //date
          var newStr = row[5].toString().substring(0, 10) +
              ' ' +
              row[5].toString().substring(11, 23);
          DateTime dt = DateTime.parse(newStr);
          timeList.add(dt);

          teachermess[k][l] = dt;
          totalmessages[k + i][l] = dt;
        } else if (l == 2) {
          totalmessages[k + i][l] = "receiver";
        }
        l++;
      }
      k++;
      l = 0;
    }

    // timeList.sort((a, b) => a.compareTo(b));
    // print(timeList);


    // print("total message: $totalmessages");
    totalmessages.sort((a, b) => a[1].compareTo(b[1]));

    for (int i = 0; i < totalmessages.length; i++) {
      for (int j = 0; j < 1; j++) {
        messages.add(ChatMessage(
            messageContent: totalmessages[i][j],
            messageType: totalmessages[i][j + 2]));
      }
    }

    SchedulerBinding.instance!.addPostFrameCallback((_) =>
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent));

    print(messages.length);
    _streamMessages.add(messages);

    // return messages;
  }

  final myController = TextEditingController();
  final ScrollController _scrollController = ScrollController(
    initialScrollOffset: 0.0,
    keepScrollOffset: true,
  );
  FocusNode _focusNode = new FocusNode();
  @override
  void initState() {
    super.initState();

    getJsonData();
    _streamMessages = StreamController<List<ChatMessage>>();
    _focusNode.addListener(_focusNodeListener);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_focusNodeListener);
    super.dispose();
  }
  Future<Null> _focusNodeListener() async {
    if (_focusNode.hasFocus){
      print('TextField got the focus');

    } else {
      print('TextField lost the focus');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        flexibleSpace: SafeArea(
          child: Container(
            padding: EdgeInsets.only(right: 16),
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  width: 2,
                ),
                CircleAvatar(
                  backgroundImage: AssetImage(widget.imageUrl),
                  maxRadius: 20,
                ),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        widget.name,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        widget.email,
                        style: TextStyle(
                            color: Colors.grey.shade600, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(children: <Widget>[
        Flexible(fit: FlexFit.tight,
          child: StreamBuilder<List<ChatMessage>>(
              stream: _streamMessages.stream,
              builder: (contexts, projectsnap) {
                switch(projectsnap.connectionState){
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return CircularProgressIndicator();
                  default:
                    if(projectsnap.hasData){
                      var chatdata=projectsnap.data;
                      return Container(
                        height: MediaQuery.of(context).size.height / 1.24,
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          physics: BouncingScrollPhysics(),
                          child: ListView.builder(
                            itemCount: chatdata!.length,
                            shrinkWrap: true,
                            padding: EdgeInsets.only(top: 10, bottom: 10),
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Container(
                                padding:
                                EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
                                child: Align(
                                  alignment: (chatdata[index].messageType == "receiver"
                                      ? Alignment.topLeft
                                      : Alignment.topRight),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: (chatdata[index].messageType == "receiver"
                                          ? Colors.grey.shade200
                                          : Colors.blue[200]),
                                    ),
                                    padding: EdgeInsets.all(16),
                                    child: Text(
                                      chatdata[index].messageContent,
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    }
                }
                return Container();
              }),
        ),

        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
            height: 60,
            width: double.infinity,
            color: Colors.white,
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: TextField(focusNode: _focusNode,
                    controller: myController,
                    decoration: InputDecoration(
                        hintText: "Write message...",
                        hintStyle: TextStyle(color: Colors.black54),
                        border: InputBorder.none),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                FloatingActionButton(
                  onPressed: ()  async{
                    final conn = await MySqlConnection.connect(ConnectionSettings(
                      host: '10.0.2.2',
                      port: 3306,
                      user: 'root',
                      db: 'db_aims',
                    ));
                    DateTime dt= DateTime.now();
                    var result = await conn.query('INSERT INTO feedback (message_from,message_to,title,message,time_of_message) values (?,?,?,?,?)',
                        [globals.userid, widget.id,"Dummy",myController.text,dt.toUtc()]);
                    setState(() {
                      myController.clear();
                      getJsonData();
                    });
                  },
                  child: Icon(
                    Icons.send,
                    color: Colors.white,
                    size: 18,
                  ),
                  backgroundColor: Colors.blue,
                  elevation: 0,
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}

class ChatMessage {
  String messageContent;
  String messageType;

  ChatMessage({required this.messageContent, required this.messageType});
}
