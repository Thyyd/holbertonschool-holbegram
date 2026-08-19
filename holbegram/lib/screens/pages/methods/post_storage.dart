import 'dart:typed_data';

import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

import 'package:holbegram/models/post.dart';
import 'package:holbegram/screens/auth/methods/user_storage.dart';

class PostStorage {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final StorageMethods _storageMethods = StorageMethods();

  Future<String> uploadPost(String caption, String uid, String username, String profImage, Uint8List image,) async {
    String res = "";
    try {
      String publicId = const Uuid().v1();

      String postUrl = await _storageMethods.uploadImageToStorage(true, 'Post_Images', image, publicId: publicId);

      // Création d'un ID unique pour un post
      String postId = const Uuid().v1();

      // Génération de l'objet Post
      Post post = Post(
        caption: caption,
        uid: uid,
        username: username,
        likes: [],
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: postUrl,
        profImage: profImage,
        publicId: publicId
      );

      // Création des références des documents
      final userRef = _firestore.collection('users').doc(uid);
      final postRef = _firestore.collection("posts").doc(postId);

      // Création d'un batch, un lot d'opération
      WriteBatch batch = _firestore.batch();
      // Ajout des opérations au lot d'opération
      batch.set(postRef, post.toJson());
      batch.update(userRef, {
        'posts': FieldValue.arrayUnion([postId]),
      });

      // Envoie du lot d'opération, faisant ainsi les 2 opérations ensembles.
      await batch.commit();

      res = "Ok";
    }
    catch (error) {
      res = "An error occured: $error";
    }
    return res;
  }

  Future<void> deletePost(String postId, String publicId, String uid) async {
    // Création des références des documents
    final postRef = _firestore.collection('posts').doc(postId);
    final userRef = _firestore.collection('users').doc(uid);

    // Création d'un batch, un lot d'opération
    WriteBatch batch = _firestore.batch();
    // Ajout des opérations au lot d'opération
    batch.delete(postRef);
    batch.update(userRef, {
      'posts': FieldValue.arrayRemove([postId]),
    });

    // Envoi du lot d'opération, faisant ainsi les 2 opérations ensemble.
    await batch.commit();

    // Suppression de l'image Cloudinary (best effort, ne bloque pas la fonction)
    try {
      final uri = Uri.parse(
      _storageMethods.cloudinaryUrl.replaceFirst('/upload', '/destroy'),
      );

      await http.post(uri, body: {
        'public_id': publicId,
        'upload_preset': _storageMethods.cloudinaryPreset,
      });
    } catch (error) {
      // Erreur silencieuse : on ne bloque pas la suppression du post
    }
  }

  // Méthode pour récupérer tous les posts triés du plus récent au moins récent.
  Stream<QuerySnapshot> getAllPosts() {
    return _firestore
      .collection("posts")
      .orderBy("datePublished", descending: true)
      .snapshots();
  }

  Future<void> toggleSave(String postId, String uid, List saved) async {
    final userRef = FirebaseFirestore.instance.collection('users').doc(uid);

    if (saved.contains(postId)) {
      // Le post est déjà sauvegardé → on le retire
      await userRef.update({
        'saved': FieldValue.arrayRemove([postId]), // Retire l'élément sans avoir à récupérer la liste complète et la renvoyer entière.
      });
    }
    else {
      // Le post n'est pas encore sauvegardé → on l'ajoute
      await userRef.update({
        'saved': FieldValue.arrayUnion([postId]), // Ajoute l'élément sans avoir à récupérer la liste complète et la renvoyer entière.
      });
    }
  }

  // Méthode pour récupérer tous les posts de l'user connecté, triés du plus récent au moins récent.
  Stream<QuerySnapshot> getUserPosts(String uid) {
    return _firestore
      .collection("posts")
      .where('uid', isEqualTo: uid)
      .orderBy("datePublished", descending: true)
      .snapshots();
  }
}
