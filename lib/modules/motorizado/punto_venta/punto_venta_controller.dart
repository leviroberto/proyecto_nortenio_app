import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:proyect_nortenio_app/data/models/geolocalizacion.dart';
import 'package:proyect_nortenio_app/data/models/punto_venta.dart';
import 'package:proyect_nortenio_app/data/models/usuario.dart';
import 'package:proyect_nortenio_app/data/models/zona.dart';
import 'package:proyect_nortenio_app/data/repositories/local/local_auth_repository.dart';
import 'package:proyect_nortenio_app/data/repositories/remote/distribuidor/punto_venta_repository_D.dart';
import 'package:proyect_nortenio_app/utils/mensaje.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import 'local_widgets/crear_scallfold.dart';
import 'local_widgets/editar_scallfolld.dart';

class PuntoVentaControllerM extends GetxController {
  RxBool cargando = false.obs;
  RxList<PuntoVenta> listaPuntoVentas = List<PuntoVenta>().obs;
  RxList<Zona> listaZonas = List<Zona>().obs;
  RxList<Usuario> listaDistribuidores = List<Usuario>().obs;
  RxList<Usuario> listaMotorizados = List<Usuario>().obs;
  Rx<PuntoVenta> puntoVentaEditar = PuntoVenta().obs;

  RxList<String> listaProvincias = List<String>().obs;
  RxList<String> listaDistritos = List<String>().obs;
  Rx<Zona> zona = new Zona().obs;
  Usuario distribuidor;

  Mensaje mensaje;
  final LocalAuthRepository _localAuthRepository =
      Get.find<LocalAuthRepository>();
  final PuntoVentaRepositoryD _puntoVentaRepository =
      Get.find<PuntoVentaRepositoryD>();
  @override
  void onInit() {
    super.onInit();
    mensaje = new Mensaje();
    _init();
  }

  _init() async {}

  void setPuntoVentaEditar({PuntoVenta puntoVenta}) {
    this.puntoVentaEditar.value = puntoVenta;
  }

  Future<bool> cargarLista() async {
    this.cargando.value = true;
    listaPuntoVentas.clear();
    if (zona.isNull) {
      mensaje.mensajeConError(mensaje: Mensaje.errorDeConsulta);
    }

    dynamic response =
        await _puntoVentaRepository.puntoVentasPorZona(zona: zona.value.id);
    this.cargando.value = false;
    if (response != null) {
      dynamic lista = response['puntoVentas'];
      for (int i = 0; i < lista.length; i++) {
        dynamic aux = lista[i];
        if (aux != null) {
          PuntoVenta motirizado = PuntoVenta.fromJson(lista[i]);
          listaPuntoVentas.add(motirizado);
        }
      }
    } else {
      mensaje.mensajeConError(mensaje: Mensaje.errorDeConsulta);
    }
    return true;
  }

  Future<bool> obtenerZonaPorDistribuidor() async {
    this.cargando.value = true;
    bool estado = false;
    if (distribuidor.isNull) {
      distribuidor = await _localAuthRepository.session;
    }
    dynamic response = await _puntoVentaRepository.obtenerZonaPorDistribuidor(
        distribuidor: distribuidor.id);
    this.cargando.value = false;
    if (response != null) {
      dynamic lista = response['zona'];
      Zona zonaAux = Zona.fromJson(lista);

      zona = zonaAux.obs;
      estado = true;
    } else {
      mensaje.mensajeConError(mensaje: Mensaje.errorDeConsulta);
    }
    return estado;
  }

  Future<void> cargarListaZonas() async {
    this.cargando.value = true;
    listaZonas.clear();
    dynamic response = await _puntoVentaRepository.zonas();
    this.cargando.value = false;
    if (response != null) {
      dynamic lista = response['zonas'];
      for (int i = 0; i < lista.length; i++) {
        dynamic aux = lista[i];
        if (aux != null) {
          Zona zona = Zona.fromJson(lista[i]);
          listaZonas.add(zona);
        }
      }
    } else {
      mensaje.mensajeConError(mensaje: Mensaje.errorDeConsulta);
    }
  }

  Future<void> cargarProvincias({String departamento}) async {
    this.listaProvincias.clear();
    this.cargando.value = true;
    dynamic response =
        await _puntoVentaRepository.provincias(departamento: departamento);
    this.cargando.value = false;

    if (response != null) {
      dynamic lista = response['provincia'];
      for (int i = 0; i < lista.length; i++) {
        dynamic aux = lista[i];
        if (aux != null) {
          listaProvincias.add(aux);
        }
      }
    } else {
      mensaje.mensajeConError(mensaje: Mensaje.errorDeConsulta);
    }
  }

  Future<void> cargarDistritos({int provincia}) async {
    this.cargando.value = true;
    this.listaDistritos.clear();
    dynamic response =
        await _puntoVentaRepository.distritos(provincia: provincia);
    this.cargando.value = false;
    if (response != null) {
      dynamic lista = response['distrito'];
      for (int i = 0; i < lista.length; i++) {
        dynamic aux = lista[i];
        if (aux != null) {
          listaDistritos.add(aux);
        }
      }
    } else {
      mensaje.mensajeConError(mensaje: Mensaje.errorDeConsulta);
    }
  }

