import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'config.dart';

const storage = FlutterSecureStorage();

Future<String?> getToken() async {
  try {
    final token = await storage.read(key: 'budgettrackerproject');
    return token;
  } on PlatformException catch (e) {
    print('Error reading token: $e');
    return null;
  }
}

Future<http.Response> sendToken(String url) async {
  final token = await getToken();
  if (token == null) {
    throw Exception('No token found');
  }

  final headers = {'Authorization': 'Bearer $token'};
  final response = await http.post(Uri.parse(url), headers: headers);
  return response;
}

class UserService {
  final List<User> users = [];

  Future<void> sendTokenToServer() async {
    try {
      final response = await sendToken('${Config.baseUrl}/getdata');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;

        final String userId = data['userId'];
        final String name = data['name'];
        final String email = data['email'];
        final String dateCreated = data['createdAt'];
        users.add(User(userId, name, email, dateCreated));
      } else {
        print('Error sending token: ${response.statusCode}');
        logout();
      }
    } on Exception catch (e) {
      print('Error: $e');
    }
  }

  Future<void> fetchData() async {
    await sendTokenToServer();
  }
}

class User {
  final String userId;
  final String name;
  final String email;
  final String dateCreated;
  User(this.userId, this.name, this.email, this.dateCreated);
}

Future<void> logout() async {
  try {
    await storage.delete(key: 'budgettrackerproject');
    print('Logged out');
  } on PlatformException catch (e) {
    print('Error removing token: $e');
  }
}

