import 'package:flutter_dotenv/flutter_dotenv.dart';

class Config {
  static Future<void> loadEnvironment() async {
    await dotenv.load(fileName: "lib/.env");
  }
  static String get baseUrl => dotenv.env['BASE_URL']!;
}