import 'package:assassinatordetectorapp/models/user.dart';
import 'package:assassinatordetectorapp/userList.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService{
  final String uid;
  DatabaseService({this.uid});
  final CollectionReference users=Firestore.instance.collection("usersjoined");

  Future updateData(String email, String joined) async{
    return await users.document(uid).setData(
      {
        'email': email,
        'joined': joined,
      }
    );
  }

List<UserListelement> _listfromsnap(QuerySnapshot snap){
  return snap.documents.map((doc){
    return  UserListelement(
      email:doc.data['email'],
      joined: doc.data['joined']);

  }).toList();
}
  
Stream<List<UserListelement>>get usersjoined{
  return users.snapshots().
  map(_listfromsnap);
}

}
