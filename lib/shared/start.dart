 import 'package:assassinatordetectorapp/models/user.dart';
import 'package:assassinatordetectorapp/services/geolocation.dart';
  import 'package:flutter/material.dart';
  import 'package:assassinatordetectorapp/services/datbase.dart' as dat;

 class Start extends StatefulWidget {
   final User user;
   final String email;
   final bool start;
   Start({
     this.user,
     this.email,
     this.start,
     Key key,
   }):super(key:key);
   @override
   _StartState createState() => _StartState();
 }
 
 class _StartState extends State<Start> {
   @override
   Widget build(BuildContext context) {
     return Container(
       child:Column(
         children:[
           if(widget.start==false)
            Align(
      alignment: Alignment.topCenter,
      child:RaisedButton(
                color: Colors.deepOrange[400],
                child: Text(
                  'You cannot start as crime is solved',
                  style: TextStyle(color: Colors.blue[50],fontSize: 20.0),
                ),
                onPressed: () async {
                  return null;
                }
      ),
      ),
        if(widget.start==true)
            Align(
      alignment: Alignment.topCenter,
      child:RaisedButton(
                color: Colors.deepOrange[400],
                child: Text(
                  'CLICK to START',
                  style: TextStyle(color: Colors.blue[50],fontSize: 20.0),
                ),
                onPressed: () async {
                  await dat.DatabaseService(uid:widget.user.uid).updateData(widget.email,'yes');
                  Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Geolocation(email:widget.email)),
                  );
                  }
      ),
      ),

      if(widget.start==true)
      Align(
      alignment: Alignment.topCenter,
      child:RaisedButton(
                color: Colors.deepPurple[400],
                child: Text(
                  'CLICK to say NO',
                  style: TextStyle(color: Colors.blue[50],fontSize: 20.0),
                ),
                onPressed: () async {
                   await dat.DatabaseService(uid:widget.user.uid).updateData(widget.email,'no');
                  return null;
                  /*Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Geolocation(dest: destination)),
                  );*/
                  }
      ),
      ),
         ]
       )
       
     );
   }
 }
 
