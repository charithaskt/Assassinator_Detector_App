import 'package:assassinatordetectorapp/userList.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:assassinatordetectorapp/services/datbase.dart' as dat;

class Join extends StatefulWidget {
  final bool join;
  Join({
    this.join,
    Key key,
  }):super(key:key);
  @override
  _JoinState createState() => _JoinState();
}

class _JoinState extends State<Join> {
  @override
  Widget build(BuildContext context) {
    return widget.join==false? Container(
      child:Text("No one joined yet",style: TextStyle(color: Colors.red[400],fontSize: 20),),
    )
    :StreamProvider<List<UserListelement>>.value(
      value: dat.DatabaseService().usersjoined,
      child: UserList(),
      );
      
  }
}