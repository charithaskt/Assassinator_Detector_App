import 'package:assassinatordetectorapp/authenticate/authentication.dart';
import 'package:assassinatordetectorapp/models/user.dart';
import 'package:flutter/material.dart';
import 'package:assassinatordetectorapp/home.dart';
import 'package:provider/provider.dart';
class  Combiner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
      final user= Provider.of<User>(context);
      print("user");
      // retun either home or auth
      if (user==null){
        return Authenticate();
      }
      else{
        return Home(email: user.email);
      }
  }
}