import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:holbegram/methods/auth_methods.dart';
import 'package:holbegram/screens/auth/login_screen.dart';

class AddPicture extends StatefulWidget {
  final String email;
  final String password;
  final String username;

  const AddPicture ({
    super.key,
    required this.email,
    required this.password,
    required this.username,
  });

  @override
  State<AddPicture> createState() => _AddPictureState();
}

class _AddPictureState extends State<AddPicture> {
  Uint8List? _image;
  final ImagePicker _imagePicker = ImagePicker();
  final AuthMethode _authMethode = AuthMethode();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 28),
            Text(
              'Holbegram',
              style: TextStyle(
                fontFamily: 'Billabong',
                fontSize: 50
              ),
            ),
            Image.asset(
              'assets/images/logo.webp',
              width: 80,
              height: 60,
            ),
            SizedBox(height: 32),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Text(
                    'Hello, ${widget.username} Welcome to Holbegram.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      height: 1.1
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Choose an image from your gallery or take a new one.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14
                    ),
                  ),
                  SizedBox(height: 24),
                  CircleAvatar(
                    radius: 128,
                    backgroundColor: Colors.transparent,
                    backgroundImage: _image == null
                        ? const AssetImage('assets/images/User_Icon.png')
                        : MemoryImage(_image!) as ImageProvider,
                  ),
                  SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.image_outlined, color: Color.fromARGB(218, 226, 37, 24), size: 50),
                          onPressed: selectImageFromGallery,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.camera_alt_outlined, color: Color.fromARGB(218, 226, 37, 24), size: 50),
                          onPressed: selectImageFromCamera,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Color.fromARGB(218, 226, 37, 24)),
                      shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))),
                      padding: WidgetStateProperty.all(EdgeInsets.symmetric(horizontal: 20)),
                    ),
                    onPressed: () async {
                      String res = await _authMethode.signUpUser(
                        email: widget.email,
                        password: widget.password,
                        username: widget.username,
                        file: _image
                      );
                      _showSnackBar(res);

                      if (res == "success") {
                        await Future.delayed(Duration(seconds: 2));
                        if (!mounted) return;
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(
                              emailController: TextEditingController(),
                              passwordController: TextEditingController(),
                            ),
                          ),
                        );
                      }
                    },
                    child: Text(
                      'Next',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
