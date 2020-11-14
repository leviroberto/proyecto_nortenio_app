import 'package:get/get.dart';

import 'billete_distribuidor_controller.dart';

class DistribuidorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BilleteControllerD());
  }
}
