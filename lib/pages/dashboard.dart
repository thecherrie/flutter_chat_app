import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterchatapp/global.dart';
import 'package:flutterchatapp/models/user.dart';
import 'package:flutterchatapp/utils.dart';

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

  @override
  Widget build(BuildContext context) {
    print('user.username: ---> ${user.username}');
    return Scaffold(
      body: Column(
        children: <Widget>[
          FutureBuilder(
            future: utils.getUsernameFromDocument(),
            builder: (context, snapshot) {
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text('my username is ${snapshot.data}'),
              );
            }
          ),
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
    );
  }
}
