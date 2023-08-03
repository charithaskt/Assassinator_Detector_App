import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class CriminalHis extends StatefulWidget {
  final bool val;
  CriminalHis({
      this.val,
      Key key,
  }):super(key:key);
  @override
  _CriminalHisState createState() => _CriminalHisState();
}

class _CriminalHisState extends State<CriminalHis> {
  String name ='';
  String details="";
  String adddetails="";
  List<Criminal> criminals= List();
  //List weapon_list = [];
  var maxint ;
  @override
  void initState(){
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    DatabaseReference dbRef= FirebaseDatabase.instance.reference().child("iot-project-b5131/CriminalHistory");
    dbRef.orderByChild("index").once().then((DataSnapshot snap){
      var dat=snap.value;
      criminals.clear();
      dat.forEach((key,value){
         Criminal crime =new Criminal(
           details: value["details"],
           name: value["name"],
           index:value["index"]);
           criminals.add(crime); 
      });
      criminals.sort((a,b)=>a.index.compareTo(b.index));
      name=criminals[criminals.length-1].name;
      details=criminals[criminals.length-1].details;
       } );
      DatabaseReference dbRef1= FirebaseDatabase.instance.reference().child("iot-project-b5131/CriminalAdd");
    dbRef1.orderByChild("name").once().then((DataSnapshot snap){
      var dat1=snap.value;
      adddetails="";
      dat1.forEach((key,value){
        if (value["name"]==name)
        if(!adddetails.contains(value['details'].toString()) & !details.contains(value['details'].toString()))
        adddetails=adddetails+"\n"+value["details"].toString();
      });
    });

   
    return Container(
     child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
           /* if(widget.val==true)
            SizedBox(height: 20.0),  */
          if(widget.val==true)
          Text(
            'Criminal History',
            style: TextStyle(color: Colors.blueGrey[400],fontSize: 40),
            //textAlign:TextAlign.left,
          ),
           if(widget.val==true)
           Align(
      alignment: Alignment.topLeft,
      child:Text(
            'Name',
            style: TextStyle(color: Colors.deepOrange[400],fontSize: 25),
            //textAlign:TextAlign.left,
          ),
           ),
          if(widget.val==true)
          Align(
      alignment: Alignment.topRight,
      child:name==null
      ?Text(
            'cobert',
            style: TextStyle(fontSize: 30),
            //textAlign:TextAlign.right,
          )
           :Text(
            name,
            style: TextStyle(fontSize: 30),
            //textAlign:TextAlign.right,
          )
          ),
          if(widget.val==true)
          Align(
      alignment: Alignment.topLeft,
      child:Text(
            'Details',
            style: TextStyle(color: Colors.deepOrange[400],fontSize: 25),
            textAlign:TextAlign.left,
          ),
          ),
          if(widget.val==true)
          Align(
      alignment: Alignment.topRight,
      child:details==null
       ?Text(
            'Calm and fast running criminal',
            style: TextStyle(fontSize: 30),
            //textAlign:TextAlign.right,
          )
         :Text(
            "$details $adddetails",
            style: TextStyle(fontSize: 30),
            //textAlign:TextAlign.right,
          )
          ),
           ]
            ),
            );
  }
}

class Criminal{
  String name,details;
  int index;
  Criminal({this.details,this.index,this.name}); 
}
