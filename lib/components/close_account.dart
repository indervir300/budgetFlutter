import 'package:budget/jwttoken.dart';
import 'package:http/http.dart' as http;

Future<void> deleteAccount(String userId, String baseUrl) async {
  final url = Uri.parse('$baseUrl/deleteaccount/users/$userId');

  try {
    final response = await http.delete(url);

    if (response.statusCode == 204) {
      logout();
    } else {
      print('Error deleting account: ${response.statusCode}');
    }
  } catch (error) {
    print('Error deleting account: $error');
  }
}