  Future<bool> registrar({
    PuntoVenta puntoVenta,
    RoundedLoadingButtonController btnControllerRegistrar,
  }) async {
    this.cargando.value = true;

    PuntoVenta puntoVentaAux =
        puntoVenta.copyWith(usuario: await _localAuthRepository.session);

    dynamic response =
        await _puntoVentaRepository.registrar(puntoVenta: puntoVentaAux);
    this.cargando.value = false;
    btnControllerRegistrar.reset();
    if (response != null) {
      dynamic estado = response['estado'];
      switch (estado) {
        case "1":
          Geolocalizacion geolocalizacion =
              Geolocalizacion.fromJson(response["geolocalizacion"]);
          PuntoVenta zonaAux = puntoVentaAux.copyWith(
              id: response["id"], geolocalizacion: geolocalizacion);
          this.listaPuntoVentas.add(zonaAux);
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
      {PuntoVenta puntoVenta,
      RoundedLoadingButtonController btnControllerRegistrar}) async {
    this.cargando.value = true;

    PuntoVenta puntoVentaAux =
        puntoVenta.copyWith(usuario: await _localAuthRepository.session);

    dynamic response =
        await _puntoVentaRepository.actualizar(puntoVenta: puntoVentaAux);
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
    dynamic response = await _puntoVentaRepository.eliminar(id: id);
    this.cargando.value = false;
    if (response != null) {
      dynamic estado = response['estado'];
      switch (estado) {
        case "1":
          mensaje.mensajeCorrecto(mensaje: Mensaje.afirmacionDeEliminacion);
          int posicion = obtenerPosicion(id);
          if (posicion != -1) {
            this.listaPuntoVentas.removeAt(posicion);
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

  goToActualizar({PuntoVenta puntoVenta}) {
    this.cargando.value = true;
    Future.delayed(Duration(seconds: 1)).then((_) => Get.to(
          EditarScallfold(
            puntoVenta: puntoVenta,
          ),
        ));
  }

  goToAgregar() {
    this.cargando.value = true;
    Future.delayed(Duration(seconds: 1)).then((_) => Get.to(CrearScallfold(
          zona: this.zona.value,
        )));
  }

  int obtenerPosicion(int id) {
    int posicion = -1;
    for (int i = 0; i < listaPuntoVentas.length; i++) {
      if (listaPuntoVentas[i].id == id) {
        posicion = i;
      }
    }
    return posicion;
  }

  Future<void> estaRegistradoRuc(
      {String ruc,
      TextEditingController controllerRazonSocial,
      TextEditingController controllerRuc}) async {
    if (ruc.length < 11) {
      mensaje.mensajeConError(mensaje: Mensaje.falta_ingresar_ruc);
      return;
    }
    this.cargando.value = true;
    dynamic response = await _puntoVentaRepository.estaRegistradoRuc(ruc: ruc);
    this.cargando.value = false;
    if (response != null) {
      dynamic estado = response['estado'];
      switch (estado) {
        case "1":
          controllerRazonSocial.text = "";
          controllerRuc.text = "";
          mensaje.mensajeConError(
            mensaje: "El campo ruc ya ha sido registrado",
          );
          controllerRuc.text = ruc;
          controllerRuc.selection = TextSelection.fromPosition(
              TextPosition(offset: controllerRuc.text.length));
          break;
        case "2":
          buscarRuc(
              controllerRazonSocial: controllerRazonSocial,
              controllerRuc: controllerRuc,
              ruc: ruc);
          break;
      }
    } else {
      mensaje.mensajeConError(mensaje: Mensaje.errorDeConsulta);
    }
  }

  Future<void> buscarRuc(
      {String ruc,
      TextEditingController controllerRazonSocial,
      TextEditingController controllerRuc}) async {
    this.cargando.value = true;
    dynamic response = await _puntoVentaRepository.buscarRuc(ruc: ruc);
    this.cargando.value = false;

    if (response != null) {
      controllerRazonSocial.text = response['razon_social'];
      controllerRuc.text = ruc;
      controllerRuc.selection = TextSelection.fromPosition(
          TextPosition(offset: controllerRuc.text.length));
    } else {
      controllerRazonSocial.text = "";
      controllerRuc.text = "";
      mensaje.mensajeConError(mensaje: "El RUC ingresado es incorrecto");
    }
  }

  int buscarPosicionProvincia(String provincia) {
    int prosicion;
    for (int i = 0; i < listaProvincias.length; i++) {
      String aux = listaProvincias[i];
      if (aux == provincia) {
        prosicion = i;
        break;
      }
    }
    return prosicion;
  }

  Future<bool> actualizarGeolocalizacion({
    Geolocalizacion geolocalizacion,
  }) async {
    this.cargando.value = true;

    dynamic response = await _puntoVentaRepository.actualizarGeolocalizacion(
        geolocalizacion: geolocalizacion);
    this.cargando.value = false;

    if (response != null) {
      dynamic estado = response['estado'];
      switch (estado) {
        case "1":
          PuntoVenta puntoVenta = this
              .puntoVentaEditar
              .value
              .copyWith(geolocalizacion: geolocalizacion);
          this.setPuntoVentaEditar(puntoVenta: puntoVenta);
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
}
