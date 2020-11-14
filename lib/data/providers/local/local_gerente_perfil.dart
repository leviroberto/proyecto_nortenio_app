import 'package:shared_preferences/shared_preferences.dart';

class LocalGerentePerfil {
  static const KEY_NOTIFICACIONES = "notificaciones_gerente";
  SharedPreferences _storage;

  setSharedPreference(SharedPreferences store) {
    _storage = store;
  }

//ZONAS
  ///BILLETES

  ///  ///NOTIFICACIONES

  Future<bool> setNotificaciones(List<String> list) async {
    return await _storage.setStringList(KEY_NOTIFICACIONES, list);
  }

  Future<List<String>> getNotificaciones() async {
    try {
      List<String> spList = _storage.getStringList(KEY_NOTIFICACIONES);
      return spList;
    } catch (e1) {
      return [];
    }
  }
//ZONAS
  ///NOTIFICACIONES

}
