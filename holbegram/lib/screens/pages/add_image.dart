import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'package:holbegram/providers/user_provider.dart';
import 'package:holbegram/screens/pages/methods/post_storage.dart';
import 'package:holbegram/screens/home.dart';

class AddImage extends StatefulWidget {
  const AddImage({super.key});

  @override
  State<AddImage> createState() => _AddImageState();
}

class _AddImageState extends State<AddImage> {
  Uint8List? _image;
  final ImagePicker _imagePicker = ImagePicker();
  final PostStorage _postStorage = PostStorage();
  final TextEditingController _captionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<UserProvider>(context, listen: false).refreshUser();
  }

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  // Affiche un SnackBar avec le texte reçu en paramètre.
  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void selectImageFromGallery() async {
    XFile? pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      Uint8List bytes = await pickedFile.readAsBytes();
      setState(() {
        _image = bytes;
      });
    }
  }

  void selectImageFromCamera() async {
    XFile? pickedFile = await _imagePicker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      Uint8List bytes = await pickedFile.readAsBytes();
      setState(() {
        _image = bytes;
      });
    }
  }

  void _selectImage() async {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text('Créer un post'),
          children: [
            SimpleDialogOption(
              padding: EdgeInsets.all(20),
              child: Text('Prendre une photo'),
              onPressed: () {
                Navigator.of(context).pop();
                selectImageFromCamera();
              },
            ),
            SimpleDialogOption(
              padding: EdgeInsets.all(20),
              child: Text('Choisir depuis la galerie'),
              onPressed: () {
                Navigator.of(context).pop();
                selectImageFromGallery();
              },
            ),
          ],
        );
      },
    );
  }

  void _handlePost() async {
    if (_image == null) {
      _showSnackBar("There isn't any image in this post");
      return;
    }

    final user = Provider.of<UserProvider>(context, listen: false).user;

    // Appel à uploadPost avec les bons paramètres
    String res = await _postStorage.uploadPost(
      _captionController.text,
      user.uid,
      user.username,
      user.photoUrl,
      _image!,
    );

    if (res == "Ok") {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => Home()),
      );
    }
    else {
      _showSnackBar(res);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
            'Add Image',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        actions: [
          TextButton(
            onPressed: () {
              _handlePost();
            },
            child: Text(
              'Post',
              style: TextStyle(
                fontFamily: 'Billabong',
                fontSize: 32,
                color: Color.fromARGB(218, 226, 37, 24),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),

      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: 24),
            Text(
              'Add Image',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Choose an image from your gallery or take a one.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 24),
            TextField(
              controller: _captionController,
              decoration: InputDecoration(
                hintText: 'Write a caption...',
                hintStyle: TextStyle(
                  fontSize: 20,
                  color: Colors.grey[700],
                ),
                border: InputBorder.none,
              ),
            ),
            SizedBox(height: 64),
            GestureDetector(
              onTap: _selectImage,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _image == null
                    ? Center(
                        child: Image.asset(
                          'assets/images/Add-image-icon.png',
                          width: 200,
                          height: 200,
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.memory(
                          _image!,
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );

  }

}