import 'package:get/get.dart';
import 'package:proyect_nortenio_app/data/models/usuario.dart';
import 'package:proyect_nortenio_app/data/models/zona.dart';
import 'package:proyect_nortenio_app/data/repositories/local/local_auth_repository.dart';
import 'package:proyect_nortenio_app/data/repositories/remote/distribuidor/motorizado_repository_D.dart';
import 'package:proyect_nortenio_app/modules/principal/principal_controller.dart';
import 'package:proyect_nortenio_app/routes/app_routes.dart';
import 'package:proyect_nortenio_app/utils/mensaje.dart';
import 'package:proyect_nortenio_app/utils/utilidades.dart';

class SplashController extends GetxController {
  final LocalAuthRepository _localAuthRepository =
      Get.find<LocalAuthRepository>();
  final PrincipalController _principalController = Get.find();
  final MotorizadoRepositoryD _motorizadoRepository =
      Get.find<MotorizadoRepositoryD>();
  Utilidades _utilidades;

  Mensaje mensaje;
  @override
  void onInit() {
    _utilidades = Utilidades();
    mensaje = new Mensaje();

    super.onInit();
  }

  @override
  void onReady() {
    _init();
  }

  _init() async {
    try {
      final Usuario usuario = await _localAuthRepository.session;

      if (usuario != null) {
        final dynamic _menu = _utilidades.obtenerMenu(
          usuario.tipoUsuario.id,
        );
        _principalController.setMenu(_menu);
        _principalController.init();

        bool estado = false;
        if (usuario.esDistribuidor()) {
          dynamic response =
              await this.cargarZonaPorDistritbuidor(usuario: usuario);
          if (response) {
            estado = true;
          }
        } else if (usuario.esMotorizado()) {
          dynamic response =
              await this.cargarZonaPorMotorizado(usuario: usuario);
          if (response) {
            estado = true;
          }
        } else if (usuario.esGerente()) {
          estado = true;
        }

        if (estado) {
          Get.offNamed(AppRoutes.PRINCIPAL);
        } else {
          Get.offNamed(AppRoutes.INICIAR_SESION);
        }
      } else {
        await _localAuthRepository.clearSession();
        Get.offNamed(AppRoutes.INICIAR_SESION);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<bool> cargarZonaPorDistritbuidor({Usuario usuario}) async {
    dynamic zona = await _localAuthRepository.zona;
    if (zona != null) {
      return true;
    }
    dynamic response = await _motorizadoRepository.obtenerZonaPorDistribuidor(
      motorizado: usuario.id,
    );
    if (response != null) {
      Zona zona = Zona.fromJson(response['zona']);
      _localAuthRepository.setZona(zona);
      return true;
    } else {
      mensaje.mensajeConError(mensaje: Mensaje.errorDeConsulta);
      return false;
    }
  }

  Future<bool> cargarZonaPorMotorizado({Usuario usuario}) async {
    dynamic zona = await _localAuthRepository.zona;
    if (zona != null) {
      return true;
    }
    dynamic response = await _motorizadoRepository.obtenerZonaPorMotorizado(
      motorizado: usuario.id,
    );
    if (response != null) {
      Zona zona = Zona.fromJson(response['zona']);
      _localAuthRepository.setZona(zona);
      return true;
    } else {
      mensaje.mensajeConError(mensaje: Mensaje.errorDeConsulta);
      return false;
    }
  }
}
