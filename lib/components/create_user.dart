import 'package:budget/config.dart';
import 'package:http/http.dart' as http;


class User {
  final String name;
  final String email;
  final String password;

  User({required this.name, required this.email, required this.password});

  Map<String, dynamic> toJson() =>
      {"name": name, "email": email, "password": password};
}


class StoreUser {
  static String postUrl = '${Config.baseUrl}/register_user';

  static Future<http.Response> createUser(User user) async {
    final url = Uri.parse(postUrl);
    final response = await http.post(url, body: user.toJson());
    return response;
  }

}