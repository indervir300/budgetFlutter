import 'package:jwt_decode/jwt_decode.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final _storage = const FlutterSecureStorage();

  Future<String?> readToken() async => await _storage.read(key: 'budgettrackerproject');
}

Future<String?> getUserIdFromToken() async {
  final secureStorage = SecureStorageService();
  final token = await secureStorage.readToken();

  if (token == null) {
    return null;
  }

  try {
    final decodedToken = Jwt.parseJwt(token);
    final userId = decodedToken['userId'];
    print(userId);
    return userId;
  } catch (error) {
    print('Error decoding JWT token: $error');
    return null; // Handle decoding errors (e.g., invalid token)
  }
}
