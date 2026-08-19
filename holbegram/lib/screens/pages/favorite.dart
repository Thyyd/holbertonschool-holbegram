import 'package:cloud_firestore/cloud_firestore.dart'; // Utilisé dans la version 2
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:holbegram/models/post.dart'; // Utilisé dans la version 2
import 'package:holbegram/providers/user_provider.dart';
// ignore: unused_import
import 'package:holbegram/utils/posts.dart'; // Utilisé dans la version 1

class Favorite extends StatelessWidget {
  const Favorite({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = context.watch<UserProvider>().user;
    final savedIds = List<String>.from(currentUser.saved);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Favorites',
          style: TextStyle(
            fontFamily: 'Billabong',
            fontSize: 44,
          ),
        ),
        centerTitle: false,
        elevation: 0,
      ),
      body: savedIds.isEmpty
        ? Center(child: Text('No favorites yet'))
        // ----- Version affichant le post complet (username, caption, boutons) -----
        // : Posts(postIds: savedIds),

        // ----- Version avec l'image seule, façon "Saved" Instagram -----
        : StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('posts')
              .where('postId', whereIn: savedIds)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error ${snapshot.error}'));
            }
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            var data = snapshot.data!.docs;

            return ListView.separated(
              itemCount: data.length,
              separatorBuilder: (context, index) => SizedBox(height: 12),
              itemBuilder: (context, index) {
                Post post = Post.fromSnap(data[index]);

                return AspectRatio(
                  aspectRatio: 1,
                  child: Image.network(
                    post.postUrl,
                    fit: BoxFit.cover,
                  ),
                );
              },
            );
          },
        ),
    );
  }
}