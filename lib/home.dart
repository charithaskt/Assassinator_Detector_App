//import 'dart:html';
import 'dart:ui';

//import 'package:assassinatordetectorapp/services/geolocation.dart';
import 'package:assassinatordetectorapp/models/user.dart';
import 'package:assassinatordetectorapp/services/geolocation.dart';
import 'package:assassinatordetectorapp/services/get%20_image.dart';
import 'package:assassinatordetectorapp/services/get_weapon.dart';
import 'package:assassinatordetectorapp/services/gps_calculator.dart';
import 'package:assassinatordetectorapp/services/playvideo.dart';
import 'package:assassinatordetectorapp/shared/adddetails.dart';
import 'package:assassinatordetectorapp/shared/alertorno.dart';
import 'package:assassinatordetectorapp/shared/criminalhis.dart';
import 'package:assassinatordetectorapp/shared/join.dart';
import 'package:assassinatordetectorapp/shared/message_add.dart';
import 'package:assassinatordetectorapp/shared/message_show.dart';
import 'package:assassinatordetectorapp/shared/start.dart';
import 'package:assassinatordetectorapp/userList.dart';
import 'package:flutter/material.dart';
import 'package:assassinatordetectorapp/services/auth.dart';
import 'package:assassinatordetectorapp/shared/blinkingtext.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:io';
import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'as map;
import 'package:video_player/video_player.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:assassinatordetectorapp/services/datbase.dart' as dat;
//import 'package:latlong/latlong.dart' as map;

class Home extends StatelessWidget {

  final AuthService _auth = AuthService();
  final String email;
  Home({
    this.email,
    Key key
  }):super(key:key);
  // This widget is the root of your application.
  @override 
  Widget build(BuildContext context) {
    return Container(
       child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Crime Detector', style: TextStyle(fontSize:30.0,color:Colors.blue[900] ),),
          backgroundColor: Colors.red[200],
          elevation: 0.0,
          actions: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.person),
              label: Text('logout'),
              onPressed: () async {
               await _auth.signOut();
              },
            ),
          ],
        ),
        body: MessageHandler(email:email),
      ),
    );
  }
}


class MessageHandler extends StatefulWidget {
  final String email;
  MessageHandler({
    this.email,
    Key key
  }):super(key:key);
  @override
  _MessageHandlerState createState() => _MessageHandlerState();
}

class _MessageHandlerState extends State<MessageHandler> {
  //final Firestore _db = Firestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging();
  FlutterLocalNotificationsPlugin localnotification =FlutterLocalNotificationsPlugin();
  bool img=false;
  bool alertcheck =true;
  bool startcheck =true;
  bool joincheck=true;
  bool criminalhis=false;
  bool msgs=false;
  bool addD=false;
  bool msgsadd=true;
  //45.521563, -122.677433
  static var _gpsLat=45.521563;
  static var  _gpsLng=-122.677433;
  String _gps='Latitude: '+_gpsLat.toString()+' , Longitude: '+_gpsLng.toString();
  map.LatLng destination=map.LatLng(_gpsLat,_gpsLng);
  String textValue ='';

  //
  //messaging pop up 
  //

    @override
    void initState(){
      super.initState();

      var android = AndroidInitializationSettings('mipmap/ic_launcher');
      var ios= IOSInitializationSettings();
      var platform =InitializationSettings(android,ios);
      localnotification.initialize(platform);
      
      _fcm.configure(
        onLaunch: (Map <String, dynamic> message) async{
          print("onLaunch: $message");
        
        },
        onMessage: (Map<String, dynamic> message) async {
            print("onMessage: $message");
            /*showDialog(
                context: context,
                builder: (context) => AlertDialog(
                        content: ListTile(
                        title: Text(message['notification']['title']),
                        subtitle: Text(message['notification']['body']),
                        ),
                        actions: <Widget>[
                        FlatButton(
                            child: Text('Ok'),
                            onPressed: () => Navigator.of(context).pop(),
                        ),
                    ],
                ),
            );*/
            showNotification(message);
        },

      onResume: (Map<String, dynamic> message) async{
            print("onResume: $message");
            showNotification(message);
        },
      );
      _fcm.getToken().then((token){
        update(token);
      });
    }
    update(String token){
     print("token = ");
     print(token);
     DatabaseReference dbRef =FirebaseDatabase().reference();
     dbRef.child("fcm-token/$token").set({"token":token});
      textValue =token;
      setState(() {
        
      });
    }
    showNotification(Map<String,dynamic> mesage) async{
      setState(() {
        alertcheck=true;
        startcheck=true;
        joincheck=true;
      });
      
      var android = AndroidNotificationDetails('channel_id', 'channelName', 'channelDescription');
      var ios= IOSNotificationDetails();
      var platform =NotificationDetails(android, ios);
      await localnotification.show(0,"Crime Finder"," detected crime",platform);
    }
    /*@override
    void initState() {
     super.initState();

        _fcm.getToken().then((token){
          print("token=");
          print(token);
        }
        );
       _fcm.configure(
          onMessage: (Map<String, dynamic> message) async {
            print("onMessage: $message");
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                        content: ListTile(
                        title: Text(message['notification']['title']),
                        subtitle: Text(message['notification']['body']),
                        ),
                        actions: <Widget>[
                        FlatButton(
                            child: Text('Ok'),
                            onPressed: () => Navigator.of(context).pop(),
                        ),
                    ],
                ),
            );
        },
        onLaunch: (Map<String, dynamic> message) async {
            print("onLaunch: $message");
            // TODO optional
        },
        onResume: (Map<String, dynamic> message) async {
            print("onResume: $message");
            // TODO optional
        },
      );
    }*/

