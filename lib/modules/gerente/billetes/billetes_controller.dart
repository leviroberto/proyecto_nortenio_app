import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:proyect_nortenio_app/data/models/billete_distribuidor_.dart';
import 'package:proyect_nortenio_app/data/models/edicion.dart';
import 'package:proyect_nortenio_app/data/models/zona.dart';
import 'package:proyect_nortenio_app/data/repositories/local/local_gerente_repository.dart';
import 'package:proyect_nortenio_app/data/repositories/local/local_auth_repository.dart';
import 'package:proyect_nortenio_app/data/repositories/remote/gerente/billete_distribuidor_repository_G.dart';
import 'package:proyect_nortenio_app/utils/mensaje.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'billetes_por_edicion_page.dart';
import 'local_widgets/crear_scallfold.dart';
import 'local_widgets/editar_scallfold.dart';

class BilletesControllerG extends GetxController {
  RxBool cargando = true.obs;
  RxList<BilleteDistribuidor> listaBilletes = List<BilleteDistribuidor>().obs;
  RxList<Zona> listaZona = List<Zona>().obs;
  RxList<Edicion> listaEdiciones = List<Edicion>().obs;

  Rx<Edicion> edicion = Edicion().obs;
  Mensaje mensaje;
  final BilleteDistribuidorRepositoryG _billeteRepository =
      Get.find<BilleteDistribuidorRepositoryG>();
  final LocalAuthRepository _localAuthRepository =
      Get.find<LocalAuthRepository>();

  final LocalGerenteRepository _localGerenteRepository =
      Get.find<LocalGerenteRepository>();
  @override
  void onInit() {
    super.onInit();
    mensaje = new Mensaje();
  }

  void setEdicion({@required Edicion edicion}) {
    this.edicion.value = edicion;
  }

  Future<bool> cargarLista() async {
    this.cargando.value = true;
    listaBilletes.clear();
    dynamic response =
        await _billeteRepository.billetes(edicion: this.edicion.value.id);
    this.cargando.value = false;
    if (response != null) {
      dynamic lista = response['billetes_distribuidor'];
      for (int i = 0; i < lista.length; i++) {
        dynamic aux = lista[i];
        if (aux != null) {
          BilleteDistribuidor billete = BilleteDistribuidor.fromJson(aux);
          listaBilletes.add(billete);
        }
      }
    } else {
      mensaje.mensajeConError(mensaje: Mensaje.errorDeConsulta);
    }
    return true;
  }

  Future<bool> cargarListaZonas() async {
    this.cargando.value = true;
    listaZona.clear();
    dynamic response =
        await _billeteRepository.zonas(edicion: this.edicion.value.id);
    this.cargando.value = false;
    if (response != null) {
      dynamic lista = response['zonas'];
      for (int i = 0; i < lista.length; i++) {
        dynamic aux = lista[i];
        if (aux != null) {
          Zona zona = Zona.fromJson(aux);
          listaZona.add(zona);
        }
      }
    } else {
      mensaje.mensajeConError(mensaje: Mensaje.errorDeConsulta);
    }
    return true;
  }

  Future<bool> getEdicionesApi() async {
    this.cargando.value = true;
    listaEdiciones.clear();
    dynamic response = await _billeteRepository.ediciones();
    this.cargando.value = false;
    if (response != null) {
      dynamic lista = response['ediciones'];
      for (int i = 0; i < lista.length; i++) {
        dynamic aux = lista[i];
        if (aux != null) {
          Edicion zona = Edicion.fromJson(aux);
          listaEdiciones.add(zona);
        }
      }
      this.setEdicionesLocal();
    } else {
      mensaje.mensajeConError(mensaje: Mensaje.errorDeConsulta);
    }
    return true;
  }

  Future<bool> registrar(
      {BilleteDistribuidor billete,
      RoundedLoadingButtonController btnControllerRegistrar}) async {
    this.cargando.value = true;
    BilleteDistribuidor billeteAux =
        billete.copyWith(usuario: await _localAuthRepository.session);
    dynamic response = await _billeteRepository.registrar(billete: billeteAux);
    this.cargando.value = false;
    btnControllerRegistrar.reset();
    if (response != null) {
      dynamic estado = response['estado'];
      switch (estado) {
        case "1":
          dynamic estadoError = response['error'];
          for (int i = 0; i < estadoError.length; i++) {
            String data = estadoError[i];
            mensaje.mensajeConError(mensaje: data);
            break;
          }
          return false;
          break;
        case "2":
          enviarNotificacion(billeteAux);
          BilleteDistribuidor zonaAux = billeteAux.copyWith(id: response["id"]);
          this.listaBilletes.add(zonaAux);
          return true;
          break;
        case "3":
          mensaje.mensajeConError(mensaje: Mensaje.errorDeCreacion);
          return false;
          break;
      }
    } else {
      mensaje.mensajeConError(mensaje: Mensaje.errorDeCreacion);
      return false;
    }
    return false;
  }

