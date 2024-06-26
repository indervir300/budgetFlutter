import 'dart:async';
import 'package:budget/dashboard.dart';
import 'package:budget/jwttoken.dart';
import 'package:budget/login.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'config.dart';

class LoginStatus {
  static Future<bool> checkLoginStatus() async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'budgettrackerproject');

    if (token != null) {
      // Validate token on the server
      final response = await http.get(
        Uri.parse('${Config.baseUrl}/login_status'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 401) {
        logout();
        return false;
      } else {
        throw Exception('Unexpected response from server: ${response.statusCode}');
      }
    } else {
      logout();
      return false;
    }
  }
}

class Splash_screen extends StatefulWidget {
  const Splash_screen({super.key});

  @override
  State<Splash_screen> createState() => _Splash_screenState();
}

class _Splash_screenState extends State<Splash_screen> {
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    isLoggedIn = await LoginStatus.checkLoginStatus();
    final route = isLoggedIn ? const Dashboard() : const Login();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => route));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: CircleAvatar(
                radius: 90,
                child: Image.asset('assets/images/graph.png', width: 170, height: 170)
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(15.0),
            child: Text('Budget Tracker',
              style: TextStyle(fontWeight: FontWeight.w900, fontFamily: 'georgia',
                  fontSize: 30, color: Colors.blueAccent, letterSpacing: 2)
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: SpinKitFadingCircle(color: Colors.blue, size: 60.0)
          ),
        ],
      ),
    );
  }
}