import 'package:get/get.dart';
import 'package:proyect_nortenio_app/data/providers/local/local_distribuidor.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalDistribuidorRepository {
  final LocalDistribuidor _localDistribuidor = Get.find<LocalDistribuidor>();

  Future<bool> setSharedPreference(SharedPreferences store) {
    return _localDistribuidor.setSharedPreference(store);
  }

  ///MOTORIZADO
  Future<bool> setMotorizados(List<String> zonas) {
    return _localDistribuidor.setMotorizados(zonas);
  }

  Future<List<String>> get motorizados {
    return _localDistribuidor.getMotorizados();
  }

  ///MOTORIZADO
  ///
  ///PUNTO DE VENTA

  Future<bool> setPuntoVentas(List<String> zonas) {
    return _localDistribuidor.setPuntoVentas(zonas);
  }

  Future<List<String>> get puntoVentas {
    return _localDistribuidor.getPuntoVentas();
  }

  ///PUNTO DE VENTA
  ///
  ///BILLETE
  Future<bool> setEdiciones(List<String> zonas) {
    return _localDistribuidor.setEdiciones(zonas);
  }

  Future<List<String>> get ediciones {
    return _localDistribuidor.getEdiciones();
  }

  ///BILLETES
  ///
  ///NOTIFICACIONES
  Future<bool> setNotificaciones(List<String> notificaciones) {
    return _localDistribuidor.setNotificaciones(notificaciones);
  }

  Future<List<String>> get notificaciones {
    return _localDistribuidor.getNotificaciones();
  }

  ///NOTIFICACIONES

}
