import 'package:shared_preferences/shared_preferences.dart';

class LocalDistribuidor {
  static const KEY_MOTORIZADOS = "distribuidor_motorizados";
  static const KEY_ZONA = "distribuidor_zona";
  static const KEY_PUNTO_VENTAS = "distribuidor_punto_ventas";
  static const KEY_EDICIONES = "distribuidor_ediciones";
  static const KEY_NOTIFICACIONES = "notificaciones_distribuidor123";
  SharedPreferences _storage;

  setSharedPreference(SharedPreferences store) {
    _storage = store;
  }

//MOTORIZADOS

  Future<bool> setMotorizados(List<String> list) async {
    return await _storage.setStringList(KEY_MOTORIZADOS, list);
  }

  Future<List<String>> getMotorizados() async {
    List<String> spList = _storage.getStringList(KEY_MOTORIZADOS);

    return spList;
  }
//MOTORIZADOS
//PUNTO VENTAS

  Future<bool> setPuntoVentas(List<String> list) async {
    return await _storage.setStringList(KEY_PUNTO_VENTAS, list);
  }

  Future<List<String>> getPuntoVentas() async {
    List<String> spList = _storage.getStringList(KEY_PUNTO_VENTAS);

    return spList;
  }
//PUNTO VENTAS

  ///BILLETES//ZONAS

  Future<bool> setEdiciones(List<String> list) async {
    return await _storage.setStringList(KEY_EDICIONES, list);
  }

  Future<List<String>> getEdiciones() async {
    List<String> spList = _storage.getStringList(KEY_EDICIONES);
    return spList;
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
