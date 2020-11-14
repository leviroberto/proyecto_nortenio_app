import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:proyect_nortenio_app/data/models/zona.dart';
import 'package:proyect_nortenio_app/data/models/zonaMotorizado.dart';
import 'package:proyect_nortenio_app/data/repositories/local/local_auth_repository.dart';
import 'package:proyect_nortenio_app/data/repositories/local/local_distribuidor_repository.dart';
import 'package:proyect_nortenio_app/data/repositories/remote/distribuidor/motorizado_repository_D.dart';
import 'package:proyect_nortenio_app/utils/mensaje.dart';
import 'package:proyect_nortenio_app/utils/utilidades.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/models/usuario.dart';
import 'local_widgets/crear_scallfold.dart';
import 'local_widgets/editar_scallfolld.dart';

class MotorizadoControllerD extends GetxController {
  RxBool cargando = true.obs;
  RxList<ZonaMotorizado> listaZonaMotorizado = List<ZonaMotorizado>().obs;
  Mensaje mensaje;

  Rx<Zona> zona;
  Usuario motorizado;

  final MotorizadoRepositoryD _motorizadoRepository =
      Get.find<MotorizadoRepositoryD>();

  final LocalAuthRepository _localAuthRepository =
      Get.find<LocalAuthRepository>();

  final LocalDistribuidorRepository _localDistribuidorRepository =
      Get.find<LocalDistribuidorRepository>();

  @override
  void onInit() {
    super.onInit();
    mensaje = new Mensaje();
  }

  Future<bool> getZonaMotorizadosApi() async {
    this.cargando.value = true;
    listaZonaMotorizado.clear();
    if (zona == null) {
      zona = new Zona().obs;
      zona.value = await _localAuthRepository.zona;
    }
    dynamic response =
        await _motorizadoRepository.usuariosPorMotorizado(zona: zona.value.id);
    this.cargando.value = false;
    if (response != null) {
      dynamic lista = response['zonas'];
      for (int i = 0; i < lista.length; i++) {
        dynamic aux = lista[i];
        if (aux != null) {
          ZonaMotorizado motirizado = ZonaMotorizado.fromJson(lista[i]);
          listaZonaMotorizado.add(motirizado);
        }
      }
      this.setZonaMotorizadosLocal();
    } else {
      mensaje.mensajeConError(mensaje: Mensaje.errorDeConsulta);
    }
    return true;
  }

  Future<bool> registrar(
      {ZonaMotorizado zonaMotorizado,
      RoundedLoadingButtonController btnControllerRegistrar}) async {
    this.cargando.value = true;

    dynamic response =
        await _motorizadoRepository.registrar(zonaMotorizado: zonaMotorizado);
    this.cargando.value = false;
    btnControllerRegistrar.reset();
    if (response != null) {
      dynamic estado = response['estado'];
      switch (estado) {
        case "1":
          ZonaMotorizado motirizadoAux =
              ZonaMotorizado.fromJson(response["zona_motorizado"]);
          this.listaZonaMotorizado.add(motirizadoAux);
          this.setZonaMotorizadosLocal();
          return true;
          break;
        case "2":
          dynamic estadoError = response['error'];
          for (int i = 0; i < estadoError.length; i++) {
            String data = estadoError[i];
            mensaje.mensajeConError(mensaje: data);
            break;
          }
          return false;
      }
    } else {
      mensaje.mensajeConError(mensaje: Mensaje.errorDeCreacion);
      return false;
    }
    return false;
  }

  Future<bool> actualizar(
      {ZonaMotorizado zonaMotorizado,
      RoundedLoadingButtonController btnControllerRegistrar}) async {
    this.cargando.value = true;

    dynamic response =
        await _motorizadoRepository.actualizar(zonaMotorizado: zonaMotorizado);
    this.cargando.value = false;
    btnControllerRegistrar.reset();
    if (response != null) {
      dynamic estado = response['estado'];
      switch (estado) {
        case "1":
          this.getZonaMotorizadosApi();
          return true;
          break;
        case "2":
          dynamic estadoError = response['error'];
          for (int i = 0; i < estadoError.length; i++) {
            String data = estadoError[i];
            if (data == "dni") {
              mensaje.mensajeConError(mensaje: Mensaje.error_dni_ya_registrado);
            } else if (data == "username") {
              mensaje.mensajeConError(
                  mensaje: Mensaje.error_usuario_ya_registrado);
            } else if (data == 'password') {
              mensaje.mensajeConError(
                  mensaje: Mensaje.error_contrasenia_mayor_a_8);
            }
          }
          return false;
      }
    } else {
      mensaje.mensajeConError(mensaje: Mensaje.errorDeActualizacion);
      return false;
    }
    return false;
  }

