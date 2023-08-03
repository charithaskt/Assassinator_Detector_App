import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class UserList extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  bool check =false;
  @override
  Widget build(BuildContext context) {
    final users= Provider.of<List<UserListelement>>(context);
    check=false;
    users.forEach((x){
      /*print("already added");
      print(x.joined);
      print(x.email);*/
      if(x.joined== 'yes'){
        check= true;
      }
    } );
    return Container(
       child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            for(var x in users)
            if(x.joined=='yes')
            Text(x.email,style: TextStyle(color: Colors.greenAccent[400],fontSize: 20),),

            if(check == false)
            Text("No one joined yet",style: TextStyle(color: Colors.red[400],fontSize: 20),),
          ]
       ),
    );
  }
}

class UserListelement{
  final String email;
  final String joined;
   UserListelement({this.email,this.joined});
   }