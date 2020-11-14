import 'package:get/get.dart';
import 'package:proyect_nortenio_app/modules/motorizado/tab/tab_principal_motorizado_controller.dart';

class MotorizadoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PrincipalMotorizadoController());
  }
}
