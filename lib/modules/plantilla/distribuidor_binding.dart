import 'package:get/get.dart';

import 'distribuidor_controller.dart';

class DistribuidorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DistribuidorController());
  }
}
