import 'package:get/get.dart';
import 'package:proyect_nortenio_app/data/models/usuario.dart';
import 'package:proyect_nortenio_app/data/repositories/local/local_auth_repository.dart';
import 'package:proyect_nortenio_app/global_widgets/bottom_menu.dart';
import 'package:proyect_nortenio_app/routes/app_routes.dart';

class PrincipalController extends GetxController {
  RxInt currentTab = 0.obs;
  Rx<Usuario> usuario = new Usuario().obs;
  RxBool cargando = false.obs;
  final LocalAuthRepository _localAuthRepository =
      Get.find<LocalAuthRepository>();

  List<BottomMenuItem> menu;

  @override
  void onInit() {
    super.onInit();
  }

  void setMenu(List<BottomMenuItem> menu) {
    this.menu = menu;
  }

  void setCurrectTab(int valor) {
    this.currentTab.value = valor;
  }

  Future<bool> obtenerUsuario() async {
    usuario.value = await _localAuthRepository.session;
    return true;
  }

  cerrarSesion() async {
    await _localAuthRepository.clearSession();
    Get.offNamed(AppRoutes.INICIAR_SESION);
  }

  init() async {
    try {
      this.cargando.value = true;
      final Usuario usuarioe = await _localAuthRepository.session;

      usuario = usuarioe.obs;

      if (usuario.isNull) {
        await _localAuthRepository.clearSession();
        Get.offNamed(AppRoutes.INICIAR_SESION);
        return;
      }
      this.cargando.value = true;
    } catch (e) {
      print(e);
    }
  }
}
