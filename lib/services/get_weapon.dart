//import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Weapon extends StatefulWidget {
  @override
  _WeaponState createState() => _WeaponState();
}

class _WeaponState extends State<Weapon> {
  
 String weapon ='';
  //List weapon_list = [];
  var maxint ;
  @override
  void initState(){
    super.initState();
    DatabaseReference dbRef= FirebaseDatabase.instance.reference().child("iot-project-b5131/Crime");
    dbRef.orderByChild("Index").once().then((DataSnapshot snap){
      var keys =snap.value.keys;
      print("key values");
      print(keys);
      var dat =snap.value;
      //weapon_list.clear();
      //for(var i in keys){
      maxint=dat[keys.first]["Index"];
     print("maxint");
     print(maxint);
      /*for (var i in keys){
        var x=dat[i]['Index'];
        if(x.toInt()>=maxint.toInt()){
          maxint=dat[i]['Index'];
          setState(() {
            weapon=dat[i]['objects'];
          });
      
      }
      
    }  */
    weapon=dat[keys.first]['objects'];
    print("weapon");
      print (weapon);
      //weapon_list.add(weapon);
     // }
    } );
  }
  
  

  @override
  Widget build(BuildContext context) {
    return Container(
      child: weapon == null
      ?Text("saw")
      :Text(weapon,style: TextStyle(color:Colors.blue,fontSize: 21),),
      
    );
  }
}
