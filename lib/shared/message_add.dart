import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
// import 'package:firebase_core/firebase_core.dart'; not nessecary



class MsgAdd extends StatefulWidget {
  final emailvalue;
  MsgAdd({
      this.emailvalue,
      Key key,
  }):super(key:key);
  @override
  MsgAddState createState() => MsgAddState();
}

class MsgAddState extends State<MsgAdd> {
  List<Item> items = List();
  Item item;
  DatabaseReference itemRef;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    item = Item("", "",0);
    final FirebaseDatabase database = FirebaseDatabase.instance; //Rather then just writing FirebaseDatabase(), get the instance.  
    itemRef = database.reference().child("iot-project-b5131/Messages");
    itemRef.onChildAdded.listen(_onEntryAdded);
    itemRef.onChildChanged.listen(_onEntryChanged);
  }

  _onEntryAdded(Event event) {
    setState(() {
      items.add(Item.fromSnapshot(event.snapshot));
    });
  }

  _onEntryChanged(Event event) {
    var old = items.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });
    setState(() {
      items[items.indexOf(old)] = Item.fromSnapshot(event.snapshot);
    });
  }

  void handleSubmit() {
    final FormState form = formKey.currentState;

    if (form.validate()) {
      form.save();
      form.reset();
      itemRef.push().set(item.toJson());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child:Column(
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
                      leading: Icon(Icons.event_note),
                      title: TextFormField(
                        initialValue: "",
                        onSaved: (val) => item.msg = val,
                        validator: (val) => val == "" ? val : null,
                      ),
                    ),
                    Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                    Text("Send",
                    style: TextStyle(fontSize:25.0, color: Colors.deepPurple[900]),
                    textAlign: TextAlign.right,
                    ),
                    IconButton(
                      icon: Icon(Icons.send, color: Colors.deepPurple[900],),
                      onPressed: () {
                        item.emailval=widget.emailvalue;
                        item.timestamp=new DateTime.now().millisecondsSinceEpoch;
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

class Item {
  String key;
  String emailval;
  String msg;
  int timestamp;

  Item(this.emailval, this.msg,this.timestamp);

  Item.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        emailval = snapshot.value["email"],
        msg = snapshot.value["msg"],
        timestamp=snapshot.value["timestamp"];

  toJson() {
    return {
      "email": emailval,
      "msg": msg,
      "timestamp":timestamp,
    };
  }
}