    @override
    Widget build(BuildContext context) {
    final user= Provider.of<User>(context);
    return  LayoutBuilder(
    builder: (BuildContext context, BoxConstraints viewportConstraints) {
      return SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: viewportConstraints.maxHeight,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            //
            // ALErT
            //
            AlertorNo(val:alertcheck),
           /* Align(
      alignment: Alignment.topCenter,
      child:BlinkingTextAnimation(),),
          */
      //
      //Crime image
      //
          SizedBox(height: 20.0),  
          Text(
            'Crime scene image',
            style: TextStyle(color: Colors.red[900],fontSize: 25),
            //textAlign:TextAlign.left,
          ),
          SizedBox(height: 5.0),
          //LoadFirbaseStorageImage(),
          Container(
        child: AspectRatio(
          aspectRatio: 6/ 9,
          //child:  Image.network(
          //'gs://iot-project-b5131.appspot.com/fear.jpg',
          ////'https://drive.google.com/file/d/1eb8ZYHekNen_QYDonZh78U3Ka-251xIL/view',
          //'https://thenypost.files.wordpress.com/2018/12/crime-scene-1.jpg?',
         //height: 200.0,
          //width: 2000.0,
          child: Image.asset( "lib/images/i2.jpeg",
     /* loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent loadingProgress) {
        if (loadingProgress == null)
          return child;
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes
                : null,
          ),
        );
      },*/
            fit: BoxFit.fill, // use this
          ),
        ),
      ),
      
          //
          //weapons 
          //
          SizedBox(height: 20.0),
      Text('Weapons',style: TextStyle(color: Colors.pinkAccent[200],fontSize: 25),),
      SizedBox(height: 5.0),
          //
          // weapons value from firebase 
          //
          Weapon(),
         /* Text(
            weapon_name,
            style: TextStyle(color: Colors.red[400],fontSize: 20),
            ),*/
         
        
         //
          //GPS location
          //
         SizedBox(height: 20.0),
          Align(
      alignment: Alignment.topCenter,
      child: Container(
        child: Text(
          'GPS Location',
            style: TextStyle(color: Colors.teal[400],fontSize: 25),
            textAlign:TextAlign.left,
        ),
      ),
      ),
       SizedBox(height: 5.0 ),  
       
       //
       //GPS VALUE
       //
        GPSfind(),
     /*     Align(
      alignment: Alignment.topCenter,
      child: Container(
        child: Text(
          '$_gps',
            style: TextStyle(color: Colors.lightBlueAccent[200],fontSize: 20),
            textAlign:TextAlign.left,
        ),
      ),
      ),*/
    
      //
      //GeolocationMAPS
      //
     /*Container(
        padding: const EdgeInsets.all(13.4),
        alignment: Alignment.topCenter,
        child: MapSample(destination: destination),
          ),*/
      /*FractionallySizedBox(
      widthFactor: 0.7,
      heightFactor: 0.3,
      child: Container(
     child: MapSample(destination: dest),
     ),
    ),*/
      //
      //video heading
      //
      SizedBox(height: 20.0),
      Text('Crime Video',style: TextStyle(color: Colors.teal[400],fontSize: 25),),
      SizedBox(height: 5.0),

      //
      //video display
      //
      VideosPlayer(
        vpcontroller: VideoPlayerController
        .asset('lib/videos/test.mp4'),
        //.network("gs://iot-project-b5131.appspot.com/video1.mp4"),
        //.network('http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4'),
        //.network("https://drive.google.com/file/d/1k52Y0qhxjGomyxJY7mF5kWUZFiVD3oGP/view"),
        looping: true,
      ),
    SizedBox(height: 35.0),
      //
      //start button
      //info added to firebase;  
      //
      Start(user:user,email:widget.email,start:startcheck),


      //
      // meassage data to add 
      //
      //MsgAdd(emailvalue:widget.email),
      //
      //message data to see
      //
      SizedBox(height: 20.0),
      Align(
      alignment: Alignment.topCenter,
      child:Column(
      mainAxisSize: MainAxisSize.min,
      children: msgsadd
      ?<Widget>[ RaisedButton(
                color: Colors.teal[800],
                child: Text(
                  'CLICK to see/close information\nprovided by collegues',
                  style: TextStyle(color: Colors.white,fontSize: 23.0),
                  textAlign: TextAlign.center,
                  
                ),
                onPressed: () {
                  setState(()  {
                    if (msgs==false)
                    msgs=true;
                    else
                    if (msgs==true)
                    msgs=false;
                  }); 
                  
                  }
      ),
      ]
      :<Widget>[
        SizedBox(height:1.0),
      ]
      ),
      ),
      /* Align(
      alignment: Alignment.topCenter,
      child:msgs==true?*/
      Msg(check:msgs),
     /*:SizedBox(height: 2.0)
      ),*/
      
      //
      // criminal history heading
      //
      Align(
      alignment: Alignment.topCenter,
      child:msgsadd
      ?Column(
        children:[SizedBox(height: 20.0),
        ]
      )
      :Column(
        children:[SizedBox(height: 2.0),
        ]
      )
          ),

      Align(
      alignment: Alignment.topCenter,
      child:Column(
      mainAxisSize: MainAxisSize.min,
      children:<Widget>[ RaisedButton(
                color: Colors.purple[800],
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'CLICK to open/close Criminal History',
                  style: TextStyle(color: Colors.white,fontSize: 21.0),
                ),
                onPressed: () {
                  setState(()  {
                    if (criminalhis==false)
                    criminalhis=true;
                    else
                    if (criminalhis==true)
                    criminalhis=false;
                  }); 
                  
                  }
      ),
      ],
      ),
      ),
      //
      //criminal history
      //
    CriminalHis(val:criminalhis),
    //
    // additional criminal details
    //
    Align(
      alignment: Alignment.topCenter,
      child:msgsadd
  ?Column(
        children:[SizedBox(height: 20.0),
        ]
      )
      :Column(
        children:[SizedBox(height: 30.0),
        ]
      )
    ),
      Align(
      alignment: Alignment.topCenter,
      child:Column(
      mainAxisSize: MainAxisSize.min,
      children:<Widget>[ RaisedButton(
                color: Colors.black87,
                padding: const EdgeInsets.all(10.0),
                child:
                 Text(
                  'To add to criminal\'s history from\nyour case sheet and get instant help\nPlease CLICK ME ',
                  style: TextStyle(color: Colors.white,fontSize: 22.0),
                  textAlign: TextAlign.center,
                ),
                onPressed: () {
                  setState(()  {
                    if (addD==false)
                      addD=true;
                    else
                    if (addD==true)
                    addD=false;
                  }); 
                  
                  }
      ),
      ],
      ),
      ),

      Container(
      child:addD==true
      ?Column(
        children: <Widget>[
          Flexible(
            flex: 0,
            child:AddDetails(),
          ),
          ]
      )
      :SizedBox(height:2.0)
          ),
   // CriminalHis(val:criminalhis),


      //
      //list of already started heading
      //
      Align(
      alignment: Alignment.topCenter,
      child:msgsadd
  ?Column(
        children:[SizedBox(height: 20.0),
        ]
      )
      :Column(
        children:[SizedBox(height: 30.0),
        ]
      )
    ),
      Text('Mail address of already started policemen',
      style: TextStyle(color: Colors.blueAccent[400],fontSize: 27),
      textAlign: TextAlign.center,),
      SizedBox(height: 5.0),
      
      //
      //list of already started 
      //via firebase;
      //
       
       Join(join:joincheck),
    

      //
      //crime solve
      //
      Align(
      alignment: Alignment.topCenter,
      child:RaisedButton(
                color: Colors.green[400],
                child: Text(
                  'Click if the crime is solved',
                  style: TextStyle(color: Colors.white,fontSize: 22.0),
                ),
                onPressed: () {
                  setState(()  {
                    alertcheck=false;
                    joincheck =false;
                    startcheck=false;
                    msgsadd=false;
                   // await dat.DatabaseService(uid:user.uid).updateData(widget.email,'no');
                  }); 
                  
                  /*Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Geolocation(dest: destination)),
                  );*/
                  }
      ),
      ),

          ],
    ),
    ),
      );
    }
    );
  }
}