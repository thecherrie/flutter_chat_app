import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterchatapp/global.dart';
import 'package:flutterchatapp/models/user.dart';
import 'package:flutterchatapp/pages/chat_screen.dart';
import 'package:flutterchatapp/pages/welcome_screen.dart';
import 'package:flutterchatapp/utils.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  static String id = "dashboard";

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  Firestore _firestore = Firestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  Utils utils = Utils();
  User user = User();

  @override
  void initState() {
    // TODO: implement initState
    utils.getCurrentUser();
    super.initState();
  }

  Widget customDialogue() {
    return Container(
      width: 300.0,
      height: 300.0,
      child: ListView(
        children: <Widget>[
          ListTile(
            title: Text("Logout"),
            leading: Icon(Icons.exit_to_app),
            onTap: () {
              _auth.signOut();
              Navigator.pushNamed(context, WelcomeScreen.id);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    String username = Provider.of<User>(context).username;

    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(40.0))
                    ),
                    elevation: 0,
                    content: customDialogue(),
                  );
                }
              );
            }
          ),
        ],
        title: Text('Welcome back, $username', style: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
        ),),
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black87,
      ),
      backgroundColor: Colors.black87,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {

        },
        backgroundColor: Colors.black87,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 50.0),
              child: Column(
                children: <Widget>[
                  StreamBuilder(
                      stream: _firestore.collection('chats').where('members', arrayContains: user.username).snapshots(),
                      builder: (context, snapshot) {
                        if(snapshot.data.documents.length == 0){
                          return CircularProgressIndicator();
                        }else{
                          List chatList = [];
                          return Text(snapshot.data.documents[0]['members'].toString());
                        }
                      }
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(40.0), topRight: Radius.circular(40.0)),
                color: Colors.white,
              ),
              width: double.infinity,
              height: 200.0,
              child: StreamBuilder(
                stream: _firestore.collection('chats').where('members', arrayContains: username).snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Text("Nothing to see here!");
                  } else {

                    String chatName;

                    final chats = snapshot.data.documents;

                    List<ListTile> chatListTiles = [];

                    for (var chat in chats) {
                      chatName = chat.data['name'];
                      final chatMembers = chat.data['members'];

                      final chatListTile = ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage("https://i.pinimg.com/600x315/80/63/35/8063359effd01b990e653bb32a83485d.jpg"),
                        ),
                        title: Text(chatName),
                        subtitle: Text(chatMembers.toString()),
                        onTap: () {
                          showBarModalBottomSheet(
                              context: context,
                              builder: (context, scrollController) => ChatScreen(nameOfChat: chatName,));
                          /*showModalBottomSheet(
                            context: context,
                            builder: (context) => SingleChildScrollView(
                              child: Container(
                                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                child: Container(
                                  color: Colors.black54,
                                  child: ChatScreen(nameOfChat: chatName,
                                  ),
                                ),
                              ),
                            ),
                          );*/
                        },
                      );

                      chatListTiles.add(chatListTile);
                    }

                    return ListView(
                      children: chatListTiles,
                    );
                  }
                }
              )
            ),
          ),
        ],
      ),
    );
  }
}
