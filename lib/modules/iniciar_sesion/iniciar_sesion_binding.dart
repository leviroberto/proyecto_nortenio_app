import 'package:get/get.dart';
import 'iniciar_sesion_controller.dart';

class IniciarSesionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => IniciarSesionController());
  }
}
