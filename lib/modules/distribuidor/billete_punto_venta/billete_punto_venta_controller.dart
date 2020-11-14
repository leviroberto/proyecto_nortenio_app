import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:proyect_nortenio_app/data/models/billete_distribuidor_.dart';
import 'package:proyect_nortenio_app/data/models/billete_punto_venta.dart';
import 'package:proyect_nortenio_app/data/models/configuracion.dart';
import 'package:proyect_nortenio_app/data/models/edicion.dart';
import 'package:proyect_nortenio_app/data/models/punto_venta.dart';
import 'package:proyect_nortenio_app/data/models/usuario.dart';
import 'package:proyect_nortenio_app/data/models/zona.dart';
import 'package:proyect_nortenio_app/data/models/zonaMotorizado.dart';
import 'package:proyect_nortenio_app/data/repositories/local/local_auth_repository.dart';
import 'package:proyect_nortenio_app/data/repositories/local/local_distribuidor_repository.dart';
import 'package:proyect_nortenio_app/data/repositories/remote/billete_punto_venta_repository_D.dart';
import 'package:proyect_nortenio_app/utils/mensaje.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'billete_punto_venta_edicion.dart';
import 'local_widgets/crear_scallfold.dart';
import 'local_widgets/editar_scallfold.dart';

class BilletePuntoVentaControllerD extends GetxController {
  RxBool cargando = true.obs;
  RxList<BilletePuntoVenta> listaBilletesPuntoVenta =
      List<BilletePuntoVenta>().obs;
  RxList<Edicion> listaEdiciones = List<Edicion>().obs;
  RxList<PuntoVenta> listaPuntaVentas = List<PuntoVenta>().obs;
  RxList<ZonaMotorizado> listaMotorizados = List<ZonaMotorizado>().obs;
  Usuario distribuidor;
  Rx<Edicion> edicion = Edicion().obs;
  Rx<Configuracion> configuracion = Configuracion().obs;
  Rx<Zona> zona;
  Mensaje mensaje;
  final BilletePuntoVentaRepositoryD _billetePuntoVentaRepository =
      Get.find<BilletePuntoVentaRepositoryD>();
  final LocalAuthRepository _localAuthRepository =
      Get.find<LocalAuthRepository>();

  final LocalDistribuidorRepository _localDistribuidorRepository =
      Get.find<LocalDistribuidorRepository>();

  @override
  void onInit() {
    super.onInit();
    mensaje = new Mensaje();
  }

  void setEdicion({@required Edicion edicion}) {
    this.edicion.value = edicion;
  }

  Future<bool> getEdicionesApi() async {
    this.cargando.value = true;
    if (zona == null) {
      zona = new Zona().obs;
      zona.value = await _localAuthRepository.zona;
    }
    dynamic response = await _billetePuntoVentaRepository.ediciones();
    this.cargando.value = false;
    if (response != null) {
      listaEdiciones.clear();
      dynamic lista = response['ediciones'];
      for (int i = 0; i < lista.length; i++) {
        dynamic aux = lista[i];
        if (aux != null) {
          Edicion edicion = Edicion.fromJson(aux);
          listaEdiciones.add(edicion);
        }
      }
      this.setEdicionesLocal();
    } else {
      mensaje.mensajeConError(mensaje: Mensaje.errorDeConsulta);
    }
    return true;
  }

  Future<bool> cargarListaPuntoVentas({@required Edicion edicion}) async {
    this.cargando.value = true;
    listaPuntaVentas.clear();
    if (zona == null) {
      zona = new Zona().obs;
      zona.value = await _localAuthRepository.zona;
    }
    dynamic response = await _billetePuntoVentaRepository.puntoVentas(
        zona: zona.value.id, edicion: edicion.id);
    this.cargando.value = false;
    if (response != null) {
      dynamic lista = response['puntoVenta'];
      for (int i = 0; i < lista.length; i++) {
        dynamic aux = lista[i];
        if (aux != null) {
          PuntoVenta puntoVenta = PuntoVenta.fromJson(aux);
          listaPuntaVentas.add(puntoVenta);
        }
      }
      return true;
    } else {
      mensaje.mensajeConError(mensaje: Mensaje.errorDeConsulta);
      return false;
    }
  }

