import 'package:flutter/material.dart';
import 'package:holbegram/widgets/text_field.dart';
import 'package:holbegram/screens/auth/signup_screen.dart';
import 'package:holbegram/methods/auth_methods.dart';

class LoginScreen extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool _passwordVisible;

  const LoginScreen({
    super.key,
    required this.emailController,
    required this.passwordController,
    this._passwordVisible = true,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}


class _LoginScreenState extends State<LoginScreen> {
  late bool _passwordVisible; // utilisation de late pour dire qu'elle sera initialisée plus tard avec une valeur non nulle
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
  }

  @override
  void dispose() {
    widget.emailController.dispose();
    widget.passwordController.dispose();
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
                        String res = await _authMethode.login(
                          email: widget.emailController.text,
                          password: widget.passwordController.text
                        );
                        _showSnackBar(res == "success" ? "Login" : res); // Si res vaut "success", on affiche Login, sinon on affiche le message d'erreur contenu dans res.
                      },
                      child: Text(
                        'Log in',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Forgot your login details? '),
                      Text(
                        'Get help logging in',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  Flexible(
                    flex: 0,
                    child: Container(),
                  ),
                  SizedBox(height: 24),
                  Divider(thickness: 2),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have an account"),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignUp(
                                  emailController: TextEditingController(),
                                  usernameController: TextEditingController(),
                                  passwordController: TextEditingController(),
                                  passwordConfirmController: TextEditingController(),
                                ),
                              ),
                            );
                          },
                          child: Text(
                            'Sign up',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(218, 226, 37, 24),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Flexible(child: Divider(thickness: 2)),
                      Text(' OR '),
                      Flexible(child: Divider(thickness: 2)),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(
                        'https://www.freepnglogos.com/uploads/google-logo-png/google-logo-png-webinar-optimizing-for-success-google-business-webinar-13.png',
                        width: 40,
                        height: 40,
                      ),
                      Text('Sign in with Google'),
                    ],
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