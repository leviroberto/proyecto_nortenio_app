import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:proyect_nortenio_app/data/repositories/local/local_gerente_repository.dart';
import 'package:proyect_nortenio_app/data/repositories/remote/gerente/distribuidor_repository_G.dart';
import 'package:proyect_nortenio_app/utils/mensaje.dart';
import 'package:proyect_nortenio_app/utils/utilidades.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/models/usuario.dart';
import 'local_widgets/crear_scallfold.dart';
import 'local_widgets/editar_scallfoll.dart';

class DistribuidorControllerG extends GetxController {
  RxBool cargando = true.obs;
  RxList<Usuario> listaDistribuidores = List<Usuario>().obs;

  Mensaje mensaje;

  final DistribuidorRepositoryG _distribuidorRepository =
      Get.find<DistribuidorRepositoryG>();

  final LocalGerenteRepository _localGerenteRepository =
      Get.find<LocalGerenteRepository>();

//cabios de textos

  @override
  void onInit() {
    mensaje = new Mensaje();
    super.onInit();
  }

  Future<bool> getDistribuidoresApi() async {
    this.cargando.value = true;

    dynamic response = await _distribuidorRepository.distribuidores();
    this.cargando.value = false;
    if (response != null) {
      listaDistribuidores.clear();
      dynamic lista = response['usuarios'];
      for (int i = 0; i < lista.length; i++) {
        dynamic aux = lista[i];
        if (aux != null) {
          Usuario distribuidor = Usuario.fromJson(lista[i]);
          listaDistribuidores.add(distribuidor);
        }
      }
      this.setDistribuidoresLocal();
      return true;
    } else {
      mensaje.mensajeConError(mensaje: Mensaje.errorDeConsulta);
      return false;
    }
  }

  Future<bool> registrar(
      {Usuario distribuidor,
      RoundedLoadingButtonController btnControllerRegistrar}) async {
    this.cargando.value = true;

    dynamic response =
        await _distribuidorRepository.registrar(usuario: distribuidor);
    this.cargando.value = false;
    btnControllerRegistrar.reset();
    if (response != null) {
      dynamic estado = response['estado'];
      switch (estado) {
        case "1":
          Usuario distribuidorAux = distribuidor.copyWith(id: response["id"]);
          this.listaDistribuidores.add(distribuidorAux);
          this.setDistribuidoresLocal();
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
      {Usuario distribuidor,
      RoundedLoadingButtonController btnControllerRegistrar}) async {
    this.cargando.value = true;

    dynamic response =
        await _distribuidorRepository.actualizar(usuario: distribuidor);
    this.cargando.value = false;
    btnControllerRegistrar.reset();
    if (response != null) {
      dynamic estado = response['estado'];
      switch (estado) {
        case "1":
          this.getDistribuidoresApi();
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
      mensaje.mensajeConError(mensaje: Mensaje.errorDeActualizacion);
      return false;
    }
    return false;
  }

  Future<void> eliminar({int id}) async {
    this.cargando.value = true;

    dynamic response = await _distribuidorRepository.eliminar(id: id);
    this.cargando.value = false;
    if (response != null) {
      dynamic estado = response['estado'];
      switch (estado) {
        case "1":
          mensaje.mensajeCorrecto(mensaje: Mensaje.afirmacionDeEliminacion);
          int posicion = obtenerPosicion(id);
          if (posicion != -1) {
            this.listaDistribuidores.removeAt(posicion);
            this.setDistribuidoresLocal();
          } else {
            this.getDistribuidoresApi();
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

    dynamic r1 = await _distribuidorRepository.estaRegistradoDni(dni: dni);

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
          this.cargando.value = true;
          dynamic response = await _distribuidorRepository.buscarDni(dni: dni);

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

  goToActualizar({Usuario distribuidor}) {
    this.cargando.value = true;
    Future.delayed(Duration(microseconds: 100))
        .then((_) => Get.to(EditarScallfol(distribuidor: distribuidor)));
  }

  goToAgregar() {
    this.cargando.value = true;
    Future.delayed(Duration(seconds: 1)).then((_) => Get.to(CrearScallfold()));
  }

  int obtenerPosicion(int id) {
    int posicion = -1;
    for (int i = 0; i < listaDistribuidores.length; i++) {
      if (listaDistribuidores[i].id == id) {
        posicion = i;
      }
    }
    return posicion;
  }

  /* ALMACENAMIENTO LOCA */
  Future<void> setSharedPreferencia(SharedPreferences store) async {
    await _localGerenteRepository.setSharedPreference(store);
  }

  Future<void> setDistribuidoresLocal() async {
    ordenarLista();
    List<String> spList =
        listaDistribuidores.map((e) => json.encode(e.toJson())).toList();
    await _localGerenteRepository.setDistribuidores(spList);
    return true;
  }

  Future<bool> getDistribuidoresLocal() async {
    this.cargando.value = true;
    List<String> spList = await _localGerenteRepository.distribuidores;
    if (spList != null) {
      listaDistribuidores.clear();
      for (int i = 0; i < spList.length; i++) {
        Usuario zona = Usuario.fromJson(json.decode(spList[i]));
        if (zona != null) {
          listaDistribuidores.add(zona);
        }
      }
    }
    this.cargando.value = false;

    return true;
  }

  //METODOS

  void ordenarLista() {
    listaDistribuidores.sort((a, b) => b.id.compareTo(a.id));
  }
}
