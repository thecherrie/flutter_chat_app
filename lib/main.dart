import 'package:flutter/material.dart';
import 'package:flutterchatapp/models/user.dart';
import 'package:flutterchatapp/pages/chat_screen.dart';
import 'package:flutterchatapp/pages/dashboard.dart';
import 'package:flutterchatapp/pages/welcome_screen.dart';
import 'package:provider/provider.dart';

void main() => runApp(FlutterChat());

class FlutterChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (context) {
        return User();
      },
      child: MaterialApp(
        theme: ThemeData(
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            contentPadding:
            EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
          )
        ),
        initialRoute: WelcomeScreen.id,
        routes: {
          WelcomeScreen.id: (context) => WelcomeScreen(),
          Dashboard.id: (context) => Dashboard(),
          //ChatScreen.id: (context) => ChatScreen(),
        },
      ),
    );
  }
}
