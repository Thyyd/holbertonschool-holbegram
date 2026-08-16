import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:holbegram/models/post.dart';

class Posts extends StatefulWidget {
  const Posts({super.key});

  @override
  State<Posts> createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('posts').snapshots(),
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
                          IconButton(
                            icon: Icon(Icons.more_horiz),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Post Deleted')),
                              );
                            },
                          ),
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
                          icon: Icon(Icons.favorite_border),
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
                          icon: Icon(Icons.bookmark_border),
                          onPressed: () {},
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