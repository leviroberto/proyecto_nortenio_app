import 'package:get/route_manager.dart';
import 'package:proyect_nortenio_app/modules/iniciar_sesion/iniciar_sesion_binding.dart';
import 'package:proyect_nortenio_app/modules/iniciar_sesion/iniciar_sesion_page.dart';
import 'package:proyect_nortenio_app/modules/principal/principal_binding.dart';
import 'package:proyect_nortenio_app/modules/principal/principal_page.dart';
import 'package:proyect_nortenio_app/modules/splash/splash_binding.dart';
import 'package:proyect_nortenio_app/modules/splash/splash_page.dart';

import 'app_routes.dart';

class AppPages {
  static final List<GetPage> pages = [
    GetPage(
      name: AppRoutes.SPLASH,
      page: () => SplashPage(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.INICIAR_SESION,
      page: () => IniciarSesionPage(),
      binding: IniciarSesionBinding(),
    ),
    GetPage(
      name: AppRoutes.PRINCIPAL,
      page: () => PrincipalPage(),
      binding: PrincipalBinding(),
    ),
  ];
}
