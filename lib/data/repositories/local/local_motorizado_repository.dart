import 'package:get/get.dart';
import 'package:proyect_nortenio_app/data/providers/local/local_motorizado.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalMotorizadoRepository {
  final LocalMotorizado _localMotorizado = Get.find<LocalMotorizado>();

  Future<bool> setSharedPreference(SharedPreferences store) {
    return _localMotorizado.setSharedPreference(store);
  }

  ///BILLETE
  Future<bool> setEdiciones(List<String> zonas) {
    return _localMotorizado.setEdiciones(zonas);
  }

  Future<List<String>> get ediciones {
    return _localMotorizado.getEdiciones();
  }

  ///BILLETES

}
