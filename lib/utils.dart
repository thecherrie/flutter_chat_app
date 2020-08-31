import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterchatapp/global.dart';
import 'package:provider/provider.dart';

class Utils {

  Firestore _firestore = Firestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser user;

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if(user != null) {
        loggedInUser = user;
      }
    }catch(e){
      print(e);
    }
  }

  Future<String> getUsernameFromDocument(String email) async {
    print('(utils) GET USERNAME FROM DOC: $email');
    final query = await _firestore.collection('users')
        .where('email', isEqualTo: email)
        .getDocuments();
    final username = query.documents[0].data['username'];
    return username;
  }

  void addMessageToStream({String message, String sender, String chatName}) async {
    final query = await _firestore.collection('chats')
        .where('name', isEqualTo: chatName)
        .limit(1)
        .getDocuments();
    final docID = query.documents[0].documentID;
    Map messageStructure = ({
       'messageSender': sender,
       'messageText': message,
    });
    await _firestore.collection('chats').document(docID).updateData({
        'messages': FieldValue.arrayUnion([messageStructure])
    });
  }

}