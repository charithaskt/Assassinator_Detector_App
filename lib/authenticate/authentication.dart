import 'package:assassinatordetectorapp/authenticate/gmail.dart';
import 'package:assassinatordetectorapp/authenticate/register.dart';
//import 'package:assassinatordetectorapp/authenticate/sign_in.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget{
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate>{
   bool showSignIn = true;
   bool ds = true;

  void toggleView(){
    //print(showSignIn.toString());
    setState(() => showSignIn = !showSignIn);
  }

  @override
  Widget build(BuildContext context) {
   /* if(ds){
      ds=false;
    return Container(
      child: SignIn(),
    );
    }*/
    if (showSignIn) {
      return Gmail(toggleView:  toggleView);
    } else {
      return Register(toggleView:  toggleView);
    }
    
  }
  }
