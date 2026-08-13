import 'package:flutter/material.dart';
import 'package:holbegram/widgets/text_field.dart';
import 'package:holbegram/screens/login_screen.dart';
import 'package:holbegram/methods/auth_methods.dart';

class SignUp extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final TextEditingController passwordConfirmController;
  final bool _passwordVisible;
  final bool _passwordConfirmVisible;


  const SignUp ({
    super.key,
    required this.emailController,
    required this.usernameController,
    required this.passwordController,
    required this.passwordConfirmController,
    this._passwordVisible = true,
    this._passwordConfirmVisible = true
  });

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  late bool _passwordVisible; // utilisation de late pour dire qu'elle sera initialisée plus tard avec une valeur non nulle
  late bool _passwordConfirmVisible;
  final AuthMethode _authMethode = AuthMethode();

  // Affiche un SnackBar avec le texte reçu en paramètre.
  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void initState() {
    super.initState();
    _passwordVisible = widget._passwordVisible;
    _passwordConfirmVisible = widget._passwordConfirmVisible;
  }

  @override
  void dispose() {
    widget.emailController.dispose();
    widget.usernameController.dispose();
    widget.passwordController.dispose();
    widget.passwordConfirmController.dispose();
    super.dispose();
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
            Text(
              'Sign up to see photos and videos from your friends.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14
              ),
            ),
            SizedBox(height: 24),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  TextFieldInput(
                    controller: widget.emailController,
                    ispassword: false,
                    hintText: 'Email',
                    suffixIcon: null,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 24),
                  TextFieldInput(
                    controller: widget.usernameController,
                    ispassword: false,
                    hintText: 'Full Name',
                    suffixIcon: null,
                    keyboardType: TextInputType.name,
                  ),
                  SizedBox(height: 24),
                  TextFieldInput(
                    controller: widget.passwordController,
                    ispassword: !_passwordVisible,
                    hintText: 'Password',
                    suffixIcon: IconButton(
                      alignment: Alignment.bottomLeft,
                      icon: Icon(_passwordVisible ? Icons.visibility : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      }
                    ),
                    keyboardType: TextInputType.visiblePassword,
                  ),
                  SizedBox(height: 24),
                  TextFieldInput(
                    controller: widget.passwordConfirmController,
                    ispassword: !_passwordConfirmVisible,
                    hintText: 'Confirm Password',
                    suffixIcon: IconButton(
                      alignment: Alignment.bottomLeft,
                      icon: Icon(_passwordConfirmVisible ? Icons.visibility : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _passwordConfirmVisible = !_passwordConfirmVisible;
                        });
                      }
                    ),
                    keyboardType: TextInputType.visiblePassword,
                  ),
                  SizedBox(height: 28),
                  SizedBox(
                    height: 48,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(Color.fromARGB(218, 226, 37, 24)),
                        shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)))
                      ),
                      onPressed: () async {
                        String res = await _authMethode.signUpUser(
                          email: widget.emailController.text,
                          password: widget.passwordController.text,
                          username: widget.usernameController.text
                        );
                        _showSnackBar(res == "success" ? "Sign Up" : res); // Si res vaut "success", on affiche Login, sinon on affiche le message d'erreur contenu dans res.
                      },
                      child: Text(
                        'Sign up',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  Divider(thickness: 2),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Have an account?"),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginScreen(
                                  emailController: TextEditingController(),
                                  passwordController: TextEditingController(),
                                ),
                              ),
                            );
                          },
                          child: Text(
                            'Log in',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(218, 226, 37, 24),
                            ),
                          ),
                        ),
                      ],
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