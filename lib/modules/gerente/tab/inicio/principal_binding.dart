import 'package:get/get.dart';

import 'principal_controller.dart';

class DistribuidorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PrincipalGerenteControllerG());
  }
}
