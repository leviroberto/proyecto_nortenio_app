import 'package:get/get.dart';

import 'motirizado_controller.dart';

class DistribuidorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MotorizadoControllerD());
  }
}
