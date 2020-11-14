import 'package:get/get.dart';
import 'package:proyect_nortenio_app/data/providers/local/local_distribuidor_perfil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalMotorizadoPerfilRepository {
  final LocalMotorizadoPerfil _localDistribuidor =
      Get.find<LocalMotorizadoPerfil>();

  Future<bool> setSharedPreference(SharedPreferences store) {
    return _localDistribuidor.setSharedPreference(store);
  }

  ///NOTIFICACIONES
  Future<bool> setNotificaciones(List<String> notificaciones) {
    return _localDistribuidor.setNotificaciones(notificaciones);
  }

  Future<List<String>> get notificaciones {
    return _localDistribuidor.getNotificaciones();
  }

  ///NOTIFICACIONES

}
