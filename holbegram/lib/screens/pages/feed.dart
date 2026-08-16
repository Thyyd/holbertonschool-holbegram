import 'package:flutter/material.dart';
import 'package:holbegram/utils/posts.dart';

class Feed extends StatelessWidget {
  const Feed({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Text(
              'Holbegram',
              style: TextStyle(
                fontFamily: 'Billabong',
                fontSize: 32,
                color: Colors.black,
              ),
            ),
            SizedBox(width: 8),
            Image.asset(
              'assets/images/logo.webp',
              width: 40,
              height: 30,
            ),
          ],
        ),
        actions: [
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.add, color: Colors.black),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.chat_outlined, color: Colors.black),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
      body: Posts(),
    );

  }
}