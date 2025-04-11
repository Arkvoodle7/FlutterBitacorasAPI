import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static String? accessToken;
  static String? refreshToken;

  static Future<bool> login(String email, String password) async {
    final url = Uri.parse('https://security-module.vercel.app/login');

    // Si tu API de autenticación espera credenciales en headers:
    final request = http.Request('POST', url);
    request.headers['email'] = email;
    request.headers['password'] = password;

    // Enviar solicitud
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    // ACEPTAR 200 O 201 COMO ÉXITO
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      accessToken = data['access_token'];
      refreshToken = data['refresh_token'];
      return true;
    } else {
      return false;
    }
  }
}
