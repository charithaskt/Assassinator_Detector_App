import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'criminalhis.dart';
// import 'package:firebase_core/firebase_core.dart'; not nessecary



class AddDetails extends StatefulWidget {
  /*final emailvalue;
  AddDetails({
      this.emailvalue,
      Key key,
  }):super(key:key);*/
  @override
  AddDetailsState createState() => AddDetailsState();
}

class AddDetailsState extends State<AddDetails> {
  List<CriminalAdd> items = List();
  CriminalAdd item;
  DatabaseReference itemRef;
  List<Criminal> criminals=List();
  String currentName="";

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    item = CriminalAdd();
    FirebaseDatabase database = FirebaseDatabase.instance; //Rather then just writing FirebaseDatabase(), get the instance.  
    itemRef = database.reference().child("iot-project-b5131/CriminalAdd");
    itemRef.onChildAdded.listen(_onEntryAdded);
    itemRef.onChildChanged.listen(_onEntryChanged);
  }

  _onEntryAdded(Event event) {
    setState(() {
      items.add(CriminalAdd.fromSnapshot(event.snapshot));
    });
  }

  _onEntryChanged(Event event) {
    var old = items.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });
    setState(() {
      items[items.indexOf(old)] = CriminalAdd.fromSnapshot(event.snapshot);
    });
  }

  void handleSubmit() {
    FormState form = formKey.currentState;

    if (form.validate()) {
      form.save();
      form.reset();
      itemRef.push().set(item.toJson());
    }
  }

  @override
  Widget build(BuildContext context) {
    DatabaseReference dbRef= FirebaseDatabase.instance.reference().child("iot-project-b5131/CriminalHistory");
                        dbRef.orderByChild("index").once().then((DataSnapshot snapshot){
                        var dat=snapshot.value;
                        criminals.clear();
                        dat.forEach((key,value){
                          Criminal crime =new Criminal(
                            details: value["details"],
                            name: value["name"],
                            index:value["index"]);
                            criminals.add(crime); 
                        });
                        criminals.sort((a,b)=>a.index.compareTo(b.index));
                        currentName=criminals[criminals.length-1].name.toString();
                        } );
    return Container(
      child: currentName.contains("Not in Db")
      ?Column(
      children:[
        Text("Sorry",
      style:TextStyle(color:Colors.green[800], fontSize:25.0 ),
      textAlign: TextAlign.center,),
        Text("You cannot add details as this person is not in dB",
      style:TextStyle(color:Colors.blueGrey[500], fontSize:20.0 ),
      textAlign: TextAlign.center,),
      ],
      )
      :Column(
        children: <Widget>[
          Flexible(
            flex: 0,
            child: Center(
              child: Form(
                key: formKey,
                child: Flex(
                  direction: Axis.vertical,
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.create),
                      title: TextFormField(
                        initialValue: "",
                        onSaved: (val) => item.details = val,
                        validator: (val) => val == "" ? val : null,
                      ),
                    ),
                    Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                    Text("Add",
                    style: TextStyle(fontSize:25.0),
                    textAlign: TextAlign.right,
                    ),
                    IconButton(
                      icon: Icon(Icons.label_important),
                      onPressed: () {
                        item.name=currentName.toString();
                        handleSubmit();
                      },
                    ),
                ]
                    ),
                  ],
                ),
              ),
            ),
          ),
          /*Flexible(
            child: FirebaseAnimatedList(
              query: itemRef,
              itemBuilder: (BuildContext context, DataSnapshot snapshot,
                  Animation<double> animation, int index) {
                return new ListTile(
                  title: Text(items[index].emailval),
                  subtitle: Text(items[index].msg),
                );
              },
            ),
          ),*/
        ],
      ),
    );
  }
}

class CriminalAdd{
  String name,details;
  String key;
  CriminalAdd({this.details,this.name});
  CriminalAdd.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        name = snapshot.value["name"],
        details = snapshot.value["details"];

  toJson() {
    return {
      "name": name,
      "details": details,
    };
  }
}