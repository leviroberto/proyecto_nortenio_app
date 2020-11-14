import 'package:get/get.dart';

import 'tab_principal_distribuidor_controller.dart';

class DistribuidorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PrincipalDistribuidorControllerD());
  }
}
