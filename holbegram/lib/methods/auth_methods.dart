import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:http/http.dart' as http;

import 'package:holbegram/models/user.dart';
import 'package:holbegram/screens/auth/methods/user_storage.dart';

class AuthMethode {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final StorageMethods _storageMethods = StorageMethods();

  // URL de l'icône de profil par défaut, uploadée une seule fois manuellement sur Cloudinary (dossier Profile_Images)
  // pour éviter de la ré-uploader (et donc de créer des doublons) à chaque inscription sans photo choisie.
  static const String _defaultProfileImageUrl = 'https://res.cloudinary.com/jckazhb3/image/upload/v1787095046/User_Icon.png';


  Future<String> login({required String email, required String password}) async {
    String res = "";
    if (email.isEmpty || password.isEmpty) {
      return 'Please fill all the fields';
    }
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(), // Suppression des espaces avant le premier et après le dernier caractères avec trim()
        password: password
      );
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
      // Upload de l'image AVANT de créer le compte : si ça échoue, aucun compte orphelin n'est créé
      String photoUrl = file != null
        ? await _storageMethods.uploadImageToStorage(false, 'Profile_Images', file) // photoUrl prend l'image sélectionnée par l'user
        : _defaultProfileImageUrl; // Si aucune image choisie → on réutilise l'URL de l'icône par défaut à la place

      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;

      Users users = Users(
        uid: user!.uid,
        email: email,
        username: username,
        bio: '',
        photoUrl: photoUrl,
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

  Future<Users> getUserDetails() async {
    User currentUser = _auth.currentUser!; // Récupération de l'user actuel
    DocumentSnapshot snap = await _firestore.collection("users").doc(currentUser.uid).get(); // Récupération des données stockées de l'User stockées sur Firestore
    return Users.fromSnap(snap); // Renvoie une instance d'Users avec les données de l'user actuel
  }

}