  void enviarNotificacion(BilleteDistribuidor billeteDistribuidor) async {
    String body = "Se le acaba de asignar " +
        billeteDistribuidor.calcularTotalBoletos() +
        " billetes para la edición " +
        billeteDistribuidor.edicion.numero;

    await _billeteRepository.enviarNotificacion(
        body: body,
        titulo: "Billete semanal",
        token: billeteDistribuidor.zona.distribuidor.token,
        tipo: toJson(edicion: billeteDistribuidor.edicion.id.toString()));
  }

  Map<String, dynamic> toJson({String edicion}) {
    return {
      'edicion': edicion,
      'opcion': "BILLETE_DISTRIBUIDOR",
    };
  }

  Future<bool> actualizar(
      {BilleteDistribuidor billete,
      RoundedLoadingButtonController btnControllerRegistrar}) async {
    this.cargando.value = true;

    dynamic response = await _billeteRepository.actualizar(billete: billete);
    this.cargando.value = false;
    btnControllerRegistrar.reset();
    if (response != null) {
      dynamic estado = response['estado'];
      switch (estado) {
        case "1":
          this.cargarLista();
          return true;
          break;
        case "2":
          mensaje.mensajeConError(mensaje: Mensaje.errorDeActualizacion);
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
    dynamic response = await _billeteRepository.eliminar(id: id);
    this.cargando.value = false;
    if (response != null) {
      dynamic estado = response['estado'];
      switch (estado) {
        case "1":
          mensaje.mensajeCorrecto(mensaje: Mensaje.afirmacionDeEliminacion);
          int posicion = obtenerPosicion(id);
          if (posicion != -1) {
            this.listaBilletes.removeAt(posicion);
            this.setEdicionesLocal();
          } else {
            this.cargarLista();
          }

          break;
        case "2":
          mensaje.mensajeConError(mensaje: Mensaje.errorDeEliminacion);
      }
    } else {
      mensaje.mensajeConError(mensaje: Mensaje.errorDeEliminacion);
    }
  }

  goToActualizar({BilleteDistribuidor billete}) {
    this.cargando.value = true;
    Future.delayed(Duration(seconds: 1)).then((_) => Get.to(EditarScallfold(
          billete: billete,
        )));
  }

  goToEdicion({Edicion edicion}) {
    this.cargando.value = true;
    Future.delayed(Duration(seconds: 1))
        .then((_) => Get.to(BilletePorEdicionPage(
              edicion: edicion,
            )));
  }

  goToAgregar() {
    this.cargando.value = true;
    Future.delayed(Duration(seconds: 1)).then((_) => Get.to(CrearScallfold(
          edicion: this.edicion.value,
        )));
  }

  int obtenerPosicion(int id) {
    int posicion = -1;
    for (int i = 0; i < listaBilletes.length; i++) {
      if (listaBilletes[i].id == id) {
        posicion = i;
      }
    }
    return posicion;
  }

  /* ALMACENAMIENTO LOCA */
  Future<void> setSharedPreferencia(SharedPreferences store) async {
    await _localGerenteRepository.setSharedPreference(store);
  }

  Future<void> setEdicionesLocal() async {
    ordenarLista();
    List<String> spList =
        listaEdiciones.map((e) => json.encode(e.toJson())).toList();
    await _localGerenteRepository.setEdiciones(spList);
    return true;
  }

  Future<bool> getEdicionesLocal() async {
    this.cargando.value = true;
    List<String> spList = await _localGerenteRepository.ediciones;
    if (spList != null) {
      listaEdiciones.clear();
      for (int i = 0; i < spList.length; i++) {
        Edicion edicion = Edicion.fromJson(json.decode(spList[i]));
        if (edicion != null) {
          listaEdiciones.add(edicion);
        }
      }
    }
    this.cargando.value = false;

    return true;
  }

  void ordenarLista() {
    listaEdiciones.sort((a, b) => b.id.compareTo(a.id));
  }
}
