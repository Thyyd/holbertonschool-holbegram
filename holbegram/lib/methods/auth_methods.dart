import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:holbegram/models/user.dart';
//import 'package:http/http.dart' as http;
import 'dart:typed_data';

class AuthMethode {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> login({required String email, required String password}) async {
    String res = "";
    if (email.isEmpty || password.isEmpty) {
      return 'Please fill all the fields';
    }
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      res = "success";
    }
    catch (error) {
      res = "An error occured: $error";
    }

    return res;
  }

  Future<String> signUpUser({required String email, required String password, required String username, Uint8List? file,}) async {
    String res = '';
    if (email.isEmpty || password.isEmpty || username.isEmpty) {
      return 'Please fill all the fields';
    }
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      Users users = Users(
        uid: user!.uid,
        email: email,
        username: username,
        bio: '',
        photoUrl: '',
        followers: [],
        following: [],
        posts: [],
        saved: [],
        searchKey: username.toLowerCase()
      );
      await _firestore.collection("users").doc(user.uid).set(users.toJson());

      res = "success";
    }
    catch (error) {
      res = "An error occured: $error";
    }

    return res;
  }

}
