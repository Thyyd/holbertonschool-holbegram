import 'package:flutter/material.dart';
import 'package:holbegram/models/user.dart';
import 'package:holbegram/methods/auth_methods.dart';

class UserProvider with ChangeNotifier {
  late Users _user;
  final AuthMethode _authMethode = AuthMethode();

  // getter user
  Users get user => _user;

  Future<void> refreshUser() async {
    Users user = await _authMethode.getUserDetails();
    _user = user;
    notifyListeners();
  }
}
