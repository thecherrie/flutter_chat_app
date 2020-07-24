import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  static String id = 'welcome_screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

  Firestore _firestore = Firestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();

  String email;
  String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: "Email",
                ),
                onChanged: (value) {
                  email = value;
                },
                validator: (value) {
                  if(value.isEmpty){
                    return 'Enter an email address';
                  }else{
                    return null;
                  }
                }
              ),
              TextFormField(
                onChanged: (value) {
                  password = value;
                },
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Password",
                  focusColor: Colors.orange,
                ),
                validator: (value) {
                  if(value.isEmpty){
                    return 'Enter an password';
                  }else{
                    return null;
                  }
                }
              ),
              MaterialButton(
                color: Colors.orangeAccent,
                elevation: 0,
                hoverElevation: 0,
                highlightElevation: 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                  child: Text('Login',
                  style: TextStyle(
                    fontWeight: FontWeight.w400
                  ),),
                ),
                onPressed: () async {
                  if(_formKey.currentState.validate()) {
                    try{
                      await _auth.signInWithEmailAndPassword(email: email, password: password);
                    }catch(e){
                      print(e);
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}