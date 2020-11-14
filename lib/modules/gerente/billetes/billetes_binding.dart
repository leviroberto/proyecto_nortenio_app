import 'package:get/get.dart';

import 'billetes_controller.dart';

class DistribuidorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BilletesControllerG());
  }
}
