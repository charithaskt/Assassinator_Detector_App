import 'package:assassinatordetectorapp/shared/blinkingtext.dart';
import 'package:flutter/material.dart';

class AlertorNo extends StatefulWidget {
  final bool val;
  AlertorNo({
      this.val,
      Key key,
  }):super(key:key);
  @override
  _AlertorNoState createState() => _AlertorNoState();
}

class _AlertorNoState extends State<AlertorNo> {
  @override
  Widget build(BuildContext context) {
    return Container(
     child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
          children:widget.val
          ?<Widget> [

            BlinkingTextAnimation(text: "!! ALERT !!",colour:Colors.red[400]),
            
           ]
           :<Widget>[
            Text("Previous Solved Crime",
            style:TextStyle(color:Colors.green[500],fontSize:34.0,fontFamily:'Times New Roman' ),), 
           ]
            ),
            );
  }
}