import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class GPSfind extends StatefulWidget {
  @override
  _GPSfindState createState() => _GPSfindState();
}

class _GPSfindState extends State<GPSfind> {
  
  var lat;
  var long;
  String gps='';
  var maxint;
  @override
  void initState(){
    super.initState();
    DatabaseReference dbRef= FirebaseDatabase.instance.reference().child("iot-project-b5131/Crime");
    dbRef.orderByChild("Index").once().then((DataSnapshot snap){
      var keys =snap.value.keys;
      print("key values");
      print(keys);
       var dat =snap.value;
      maxint=dat[keys.first]["Index"];
      print("maxint_gps");
      print(maxint);
     
     /* for (var i in keys){
        if(dat[i]['Index'].toInt()>=maxint.toInt()){
          maxint=dat[i]['Index'];
      lat=dat[i]['Lat'];
      long=dat[i]['Long'];

      }
    }*/
     lat=dat[keys.first]['Lat'];
      long=dat[keys.first]['Long'];
    gps='Latttide: '+lat.toString()+", Longitude: " +long.toString();
    print("gps");
    print(gps);} 
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: gps==null
      ?Text("Latttide: 30.02, Longitude: 40.003" )
      :Text(gps ,style: TextStyle(color: Colors.lightBlueAccent[200],fontSize: 21),textAlign: TextAlign.center,),
      
    );
  }
}
