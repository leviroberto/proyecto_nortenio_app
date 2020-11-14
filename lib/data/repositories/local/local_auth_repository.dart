import 'package:get/get.dart';
import 'package:proyect_nortenio_app/data/models/conifiguracion_maps.dart';
import 'package:proyect_nortenio_app/data/models/usuario.dart';
import 'package:proyect_nortenio_app/data/models/zona.dart';
import 'package:proyect_nortenio_app/data/providers/local/local_auth.dart';

class LocalAuthRepository {
  final LocalAuth _localAuth = Get.find<LocalAuth>();

  Future<void> setSession(Usuario usuario) => _localAuth.setSession(usuario);
  Future<void> setConfiguracionMap(ConfiguracionMap configuracionMap) =>
      _localAuth.setConfiguracionMap(configuracionMap);
  Future<void> setZona(Zona zona) => _localAuth.setZona(zona);
  Future<void> setTokenUsuario(String token) =>
      _localAuth.setTokenUsuario(token);

  Future<void> clearSession() => _localAuth.clearSession();

  Future<Usuario> get session => _localAuth.getSession();
  Future<Zona> get zona => _localAuth.getZona();
  Future<ConfiguracionMap> get configuracionMap =>
      _localAuth.getConfiguracionMap();
  Future<String> get tokenUsuario => _localAuth.getTokenUsuario();
}
