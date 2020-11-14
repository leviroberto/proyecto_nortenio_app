import 'package:get/get.dart';

import 'maps_controller.dart';

class DistribuidorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MapsControllerM());
  }
}