  Future<bool> cargarListaMotorizados({@required Edicion edicion}) async {
    this.cargando.value = true;
    listaMotorizados.clear();
    if (zona == null) {
      zona.value = await _localAuthRepository.zona;
    }

    dynamic response =
        await _billetePuntoVentaRepository.motorizados(zona: zona.value.id);
    this.cargando.value = false;
    if (response != null) {
      dynamic lista = response['zonaMotorizado'];
      for (int i = 0; i < lista.length; i++) {
        dynamic aux = lista[i];
        if (aux != null) {
          ZonaMotorizado zonaMotorizado = ZonaMotorizado.fromJson(aux);
          listaMotorizados.add(zonaMotorizado);
        }
      }
      return true;
    } else {
      mensaje.mensajeConError(mensaje: Mensaje.errorDeConsulta);
      return false;
    }
  }

  Future<BilleteDistribuidor> billetePorEdicion(
      {@required Edicion edicion}) async {
    this.cargando.value = true;

    dynamic response = await _billetePuntoVentaRepository.billetePorEdicion(
        edicion: edicion.id);
    this.cargando.value = false;
    if (response != null) {
      dynamic data = response['billete'];
      BilleteDistribuidor billete = BilleteDistribuidor.fromJson(data);
      if (billete != null) {
        return billete;
      } else {
        this.cargando.value = false;
        mensaje.mensajeConError(mensaje: Mensaje.errorDeConsulta);
      }
    } else {
      this.cargando.value = false;
      mensaje.mensajeConError(mensaje: Mensaje.errorDeConsulta);
    }
    return null;
  }

  Future<bool> cargarConfiguracion() async {
    this.cargando.value = true;
    this.configuracion.value = null;
    dynamic response = await _billetePuntoVentaRepository.configuracion();
    this.cargando.value = false;
    if (response != null) {
      dynamic lista = response['configuracion'];
      Configuracion configuracionAux = Configuracion.fromJson(lista);
      this.configuracion.value = configuracionAux;
      return true;
    } else {
      mensaje.mensajeConError(mensaje: Mensaje.errorDeConsulta);
      return false;
    }
  }

  Future<bool> listaBilletePuntoVentaPorEdicion() async {
    this.cargando.value = true;
    listaBilletesPuntoVenta.clear();
    dynamic response =
        await _billetePuntoVentaRepository.billetePuntoVentaPorEdicion(
            edicion: edicion.value.id, zona: zona.value.id);
    this.cargando.value = false;
    if (response != null) {
      dynamic lista = response['billetePuntoVenta'];
      for (int i = 0; i < lista.length; i++) {
        dynamic aux = lista[i];
        if (aux != null) {
          BilletePuntoVenta puntoVenta = BilletePuntoVenta.fromJson(aux);
          listaBilletesPuntoVenta.add(puntoVenta);
        }
      }
    } else {
      mensaje.mensajeConError(mensaje: Mensaje.errorDeConsulta);
    }
    return true;
  }

  goToBilletesPorPuntoVenta({Edicion edicion}) async {
    this.cargando.value = true;
    Future.delayed(Duration(seconds: 1))
        .then((_) => Get.to(BilletePuntoVentaPorEdicion(edicion: edicion)));
  }

  int obtenerPosicion(int id) {
    int posicion = -1;
    for (int i = 0; i < listaBilletesPuntoVenta.length; i++) {
      if (listaBilletesPuntoVenta[i].id == id) {
        posicion = i;
      }
    }
    return posicion;
  }

