import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:proyect_nortenio_app/data/models/billete_punto_venta.dart';
import 'package:proyect_nortenio_app/data/models/conifiguracion_maps.dart';
import 'package:proyect_nortenio_app/data/models/edicion.dart';
import 'package:proyect_nortenio_app/data/models/usuario.dart';
import 'package:proyect_nortenio_app/data/models/zona.dart';
import 'package:proyect_nortenio_app/data/repositories/local/local_auth_repository.dart';
import 'package:proyect_nortenio_app/data/repositories/local/local_gerente_repository.dart';
import 'package:proyect_nortenio_app/data/repositories/remote/gerente/maps_repository_g.dart';
import 'package:proyect_nortenio_app/utils/mensaje.dart';
import 'package:proyect_nortenio_app/utils/utilidades.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MapsControllerM extends GetxController {
  Mensaje mensaje;
  RxBool cargando = true.obs;
  RxBool isSelectedEdicion = false.obs;
  RxString mesSeleccionado = "".obs;
  RxString anioSeleccionado = "".obs;
  RxString edicionSeleccionado = "".obs;
  Rx<Zona> zonaSeleccionado;
  Rx<Usuario> usuario;
  RxList<Edicion> ediciones = List<Edicion>().obs;
  RxList<Zona> zonas = List<Zona>().obs;

  RxList<String> listaMes = List<String>().obs;
  RxList<String> listaAnio = List<String>().obs;
  RxList<String> listaEdiciones = List<String>().obs;
  RxList<String> listaZonas = List<String>().obs;

  RxList<BilletePuntoVenta> listaBilletePuntoVenta =
      List<BilletePuntoVenta>().obs;

  RxList<BilletePuntoVenta> listaBilletePuntoVentaFilter =
      List<BilletePuntoVenta>().obs;

  final LocalAuthRepository _localAuthRepository =
      Get.find<LocalAuthRepository>();

  final LocalGerenteRepository _localTodoRepository =
      Get.find<LocalGerenteRepository>();

  final MapsRepositoryG _mapsRepository = Get.find<MapsRepositoryG>();
  @override
  void onInit() {
    super.onInit();
    mensaje = new Mensaje();
  }

  setListaMes(List<String> lista) {
    this.listaMes.value = lista;
  }

  setListaEdiciones(List<String> lista) {
    this.listaEdiciones.value = lista;
  }

  setMes(String mes) {
    this.mesSeleccionado.value = mes;
  }

  setAnio(String anio) {
    this.anioSeleccionado.value = anio;
  }

  setEdicion(String edicion) {
    this.edicionSeleccionado.value = edicion;
  }

  setVolverNormalBilletes() {
    this.listaBilletePuntoVenta = this.listaBilletePuntoVentaFilter;
  }

  Future<bool> guardarConfiguracionMaps(
      {@required ConfiguracionMap configuracionMap}) async {
    await _localAuthRepository.setConfiguracionMap(configuracionMap);
    return true;
  }

  Future<ConfiguracionMap> configuracionMap() async {
    return await _localAuthRepository.configuracionMap;
  }

  Future<bool> cargarEdiciones() async {
    this.cargando.value = true;
    dynamic response = await _mapsRepository.ediciones();
    if (response != null) {
      ediciones.clear();
      dynamic lista = response['ediciones'];
      for (int i = 0; i < lista.length; i++) {
        dynamic aux = lista[i];
        if (aux != null) {
          Edicion edicion = Edicion.fromJson(lista[i]);
          ediciones.add(edicion);
        }
      }
      this.cargando.value = false;
      /*  this.setEdicionLocal(lista: ediciones); */
      return true;
    } else {
      this.cargando.value = false;
      mensaje.mensajeConError(mensaje: Mensaje.errorDeConsulta);
      return false;
    }
  }

  Future<bool> billetePuntoVentaPorEdicion({@required String edicion}) async {
    this.cargando.value = true;
    this.isSelectedEdicion.value = true;
    listaBilletePuntoVenta.clear();
    this.cargando.value = true;
    if (zonaSeleccionado == null) {
      zonaSeleccionado = new Zona().obs;
      zonaSeleccionado.value = await _localAuthRepository.zona;
    }

    if (usuario == null) {
      usuario = new Usuario().obs;
      usuario.value = await _localAuthRepository.session;
    }
    int edicionId = obtenrIdEdicion(aux: edicion);
    dynamic response = await _mapsRepository.billetePuntoVentaPorEdicion(
        edicion: edicionId, zona: zonaSeleccionado.value.id);

    if (response != null) {
      dynamic lista = response['billete'];

      for (int i = 0; i < lista.length; i++) {
        dynamic aux = lista[i];
        if (aux != null) {
          BilletePuntoVenta billetePuntoVenta = BilletePuntoVenta.fromJson(aux);
          if (billetePuntoVenta.zonaMotorizado.motorizado.id ==
              usuario.value.id) {
            listaBilletePuntoVenta.add(billetePuntoVenta);
          }
        }
      }
      this.isSelectedEdicion.value = false;
      this.cargando.value = true;

      return true;
    } else {
      mensaje.mensajeConError(mensaje: Mensaje.errorDeConsulta);
      this.isSelectedEdicion.value = false;
      this.cargando.value = true;

      return false;
    }
  }

  int obtenrIdEdicion({String aux}) {
    int id = -1;
    for (int i = 0; i < ediciones.length; i++) {
      Edicion edicion = ediciones[i];
      if (edicion.numero == aux) {
        id = edicion.id;
      }
    }
    return id;
  }

  int obtenrIdZona({String aux}) {
    int id = -1;
    for (int i = 0; i < zonas.length; i++) {
      Zona zona = zonas[i];
      if (zona.zona == aux) {
        id = zona.id;
      }
    }
    return id;
  }

  void eliminarElementoListaBillete({int position}) {
    this.listaBilletePuntoVenta.removeAt(position);
  }

  void generarListaAnios() {
    this.listaAnio.value = Utilidades.generaListaAnios(ediciones);
  }

  void generarListaZonas() {
    this.listaZonas.clear();
    this.zonas.forEach((zona) {
      if (zona != null) {
        this.listaZonas.add(zona.zona);
      }
    });
  }

  ////LOCAL  GUARDAR DATOS

  Future<void> setSharedPreferencia(SharedPreferences store) async {
    await _localTodoRepository.setSharedPreference(store);
  }

  Future<bool> setZonasLocal({@required List<Zona> lista}) async {
    List<String> spList = lista.map((e) => json.encode(e.toJson())).toList();
    await _localTodoRepository.setListaZonasMap(spList);
    return true;
  }

  Future<bool> setEdicionLocal({@required List<Edicion> lista}) async {
    List<String> spList = lista.map((e) => json.encode(e.toJson())).toList();
    await _localTodoRepository.setListaEdicionesMap(spList);
    return true;
  }

  Future<bool> setBilletePuntoVentaLocal(
      {@required List<BilletePuntoVenta> lista}) async {
    List<String> spList = lista.map((e) => json.encode(e.toJson())).toList();
    await _localTodoRepository.setListaBilletePuntoVentaMap(spList);
    return true;
  }

  Future<bool> getZonasLocal() async {
    List<String> spList = await _localTodoRepository.zonasMap;

    if (spList == null) {
      zonas = List<Zona>().obs;
    } else {
      for (int i = 0; i < spList.length; i++) {
        Zona zona = Zona.fromJson(json.decode(spList[i]));
        if (zona != null) {
          zonas.add(zona);
        }
      }
    }
    return true;
  }

  Future<bool> getEdicionesLocal() async {
    dynamic spList = await _localTodoRepository.edicionesMap;

    if (spList == null) {
      ediciones = List<Edicion>().obs;
    } else {
      for (int i = 0; i < spList.length; i++) {
        Edicion edicion = Edicion.fromJson(json.decode(spList[i]));
        if (edicion != null) {
          ediciones.add(edicion);
        }
      }
    }
    return true;
  }

  Future<bool> getBilletePuntoVentaLocal() async {
    List<String> spList = await _localTodoRepository.billetePuntoVentaMap;

    if (spList == null) {
      listaBilletePuntoVenta = List<BilletePuntoVenta>().obs;
    } else {
      for (int i = 0; i < spList.length; i++) {
        BilletePuntoVenta billetePuntoVenta =
            BilletePuntoVenta.fromJson(json.decode(spList[i]));
        if (billetePuntoVenta != null) {
          listaBilletePuntoVenta.add(billetePuntoVenta);
        }
      }
    }
    return true;
  }
}
