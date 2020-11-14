import 'package:get/get.dart';
import 'package:proyect_nortenio_app/data/providers/local/local_gerente.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalGerenteRepository {
  final LocalGerente _todoLocal = Get.find<LocalGerente>();

  ///MAP GERENTE
  Future<bool> setListaZonasMap(List<String> zonas) {
    return _todoLocal.setListZonaMap(zonas);
  }

  Future<bool> setSharedPreference(SharedPreferences store) {
    return _todoLocal.setSharedPreference(store);
  }

  Future<bool> setListaEdicionesMap(List<String> zonas) {
    return _todoLocal.setListEdicionMap(zonas);
  }

  Future<bool> setListaBilletePuntoVentaMap(List<String> zonas) {
    return _todoLocal.setListBilletePuntoVentaMap(zonas);
  }

  ///DISTRIBUIDORE
  Future<bool> setDistribuidores(List<String> zonas) {
    return _todoLocal.setDistribuidores(zonas);
  }

  Future<List<String>> get distribuidores {
    return _todoLocal.getDistribuidores();
  }

  ///DISTRIBUIDORES
  ///
  ///ZONAS
  Future<bool> setZonas(List<String> zonas) {
    return _todoLocal.setZonas(zonas);
  }

  Future<List<String>> get zonas {
    return _todoLocal.getZonas();
  }

  ///ZONAS
  ///
  ///ZONAS
  Future<bool> setEdiciones(List<String> zonas) {
    return _todoLocal.setEdiciones(zonas);
  }

  Future<List<String>> get ediciones {
    return _todoLocal.getEdiciones();
  }

  ///ZONAS

  Future<List<String>> get zonasMap => _todoLocal.getZonasMap();
  Future<List<String>> get edicionesMap => _todoLocal.getEdicionesMap();
  Future<List<String>> get billetePuntoVentaMap =>
      _todoLocal.getBilletePuntoVentaMap();
}