  Future<void> eliminar({int id}) async {
    this.cargando.value = true;

    dynamic response = await _motorizadoRepository.eliminar(id: id);
    this.cargando.value = false;
    if (response != null) {
      dynamic estado = response['estado'];
      switch (estado) {
        case "1":
          mensaje.mensajeCorrecto(mensaje: Mensaje.afirmacionDeEliminacion);
          int posicion = obtenerPosicion(id);
          if (posicion != -1) {
            this.listaZonaMotorizado.removeAt(posicion);
            this.setZonaMotorizadosLocal();
          } else {
            this.getZonaMotorizadosApi();
          }

          break;
        case "2":
          mensaje.mensajeConError(mensaje: Mensaje.errorDeEliminacion);
      }
    } else {
      mensaje.mensajeConError(mensaje: Mensaje.errorDeEliminacion);
    }
  }

  Future<void> buscarDni(
      {TextEditingController controllerContrasenia,
      TextEditingController controllerNombre,
      TextEditingController controllerApellidos,
      TextEditingController controllerFechaNacimiento,
      TextEditingController controllerSexo,
      TextEditingController controllerUsuario,
      String dni}) async {
    if (dni.length < 8) {
      mensaje.mensajeConError(mensaje: Mensaje.falta_ingresar_dni);
      return;
    }

    this.cargando.value = true;

    dynamic r1 = await _motorizadoRepository.estaRegistradoDni(dni: dni);

    if (r1 != null) {
      switch (r1['estado']) {
        case "1":
          controllerApellidos.text = "";
          controllerNombre.text = "";
          controllerSexo.text = "";
          controllerFechaNacimiento.text = "";
          this.cargando.value = false;
          mensaje.mensajeConError(mensaje: Mensaje.error_dni_ya_registrado);

          break;
        case "2":
          dynamic response = await _motorizadoRepository.buscarDni(dni: dni);

          if (response != null) {
            switch (response['estado']) {
              case "1":
                controllerApellidos.text = Utilidades.generarPrimeraMayuscula(
                    palabra: response['paterno'] + " " + response['materno']);
                controllerNombre.text = Utilidades.generarPrimeraMayuscula(
                    palabra: response['nombre']);
                controllerSexo.text = Utilidades.generarPrimeraMayuscula(
                    palabra: response['sexo']);
                controllerFechaNacimiento.text = response['nacimiento'];

                controllerUsuario.text = Utilidades.generarUsuaerio(
                    apellidos: response['paterno'], nombre: response['nombre']);
                controllerContrasenia.text = Utilidades.generarContrasenia(
                    usuario: controllerUsuario.text);
                this.cargando.value = false;
                break;
              case "2":
                controllerApellidos.text = "";
                controllerNombre.text = "";
                controllerSexo.text = "";
                controllerFechaNacimiento.text = "";
                this.cargando.value = false;
                mensaje.mensajeConError(mensaje: Mensaje.error_dni_incorrecto);

                break;
            }
          } else {
            this.cargando.value = false;
            mensaje.mensajeConError(mensaje: Mensaje.errorDeConsulta);
          }
          break;
      }
    } else {
      this.cargando.value = false;
      mensaje.mensajeConError(mensaje: Mensaje.errorDeConsulta);
    }
  }

  goToActualizar({ZonaMotorizado zonaMotorizado}) {
    this.cargando.value = true;
    Future.delayed(Duration(seconds: 1))
        .then((_) => Get.to(EditarScallfol(zonaMotorizado: zonaMotorizado)));
  }

  goToAgregar() {
    this.cargando.value = true;
    Future.delayed(Duration(seconds: 1)).then((_) => Get.to(CrearScallfold()));
  }

  int obtenerPosicion(int id) {
    int posicion = -1;
    for (int i = 0; i < listaZonaMotorizado.length; i++) {
      if (listaZonaMotorizado[i].id == id) {
        posicion = i;
      }
    }
    return posicion;
  }

  /* ALMACENAMIENTO LOCA */
  Future<void> setSharedPreferencia(SharedPreferences store) async {
    await _localDistribuidorRepository.setSharedPreference(store);
  }

  Future<void> setZonaMotorizadosLocal() async {
    List<String> spList =
        listaZonaMotorizado.map((e) => json.encode(e.toJson())).toList();
    await _localDistribuidorRepository.setMotorizados(spList);
    return true;
  }

  Future<bool> getZonaMotorizadosLocal() async {
    List<String> spList = await _localDistribuidorRepository.motorizados;
    if (spList != null) {
      listaZonaMotorizado.clear();
      for (int i = 0; i < spList.length; i++) {
        ZonaMotorizado zona = ZonaMotorizado.fromJson(json.decode(spList[i]));
        if (zona != null) {
          listaZonaMotorizado.add(zona);
        }
      }
    }
    return true;
  }
}
