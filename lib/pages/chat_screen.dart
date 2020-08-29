import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {

  String nameOfChat;

  ChatScreen({ this.nameOfChat });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(40.0)),
          color: Colors.white,
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(nameOfChat),
              TextField(
                
              ),
            ],
          ),
        ),
      ),
    );
  }
}
