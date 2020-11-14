import 'dart:convert';
import 'package:http/http.dart' as http;
import 'conexion.dart';

class UsuarioApi {
  Future<dynamic> iniciarSesion(
      {String userName, String password, String token}) async {
    String url = Conexion.conexion() + "iniciar-sesion";
    try {
      final http.Response response = await http.post(url,
          body: jsonEncode({
            "username": userName,
            "password": password,
            "token": token,
          }),
          headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
