import 'package:flutter/material.dart';
import 'package:sped_mobile_app/TeacherConsulation/chatdetail.dart';


class ConversationList extends StatefulWidget {
  String id;
  String name;
  String imageUrl;
  String email;
  ConversationList({required this.id,required this.name,required this.imageUrl,required this.email});

  @override
  _ConversationListState createState() => _ConversationListState();
}

class _ConversationListState extends State<ConversationList> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => ChatDetail(id:widget.id,name: widget.name,imageUrl: widget.imageUrl,email: widget.email,)));

      },
      child: Container(
        padding: EdgeInsets.only(left: 16,right: 16,top: 10,bottom: 10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: AssetImage(widget.imageUrl),
                    maxRadius: 30,
                  ),
                  SizedBox(width: 16,),
                  Expanded(
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(widget.name, style: TextStyle(fontSize: 16),),
                          SizedBox(height: 6,),
                          Text(widget.email,style: TextStyle(fontSize: 13,color: Colors.grey.shade600,)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
