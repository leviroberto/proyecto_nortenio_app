import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:proyect_nortenio_app/data/models/zona.dart';
import 'package:proyect_nortenio_app/data/repositories/remote/distribuidor/motorizado_repository_D.dart';
import 'package:proyect_nortenio_app/data/repositories/remote/usuario_repository.dart';
import 'package:proyect_nortenio_app/modules/principal/principal_controller.dart';
import 'package:proyect_nortenio_app/utils/mensaje.dart';
import 'package:proyect_nortenio_app/utils/utilidades.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/usuario.dart';
import '../../data/repositories/local/local_auth_repository.dart';
import '../../routes/app_routes.dart';

class IniciarSesionController extends GetxController {
  final UsuarioRepository _usuarioRepository = Get.find<UsuarioRepository>();
  final LocalAuthRepository _localAuthRepository =
      Get.find<LocalAuthRepository>();
  final PrincipalController _principalController = Get.find();
  String _userName = '', _password = '';
  Utilidades _utilidades;
  final MotorizadoRepositoryD _motorizadoRepository =
      Get.find<MotorizadoRepositoryD>();
  Mensaje mensaje;
  @override
  void onInit() {
    _utilidades = Utilidades();
    mensaje = new Mensaje();
    super.onInit();
  }

  @override
  void onReady() {}

  void onUserNameChanged(String text) {
    _userName = text;
  }

  void onPasswordChanged(String text) {
    _password = text;
  }

  Future<String> obtenerToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = await prefs.getString("token_usuario");
    return token;
  }

  Future<void> submit(
      {RoundedLoadingButtonController btnControllerIniciarSesion,
      BuildContext context}) async {
    dynamic token = await obtenerToken();
    final dynamic response = await _usuarioRepository.iniciarSesion(
        userName: _userName, password: _password, token: token);
    if (response != null) {
      dynamic estado = response['estado'];
      switch (estado) {
        case "1":
          btnControllerIniciarSesion.reset();
          Get.snackbar(Mensaje.nomre_empresa, Mensaje.error_email,
              colorText: Colors.red, snackPosition: SnackPosition.BOTTOM);
          break;
        case "2":
          btnControllerIniciarSesion.reset();
          Get.snackbar(Mensaje.nomre_empresa, Mensaje.error_cuenta_desabilitada,
              colorText: Colors.red, snackPosition: SnackPosition.BOTTOM);
          break;
        case "3":
          btnControllerIniciarSesion.reset();
          Get.snackbar(Mensaje.nomre_empresa, Mensaje.error_contrasenia,
              colorText: Colors.red, snackPosition: SnackPosition.BOTTOM);
          break;
        case "4":
          Usuario usuario = Usuario.fromJson(response["usuario"]);
          await _localAuthRepository.setSession(usuario);
          Get.snackbar(Mensaje.nomre_empresa,
              Mensaje.inici_sesion_correcto + " " + usuario.nombre,
              colorText: Colors.green, snackPosition: SnackPosition.BOTTOM);
          final dynamic _menu = _utilidades.obtenerMenu(
            usuario.tipoUsuario.id,
          );
          _principalController.setMenu(_menu);
          _principalController.init();
          btnControllerIniciarSesion.reset();

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
          break;
      }
    } else {
      btnControllerIniciarSesion.reset();
      Get.snackbar(Mensaje.nomre_empresa, Mensaje.error_cargar_datos,
          colorText: Colors.red, snackPosition: SnackPosition.BOTTOM);
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

  Future<void> setTokenUsuario({String token}) async {
    await _localAuthRepository.setTokenUsuario(token);
  }
}
