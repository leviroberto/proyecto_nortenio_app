import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:proyect_nortenio_app/data/models/conifiguracion_maps.dart';
import 'package:proyect_nortenio_app/data/models/usuario.dart';
import 'package:proyect_nortenio_app/data/models/zona.dart';

class LocalAuth {
  static const KEY_SESSION = "session";
  static const KEY_ZONA = "zona";
  static const KEY_CONFIGURACION_MAP = "congiguracion_map";
  static const KEY_TOKEN_USUARIO = "token_usuario";
  final FlutterSecureStorage _storage = Get.find<FlutterSecureStorage>();

  Future<void> setSession(Usuario usuario) async {
    await _storage.write(key: KEY_SESSION, value: jsonEncode(usuario.toJson()));
  }

  Future<void> clearSession() async {
    await _storage.deleteAll();
  }

  Future<Usuario> getSession() async {
    final String data = await _storage.read(key: KEY_SESSION);
    if (data != null) {
      final Usuario requestToken = Usuario.fromJson(jsonDecode(data));
      return requestToken;
    }
    return null;
  }

  Future<Zona> getZona() async {
    final String data = await _storage.read(key: KEY_ZONA);
    if (data != null) {
      final Zona requestToken = Zona.fromJson(jsonDecode(data));
      return requestToken;
    }
    return null;
  }

  Future<String> getTokenUsuario() async {
    final String data = await _storage.read(key: KEY_TOKEN_USUARIO);
    if (data != null) {
      final String requestToken = jsonDecode(data);
      return requestToken;
    }
    return null;
  }

  Future<ConfiguracionMap> getConfiguracionMap() async {
    final String data = await _storage.read(key: KEY_CONFIGURACION_MAP);
    if (data != null) {
      final ConfiguracionMap requestToken =
          ConfiguracionMap.fromJson(jsonDecode(data));
      return requestToken;
    }
    return null;
  }

  Future<void> setZona(Zona zona) async {
    await _storage.write(key: KEY_ZONA, value: jsonEncode(zona.toJson()));
  }

  Future<void> setTokenUsuario(String token) async {
    await _storage.write(key: KEY_TOKEN_USUARIO, value: jsonEncode(token));
  }

  Future<void> setConfiguracionMap(ConfiguracionMap configuracionMap) async {
    await _storage.write(
        key: KEY_CONFIGURACION_MAP,
        value: jsonEncode(configuracionMap.toJson()));
  }
}
