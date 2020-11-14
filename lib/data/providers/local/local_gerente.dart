import 'package:shared_preferences/shared_preferences.dart';

class LocalGerente {
  static const KEY_ZONAS_MAP = "zonas_map";
  static const KEY_EDICIONES_MAP = "ediciones_map";
  static const KEY_BILLETE_PUNTO_VENTA_MAP = "billete_punto_venta_map";
  static const KEY_DISTRIBUIDORES = "gerente_distribuidores";
  static const KEY_ZONAS = "gerente_zonas";
  static const KEY_EDICIONES = "gerente_ediciones";
  SharedPreferences _storage;

  setSharedPreference(SharedPreferences store) {
    _storage = store;
  }

//GERENTE MAP
  Future<bool> setListZonaMap(List<String> list) async {
    return await _storage.setStringList(KEY_ZONAS_MAP, list);
  }

  Future<bool> setListEdicionMap(List<String> list) async {
    return await _storage.setStringList(KEY_EDICIONES_MAP, list);
  }

  Future<bool> setListBilletePuntoVentaMap(List<String> list) async {
    return await _storage.setStringList(KEY_BILLETE_PUNTO_VENTA_MAP, list);
  }

  Future<List<String>> getZonasMap() async {
    List<String> spList = _storage.getStringList(KEY_ZONAS_MAP);

    return spList;
  }

  Future<List<String>> getEdicionesMap() async {
    List<String> spList = _storage.getStringList(KEY_EDICIONES_MAP);

    return spList;
  }

  Future<List<String>> getBilletePuntoVentaMap() async {
    List<String> spList = _storage.getStringList(KEY_BILLETE_PUNTO_VENTA_MAP);

    return spList;
  }

//DISTRIBUDIOR

  Future<bool> setDistribuidores(List<String> list) async {
    return await _storage.setStringList(KEY_DISTRIBUIDORES, list);
  }

  Future<List<String>> getDistribuidores() async {
    List<String> spList = _storage.getStringList(KEY_DISTRIBUIDORES);

    return spList;
  }
//DISTRIBUIDOR

//ZONAS

  Future<bool> setZonas(List<String> list) async {
    return await _storage.setStringList(KEY_ZONAS, list);
  }

  Future<List<String>> getZonas() async {
    List<String> spList = _storage.getStringList(KEY_ZONAS);

    return spList;
  }
//ZONAS

//ZONAS

  Future<bool> setEdiciones(List<String> list) async {
    return await _storage.setStringList(KEY_EDICIONES, list);
  }

  Future<List<String>> getEdiciones() async {
    List<String> spList = _storage.getStringList(KEY_EDICIONES);
    return spList;
  }
//ZONAS

}
