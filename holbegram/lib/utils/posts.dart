import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'package:holbegram/models/post.dart';
import 'package:holbegram/screens/pages/methods/post_storage.dart';
import 'package:holbegram/providers/user_provider.dart';

class Posts extends StatefulWidget {
  final List<String>? postIds; // null = tous les posts

  const Posts({super.key, this.postIds});

  @override
  State<Posts> createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  final String uid = FirebaseAuth.instance.currentUser!.uid;

  // Affiche un SnackBar avec le texte reçu en paramètre.
  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: (widget.postIds == null || widget.postIds!.isEmpty)
        ? FirebaseFirestore.instance.collection('posts').snapshots()
        : FirebaseFirestore.instance
            .collection('posts')
            .where('postId', whereIn: widget.postIds)
            .snapshots(),

      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error ${snapshot.error}'));
        }

        // Tant que Firestore n'a pas encore renvoyé sa première réponse : affiche un loader.
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        var data = snapshot.data!.docs;

        return ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            Post post = Post.fromSnap(data[index]);
            final currentUser = context.watch<UserProvider>().user;
            bool isSaved = currentUser.saved.contains(post.postId);

            return SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.all(8),
                height: 540,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Column(
                  children: [
                    // Ligne du haut : photo de profil + username + menu "..."
                    Container(
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: NetworkImage(post.profImage),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Text(post.username),
                          Spacer(), // Créé l'espace entre l'username et l'élément situé sur la même ligne ("...")
                          post.uid == uid
                            ? IconButton(
                                icon: Icon(Icons.more_horiz),
                                onPressed: () async {
                                  try {
                                    await PostStorage().deletePost(post.postId, post.publicId, post.uid);
                                    _showSnackBar("Post Deleted");
                                  } catch (error) {
                                    _showSnackBar("An error occurred: $error");
                                  }
                                },
                              )
                              : const SizedBox.shrink(), // N'affiche pas l'icône si ce n'est pas le post de l'user connecté.
                        ],
                      ),
                    ),

                    // Légende
                    SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          post.caption,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),

                    SizedBox(height: 10),

                    // Image du post
                    Container(
                      width: 350,
                      height: 350,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        image: DecorationImage(
                          image: NetworkImage(post.postUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    // Rangée d'icônes : like, commentaire, envoyer, favori
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.favorite_outline),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: Icon(Icons.chat_bubble_outline),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: Icon(Icons.send),
                          onPressed: () {},
                        ),
                        Spacer(), // Pour "pousser" le dernier icône à droite, pour respecter le layout.


                        IconButton(
                          icon: Icon(isSaved ? Icons.bookmark : Icons.bookmark_border),
                          onPressed: () async {
                            try {
                              await PostStorage().toggleSave(post.postId, currentUser.uid, currentUser.saved);
                              if (!mounted) return;
                              await Provider.of<UserProvider>(context, listen: false).refreshUser();
                            } catch (error) {
                              _showSnackBar("An error occurred: $error");
                            }
                          },
                        ),
                      ],
                    ),

                    // Compteur de likes
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text('${post.likes.length} Liked'),
                      ),
                    ),

                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}