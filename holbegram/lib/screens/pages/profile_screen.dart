import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:holbegram/providers/user_provider.dart';
import 'package:holbegram/methods/auth_methods.dart';
import 'package:holbegram/screens/pages/methods/post_storage.dart';
import 'package:holbegram/screens/auth/login_screen.dart';
import 'package:holbegram/models/post.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  // Widget réutilisable au sein de Profile
  Widget _buildStatColumn(int count, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$count',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = context.watch<UserProvider>().user;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(
            fontFamily: 'Billabong',
            fontSize: 44,
          ),
        ),
        centerTitle: false,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await AuthMethode().logout();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen(
                    emailController: TextEditingController(),
                    passwordController: TextEditingController(),
                  )),
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Avatar circulaire
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(currentUser.photoUrl),
                    ),
                    const SizedBox(width: 12),
                    // Stats : posts / followers / following
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatColumn(currentUser.posts.length, 'posts'),
                          _buildStatColumn(currentUser.followers.length, 'followers'),
                          _buildStatColumn(currentUser.following.length, 'following'),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  currentUser.username,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
          ),

          // Grille de posts
          SizedBox(height: 32),
          Expanded(
            child: StreamBuilder(
              stream: PostStorage().getUserPosts(currentUser.uid),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error ${snapshot.error}'));
                }
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                var data = snapshot.data!.docs;

                if (data.isEmpty) {
                  return const Center(child: Text('No posts yet'));
                }

                return GridView.builder(
                  padding: EdgeInsets.zero,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 2,
                    mainAxisSpacing: 2,
                  ),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    Post post = Post.fromSnap(data[index]);
                    return Image.network(
                      post.postUrl,
                      fit: BoxFit.cover,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}