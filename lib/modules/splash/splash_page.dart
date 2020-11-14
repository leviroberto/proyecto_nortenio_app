import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:proyect_nortenio_app/global_widgets/loading_widget.dart';
import 'package:proyect_nortenio_app/modules/principal/principal_controller.dart';
import 'splash_controller.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.put(PrincipalController());

    return GetBuilder<SplashController>(
      builder: (_) => Scaffold(
        body: loading(),
      ),
    );
  }
}