  Future<void> eliminar({int id}) async {
    this.cargando.value = true;
    dynamic response = await _billetePuntoVentaRepository.eliminar(id: id);
    this.cargando.value = false;
    if (response != null) {
      dynamic estado = response['estado'];
      switch (estado) {
        case "1":
          mensaje.mensajeCorrecto(mensaje: Mensaje.afirmacionDeEliminacion);
          int posicion = obtenerPosicion(id);
          if (posicion != -1) {
            this.listaBilletesPuntoVenta.removeAt(posicion);
          } else {
            this.listaBilletePuntoVentaPorEdicion();
          }

          break;
        case "2":
          mensaje.mensajeConError(mensaje: Mensaje.errorDeEliminacion);
      }
    } else {
      mensaje.mensajeConError(mensaje: Mensaje.errorDeEliminacion);
    }
  }

  Future<bool> registrar({
    BilletePuntoVenta billetePuntoVenta,
    RoundedLoadingButtonController btnControllerRegistrar,
  }) async {
    this.cargando.value = true;

    BilletePuntoVenta puntoVentaAux =
        billetePuntoVenta.copyWith(usuario: await _localAuthRepository.session);

    dynamic response = await _billetePuntoVentaRepository.registrar(
        billetePuntoVenta: puntoVentaAux);
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
          enviarNotificacion(billetePuntoVenta);
          BilletePuntoVenta zonaAux =
              puntoVentaAux.copyWith(id: response["id"]);
          this.listaBilletesPuntoVenta.add(zonaAux);
          return true;
          break;
        case "2":
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

  void enviarNotificacion(BilletePuntoVenta billetePuntoVenta) async {
    String body = "Se le acaba de asignar " +
        billetePuntoVenta.calcularTotalBoletos() +
        " billetes al punto de venta  " +
        billetePuntoVenta.puntoVenta.razonSocial +
        " para la edición " +
        billetePuntoVenta.edicion.numero;

    await _billetePuntoVentaRepository.enviarNotificacion(
        body: body,
        titulo: "Billete semanal ED" + billetePuntoVenta.edicion.numero,
        token: billetePuntoVenta.zonaMotorizado.motorizado.token,
        tipo: toJson(edicion: billetePuntoVenta.edicion.id.toString()));
  }

  Map<String, dynamic> toJson({String edicion}) {
    return {
      'edicion': edicion,
      'opcion': "BILLETE_PUNTO_VENTA_MOTORIZADO",
    };
  }

  Future<bool> actualizar(
      {BilletePuntoVenta billetePuntoVenta,
      RoundedLoadingButtonController btnControllerRegistrar}) async {
    this.cargando.value = true;

    dynamic response = await _billetePuntoVentaRepository.actualizar(
        billetePuntoVenta: billetePuntoVenta);
    this.cargando.value = false;
    btnControllerRegistrar.reset();
    if (response != null) {
      dynamic estado = response['estado'];
      switch (estado) {
        case "1":
          this.listaBilletePuntoVentaPorEdicion();
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

  goToAgregar() {
    this.cargando.value = true;
    Future.delayed(Duration(seconds: 1)).then((_) => Get.to(CrearScallfold(
          edicion: this.edicion.value,
        )));
  }

  goToActualizar({@required BilletePuntoVenta billetePuntoVenta}) {
    this.cargando.value = true;
    Future.delayed(Duration(seconds: 1)).then((_) => Get.to(EditarScallfold(
          billetePuntoVenta: billetePuntoVenta,
        )));
  }

  /* ALMACENAMIENTO LOCA */
  Future<void> setSharedPreferencia(SharedPreferences store) async {
    await _localDistribuidorRepository.setSharedPreference(store);
  }

  Future<void> setEdicionesLocal() async {
    List<String> spList =
        listaEdiciones.map((e) => json.encode(e.toJson())).toList();
    await _localDistribuidorRepository.setEdiciones(spList);
    return true;
  }

  Future<bool> getEdicionesLocal() async {
    this.cargando.value = true;
    List<String> spList = await _localDistribuidorRepository.ediciones;
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
}
