import 'dart:convert';
import 'dart:io';
import 'package:budget/dashboard.dart';
import 'package:budget/signup.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:email_validator/email_validator.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'config.dart';

const storage = FlutterSecureStorage();

Future<void> storeJwt(String token) async {
  await storage.write(key: 'budgettrackerproject', value: token);
}

class LoginButton extends StatefulWidget {
  final String initialText;
  final VoidCallback onPressed;
  final bool isEnabled;

  const LoginButton(
      {super.key,
      required this.initialText,
      required this.onPressed,
      this.isEnabled = true});
  @override
  State<LoginButton> createState() => _LoginButtonState();
}

bool _isLoading = false;
bool _isEnabled = true;

class _LoginButtonState extends State<LoginButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            backgroundColor: Colors.blue.shade500,
            foregroundColor: Colors.white,
            textStyle: const TextStyle(
                fontFamily: "Serif",
                fontWeight: FontWeight.w700,
                letterSpacing: 2),
            disabledBackgroundColor: Colors.grey),
        onPressed: widget.isEnabled
            ? () {
                widget.onPressed();
              }
            : null,
        child: _isLoading
            ? const Padding(
                padding: EdgeInsets.fromLTRB(20, 25, 20, 25),
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white)))
            : Padding(
                padding: const EdgeInsets.fromLTRB(50, 25, 50, 25),
                child: Text(widget.initialText,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 17))));
  }
}

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController(), _password = TextEditingController();

  void showSnackBar(String responseMsg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Center(
            child: Text(responseMsg,
                style: const TextStyle(fontWeight: FontWeight.w900))),
        backgroundColor: color));
  }

  Future<void> _login() async {
    try {
      if (_formKey.currentState!.validate()) {
        final response = await http.post(
            Uri.parse('${Config.baseUrl}/login_auth'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8'
            },
            body: jsonEncode(<String, String>{
              'email': _email.text.toString(),
              'password': _password.text.toString()
            }));

        final res = jsonDecode(response.body);
        if (response.statusCode == 200) {
          storeJwt(res['jwtToken']);
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const Dashboard()));
        } else {
          showSnackBar(res['message'], Colors.red);
        }
      }
    } on SocketException {
      showSnackBar('Internet connection required!', Colors.redAccent);
    } on Exception {
      showSnackBar('Something went wrong! Try again later.', Colors.red);
    } finally {
      setState(() {
        _isLoading = false;
        _isEnabled = true;
      });
    }
  }

  bool redBorder = false;
  bool passRedBorder = false;
  final OutlineInputBorder _enabledBorder = OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.grey),
      borderRadius: BorderRadius.circular(15));

  final OutlineInputBorder _errorBorder = OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.red),
      borderRadius: BorderRadius.circular(15));

  bool _isValidEmail(String email) {
    return EmailValidator.validate(email);
  }

  bool _isValidPassword(String password) {
    final bool hasUppercase = password.contains(RegExp(r'[A-Z]'));
    final bool hasLowercase = password.contains(RegExp(r'[a-z]'));
    final bool hasDigit = password.contains(RegExp(r'[0-9]'));
    final bool hasSpecialChar = password.contains(RegExp(r'[!@#$%^&*]'));
    const int minLength = 8;

    return password.length >= minLength &&
        hasUppercase &&
        hasLowercase &&
        hasDigit &&
        hasSpecialChar;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 350,
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    child: CircleAvatar(
                        radius: 90,
                        child: Image.asset('assets/images/graph.png',
                            width: 170, height: 170)),
                  )),
              Padding(
                padding: const EdgeInsets.all(9.0),
                child: Form(
                  key: _formKey,
                  child: SizedBox(
                    height: 62,
                    child: TextFormField(
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          enabledBorder:
                              redBorder ? _errorBorder : _enabledBorder,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(15)),
                          hintStyle: TextStyle(color: Colors.grey[500]),
                          hintText: "Your email",
                          fillColor: Colors.white70,
                          prefixIcon: const Icon(Icons.email_outlined)),
                      validator: (value) => null,
                      onChanged: (value) => setState(() {
                        _email.text = value;
                        redBorder = !_isValidEmail(_email.text);
                      }),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(9.0),
                child: SizedBox(
                    height: 62,
                    child: TextFormField(
                        controller: _password,
                        obscureText: true,
                        obscuringCharacter: '*',
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          enabledBorder:
                              passRedBorder ? _errorBorder : _enabledBorder,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(15)),
                          hintStyle: TextStyle(color: Colors.grey[500]),
                          hintText: "Your Password",
                          fillColor: Colors.white70,
                          prefixIcon: const Icon(Icons.lock_outlined),
                          suffix: IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.remove_red_eye_outlined,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        validator: (value) => null,
                        onChanged: (value) => setState(() {
                              _password.text = value;
                              passRedBorder = !_isValidPassword(_password.text);
                            }))),
              ),
              SizedBox(
                width: 350,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: LoginButton(
                    initialText: 'Login',
                    onPressed: () {
                      if (_email.text.isNotEmpty &&
                          _password.text.isNotEmpty &&
                          _isValidEmail(_email.text) &&
                          _isValidPassword(_password.text)) {
                        setState(
                          () {
                            _isLoading = true;
                            _login();
                            _isEnabled = false;
                          },
                        );
                      }
                    },
                    isEnabled: _isEnabled,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Not have an account',
                      style: TextStyle(fontSize: 15),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Signup()));
                        },
                        style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.all(0)),
                        child: const Text('Sign up')),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
