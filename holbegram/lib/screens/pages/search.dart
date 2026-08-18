import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:holbegram/screens/pages/methods/post_storage.dart';
import 'package:holbegram/models/post.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Barre de recherche
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.toLowerCase();
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            // Grille en mosaïque des images
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: PostStorage().getAllPosts(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  // On convertit tous les docs en objets Post
                  List<Post> posts = snapshot.data!.docs
                      .map((doc) => Post.fromSnap(doc))
                      .toList();

                  // Filtrage sur le username ou la caption
                  if (_searchQuery.isNotEmpty) {
                    posts = posts.where((post) {
                      return post.username.toLowerCase().contains(_searchQuery) ||
                          post.caption.toLowerCase().contains(_searchQuery);
                    }).toList();
                  }

                  if (posts.isEmpty) {
                    return const Center(child: Text('Aucun résultat'));
                  }

                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: StaggeredGrid.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        children: List.generate(posts.length, (index) {
                          Post post = posts[index];

                          // 1 image sur 3 prend toute la largeur
                          bool isWide = index % 3 == 0;

                          return StaggeredGridTile.count(
                            crossAxisCellCount: isWide ? 2 : 1,
                            mainAxisCellCount: isWide ? 1.5 : 1.2,
                            child: Image.network(
                              post.postUrl,
                              fit: BoxFit.cover,
                            ),
                          );
                        }),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}