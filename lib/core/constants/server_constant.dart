import 'dart:io';

class ServerConstant {
  static String serverUrl = _getServerUrl();

  static String _getServerUrl() {
    try {
      if (Platform.isAndroid) {
        return "http://10.0.2.2:8000/";
      } else {
        return "http://127.0.0.1:8000/";
      }
    } catch (e) {
      // Fallback URL for web or unsupported platforms
      return "http://127.0.0.1:8000/";
    }
  }

  static const signUp = 'auth/signup';
  static const logIn = 'auth/login';
}