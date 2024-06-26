import 'dart:convert';
import 'dart:io';
import 'package:budget/login.dart';
import 'package:budget/components//create_user.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

class SignUpButton extends StatefulWidget {
  final String initialText;
  final VoidCallback onPressed;
  final bool isEnabled;

  const SignUpButton(
      {super.key,
      required this.initialText,
      required this.onPressed,
      this.isEnabled = true});
  @override
  State<SignUpButton> createState() => _SignUpButtonState();
}

bool _isLoading = false;
bool _isEnabled = true;

class _SignUpButtonState extends State<SignUpButton> {
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
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Padding(
                padding: const EdgeInsets.fromLTRB(50, 25, 50, 25),
                child: Text(
                  widget.initialText,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 17),
                ),
              ));
  }
}

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void showSnackBar(String responseMsg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Center(
          child: Text(
            responseMsg,
            style: const TextStyle(fontWeight: FontWeight.w900),
          ),
        ),
        backgroundColor: color,
      ),
    );
  }

  Future<void> _createUser() async {
    if (_formKey.currentState!.validate()) {
      final user = User(
          name: _nameController.text.toString(),
          email: _emailController.text.toString(),
          password: _passwordController.text.toString());

      try {
        final response = await StoreUser.createUser(user);
        if (response.statusCode == 201) {
          final res = jsonDecode(response.body);
          showSnackBar(res['message'], Colors.green);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => const Login()));
        } else if (response.statusCode == 400) {
          final res = jsonDecode(response.body);
          showSnackBar(res['message'], Colors.lightBlue);
        } else {}
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
        body: Form(
            key: _formKey,
            child: Center(
                child: SizedBox(
                    width: 350,
                    height: double.infinity,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  child: CircleAvatar(
                                      radius: 90,
                                      child: Image.asset(
                                          'assets/images/graph.png',
                                          width: 170,
                                          height: 170)))),
                          Padding(
                              padding: const EdgeInsets.all(9.0),
                              child: SizedBox(
                                  height: 62,
                                  child: TextFormField(
                                      controller: _nameController,
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Colors.grey),
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          hintStyle: TextStyle(
                                              color: Colors.grey[500]),
                                          hintText: "Your Name",
                                          fillColor: Colors.white70,
                                          prefixIcon: const Icon(
                                              Icons.person_2_outlined))))),
                          Padding(
                            padding: const EdgeInsets.all(9.0),
                            child: SizedBox(
                              height: 62,
                              child: TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                    enabledBorder: redBorder
                                        ? _errorBorder
                                        : _enabledBorder,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    hintStyle:
                                        TextStyle(color: Colors.grey[500]),
                                    hintText: "Your email",
                                    fillColor: Colors.white70,
                                    prefixIcon:
                                        const Icon(Icons.email_outlined)),
                                validator: (value) =>
                                    null, // Prevent default error text
                                onChanged: (value) => setState(() {
                                  _emailController.text = value;
                                  redBorder =
                                      !_isValidEmail(_emailController.text);
                                }),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(9.0),
                            child: SizedBox(
                                height: 62,
                                child: TextFormField(
                                    controller: _passwordController,
                                    obscureText: true,
                                    obscuringCharacter: '*',
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                        enabledBorder: passRedBorder
                                            ? _errorBorder
                                            : _enabledBorder,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          // Set focused border the same as enabled
                                          borderSide: const BorderSide(
                                              color: Colors.grey),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        hintStyle:
                                            TextStyle(color: Colors.grey[500]),
                                        hintText: "Your Password",
                                        fillColor: Colors.white70,
                                        prefixIcon:
                                            const Icon(Icons.lock_outlined),
                                        suffix: IconButton(
                                            onPressed: () {},
                                            icon: const Icon(
                                                Icons.remove_red_eye_outlined,
                                                color: Colors.grey))),
                                    validator: (value) => null,
                                    onChanged: (value) => setState(() {
                                          _passwordController.text = value;
                                          passRedBorder = !_isValidPassword(
                                              _passwordController.text);
                                        }))),
                          ),
                          SizedBox(
                              width: 350,
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SignUpButton(
                                    initialText: 'Sign up',
                                    onPressed: () {
                                      if (_nameController.text.isNotEmpty &&
                                          _emailController.text.isNotEmpty &&
                                          _passwordController.text.isNotEmpty &&
                                          _isValidEmail(
                                              _emailController.text) &&
                                          _isValidPassword(
                                              _passwordController.text)) {
                                        setState(
                                          () {
                                            _isLoading = true;
                                            _createUser();
                                            _isEnabled = false;
                                          },
                                        );
                                      }
                                    },
                                    isEnabled: _isEnabled,
                                  ))),
                          Container(
                              margin: const EdgeInsets.only(top: 10),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text('Already have an account',
                                        style: TextStyle(fontSize: 15)),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const Login()));
                                        },
                                        style: TextButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            padding: const EdgeInsets.all(0)),
                                        child: const Text('Login'))
                                  ])),
                        ])))));
  }
}
