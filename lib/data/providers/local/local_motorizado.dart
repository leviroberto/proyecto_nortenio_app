import 'package:shared_preferences/shared_preferences.dart';

class LocalMotorizado {
  static const KEY_MOTORIZADOS = "distribuidor_motorizados";
  static const KEY_ZONA = "distribuidor_zona";
  static const KEY_PUNTO_VENTAS = "distribuidor_punto_ventas";
  static const KEY_EDICIONES = "motorizados_ediciones";
  SharedPreferences _storage;

  setSharedPreference(SharedPreferences store) {
    _storage = store;
  }

  ///BILLETES//EDICINES

  Future<bool> setEdiciones(List<String> list) async {
    return await _storage.setStringList(KEY_EDICIONES, list);
  }

  Future<List<String>> getEdiciones() async {
    List<String> spList = _storage.getStringList(KEY_EDICIONES);
    return spList;
  }

  ///BILLETES//EDICINES

}
