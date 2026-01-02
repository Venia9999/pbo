import 'package:flutter/material.dart';

class User {
  final String name;
  User({required this.name});
}

class UserProvider extends ChangeNotifier {
  User? _user;

  User? get user => _user;

  void login(String name) {
    _user = User(name: name);
    notifyListeners();
  }
}
