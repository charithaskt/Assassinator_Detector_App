import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    backgroundColor: Colors.white38,
      appBar: AppBar(
        backgroundColor: Colors.green[400],
        elevation: 0.0,
        title: Text('LOG into Crime Detector'),
      ),
      body: Container(
         //padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
      child: Center(
        child:SpinKitRotatingCircle(
            color: Colors.red,
              size: 50.0,
    ),
    ),
    ),
    );
  }
}