import 'package:assassinatordetectorapp/services/auth.dart';
import 'package:assassinatordetectorapp/shared/spinner.dart';
import 'package:flutter/material.dart';
import 'package:assassinatordetectorapp/shared/constants.dart';

class  Gmail extends StatefulWidget {

   final Function toggleView;
  Gmail({ this.toggleView });
  @override
  _GmailState createState() => _GmailState();
}

class _GmailState extends State<Gmail> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading =false;
  // text field state
  String email = '';
  String password = '';
  String error='';
  @override
  Widget build(BuildContext context) {
    return loading? Loading() :Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        title: Text('Sign in to Crime Finder'),
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.person),
            label: Text('Register'),
            onPressed: () => widget.toggleView(),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20.0),
              TextFormField(
                decoration: textinputdecorator.copyWith(hintText: 'Email'),
                validator: (val) => val.isEmpty ? 'Enter your registered email':null,
                onChanged: (val) {
                  setState(() => email = val);
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                obscureText: true,
                decoration: textinputdecorator.copyWith(hintText: 'Password'),
              
                validator: (val) => val.length < 6 ? 'Enter atleast 6 characters':null,
                onChanged: (val) {
                  setState(() => password = val);
                },
              ),
              SizedBox(height: 20.0),
              RaisedButton(
                color: Colors.pink[400],
                child: Text(
                  'Sign In',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  if(_formKey.currentState.validate()){
                    setState(() => loading =true);
                    dynamic result = await _auth.signInWithEmailAndPassword(email, password);
                    if(result == null) {
                      setState(() {
                        error = 'Could not sign in with your credentials';
                        loading= false;
                      });
                  }
                  }
                }
              ),
              SizedBox(height: 12.0),
              Text(
                error,
                style: TextStyle(color: Colors.red, fontSize: 14.0),
              )
            ],
          ),
        ),
      ),
    );
  }
}
