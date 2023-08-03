//import 'dart:html';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:location/location.dart' as loc;


//import 'package:flutter/services.dart';
import 'package:flutter_mapbox_navigation/flutter_mapbox_navigation.dart';
import 'package:assassinatordetectorapp/shared/message_add.dart';



class Geolocation extends StatefulWidget {
  final email;
  Geolocation({
      this.email,
      Key key,
  }):super(key:key);
  @override
  _GeolocationState createState() => _GeolocationState();
}

class _GeolocationState extends State<Geolocation> {
  //String _platformVersion = 'Unknown';
  static Location _origin;  
  static Location _destination;
  //final _origin = Location(name: "City Hall", latitude: 42.886448, longitude: -78.878372);
  /*final _destination = Location(
      //name: "Chennai", latitude: 13.067439, longitude: 80.237617);
      //name: "Downtown Buffalo", latitude: 42.8866177, longitude: -78.8814924);
      //name: "Downtown Buffalo", latitude: 38.8866177, longitude: -123.8814924);
      name: "Garcia Ave", latitude: 37.4260647, longitude:-122.096491);
*/
  MapboxNavigation _directions;
  bool _arrived = false;
  double _distanceRemaining, _durationRemaining;

  @override
  void initState() {
    getLocation();
    super.initState();
    initPlatformState();
     DatabaseReference dbRef= FirebaseDatabase.instance.reference().child("iot-project-b5131/Crime");
    dbRef.orderByChild("Index").once().then((DataSnapshot snap){
      var keys =snap.value.keys;
       var dat =snap.value;
   
      _destination= new Location (name:"Destination",latitude:dat[keys.first]['Lat'],longitude:dat[keys.first]['Long']);
  });
  }

  getLocation() async {

    var location = new loc.Location();
    
    location.onLocationChanged().listen((  currentLocation) {

      print(currentLocation.latitude);
      print(currentLocation.longitude);
      setState(() {
        _origin =  new Location(name:"Origin",latitude: currentLocation.latitude, longitude:currentLocation.longitude);
       });
    });

  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    _directions = MapboxNavigation(onRouteProgress: (arrived) async {
      _distanceRemaining = await _directions.distanceRemaining;
      _durationRemaining = await _directions.durationRemaining;

      setState(() {
        _arrived = arrived;
      });
      if (arrived)
        {
          await Future.delayed(Duration(seconds: 3));
          await _directions.finishNavigation();
        }
    });
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lime[200],
        appBar: AppBar(
          title: const Text('Ready to Navigate to crime spot',
          style:TextStyle(fontSize:20.0,color:Colors.amber,fontFamily: "Times New Roman"),),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Text("It is great that you are ready to investigate the crime",
            style: TextStyle(color: Colors.pinkAccent[400],fontSize: 29,fontFamily: "Times new Roman"),
            textAlign: TextAlign.center),
            SizedBox(height:35),
            Text("If you haven't reached the crime spot use the navigation button below",
            style: TextStyle(color: Colors.lightBlueAccent[150],fontSize: 22,
            fontStyle: FontStyle.italic,fontFamily: "Times new Roman" ),
            textAlign: TextAlign.left,),
            SizedBox(height:10),
                RaisedButton(
               color: Colors.green[400],
              child: Row(
                 mainAxisSize: MainAxisSize.min,
                 mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Start Navigation",style: TextStyle(color: Colors.white,fontSize: 30),),
                  Icon(Icons.not_listed_location,size:30.0, color: Colors.white),
                ],
                ),
              onPressed: () async {
                await _directions.startNavigation(
                    origin: _origin,
                    destination: _destination,
                    mode: NavigationMode.drivingWithTraffic,
                    simulateRoute: true, language: "English", units: VoiceUnits.metric);
              },
            ),
            SizedBox(height:45),
            Text(
              "Want to provide any information about the crime to everyone?", 
              style: TextStyle(color: Colors.teal[600],fontSize: 27,
              /*fontFamily: "Times new Roman"*/),
              textAlign: TextAlign.left
            ),
            SizedBox(height:10),
            Text(
            "Feel free use the instant message facility below.",
            style: TextStyle(color: Colors.blueAccent[400],fontSize: 23,fontStyle: FontStyle.italic),
            textAlign: TextAlign.center
            ),
            SizedBox(
              height: 10,
            ),
            MsgAdd(emailvalue:widget.email),
          ]
          ),

        ),
      );
  }
}
