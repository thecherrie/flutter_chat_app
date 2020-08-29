import 'package:flutter/cupertino.dart';
import 'package:flutterchatapp/global.dart';
import 'package:flutterchatapp/utils.dart';

class User extends ChangeNotifier {

  Utils utils = Utils();

  String username;
  String email;
  //String email = loggedInUser.email;

  User({ this.username });

  void addUsername(String newUsername) {
    username = newUsername;
    notifyListeners();
  }

  void addEmail(String email) {
    this.email = email;
    notifyListeners();
  }

}