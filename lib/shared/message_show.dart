import 'dart:collection';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';

class Msg extends StatefulWidget {
  final bool check;
  Msg({
      this.check,
      Key key,
  }):super(key:key);
  @override
  _MsgState createState() => _MsgState();
}

class _MsgState extends State<Msg> {
  List<String> data;
  List<String> emails;
  List<Msgshow> datshow =List();
  //List<Msgshow> dat =List();
  @override
  void initState(){
    super.initState();
    //if (widget.check ==true){
   
  }
  
  

  @override
  Widget build(BuildContext context) {
    DatabaseReference dbRef= FirebaseDatabase.instance.reference().child("iot-project-b5131/Messages");
    dbRef.orderByChild("timestamp").once().then((DataSnapshot snap){
    var dat=snap.value;
    datshow.clear();
    dat.forEach((key,value){
      Msgshow mshow= new Msgshow(
        email:value["email"],
        data:value['msg'],
        timestamp: value['timestamp'],
      );
       datshow.add(mshow);
    });
    datshow.sort((a,b)=>a.timestamp.compareTo(b.timestamp));
  });

    final double height=datshow.length*75.0;
    if (widget.check==true &&  !(datshow.length==0))
    /*return Container(
      child:SizedBox(height:10.0),
      );*/
    return Container(
     height: height,
      child: new ListView.separated(
        reverse: true,
        padding: const EdgeInsets.all(8),
        itemCount: datshow.length,
      itemBuilder: (_, int i){
       return Container(
            child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child:
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(alignment:Alignment.bottomLeft,
                  child:Text("${datshow.length-i}",
                  style:TextStyle(fontSize:22.0),
                  textAlign: TextAlign.left,)),
                  Align(alignment:Alignment.topRight,
                  child:Text("By ${datshow[i].email}",
                  style:TextStyle(fontSize:18.0),
                  textAlign: TextAlign.left,)),
                ],
              ),
            ),
              Text(datshow[i].data,
           style:TextStyle(color:Colors.pink[800],fontSize:25.0),
           textAlign: TextAlign.center,),
          ]
            ),
           );
          /*      subtitle: Text("sent by ${datshow[i].email}"),
                );*/
      },
    separatorBuilder: (BuildContext context, int index) => const Divider(),
    ),
    );

    else
    return Container(
      child:SizedBox(height:5.0),
      );
  }
}

class Msgshow{
  String email, data;
  int timestamp;
  Msgshow({this.email,this.data,this.timestamp});
}