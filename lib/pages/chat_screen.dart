import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterchatapp/models/user.dart';
import 'package:flutterchatapp/utils.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatelessWidget {

  Firestore _firestore = Firestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  
  String nameOfChat;
  String messageText;

  final _controller = TextEditingController();

  Utils utils = Utils();

  ChatScreen({ this.nameOfChat });

  @override
  Widget build(BuildContext context) {

    String username = Provider.of<User>(context).username;

    return Container(
      height: 300.0,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(40.0), topRight: Radius.circular(40.0),),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                  nameOfChat,
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
            ),
            SizedBox(height: 20.0,),
            StreamBuilder(
              stream: _firestore.collection('chats').where('members', arrayContains: username).snapshots(),
              builder: (context, snapshot) {
                if(!snapshot.hasData) {
                  return null;
                } else {
                  final messagesWrapper = snapshot.data.documents;
                  List<ListTile> messageTileList = [];
                  for (var messageWrapper in messagesWrapper) {
                    var messages = messageWrapper.data['messages'];
                    for(var message in messages) {
                      final messageText = message['messageSender'];
                      final messageSender = message['messageText'];

                      final messageTile = ListTile(
                        leading: CircleAvatar(),
                        title: Text(messageText),
                        subtitle: Text(messageSender),
                      );

                      messageTileList.add(messageTile);
                    }
                  }

                  return Expanded(
                    child: ListView(
                      children: messageTileList,
                    ),
                  );
                }
              }
            ),
            TextField(
              keyboardType: TextInputType.multiline,
              controller: _controller,
              autofocus: true,
              decoration: InputDecoration(
                suffixIcon: MaterialButton(
                  child: Icon(Icons.send),
                  onPressed: () {
                    utils.addMessageToStream(
                        message: _controller.text,
                        sender: username,
                        chatName: nameOfChat);
                    _controller.clear();
                  },
                ),
                hintText: "Type your message here",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
