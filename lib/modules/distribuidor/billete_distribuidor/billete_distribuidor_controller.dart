import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:proyect_nortenio_app/data/models/billete_distribuidor_.dart';
import 'package:proyect_nortenio_app/data/models/billete_punto_venta.dart';
import 'package:proyect_nortenio_app/data/models/edicion.dart';
import 'package:proyect_nortenio_app/data/repositories/local/local_distribuidor_repository.dart';
import 'package:proyect_nortenio_app/data/repositories/remote/gerente/billete_distribuidor_repository_G.dart';
import 'package:proyect_nortenio_app/utils/mensaje.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'local_widgets/editar_scallfold.dart';

class BilleteControllerD extends GetxController {
  RxBool cargando = true.obs;
  RxList<BilleteDistribuidor> listaBilleteDistribuidor =
      List<BilleteDistribuidor>().obs;
  RxList<Edicion> listaEdiciones = List<Edicion>().obs;
  RxList<BilletePuntoVenta> listaBilletePuntoVenta =
      List<BilletePuntoVenta>().obs;
  Mensaje mensaje;
  final BilleteDistribuidorRepositoryG _billeteRepository =
      Get.find<BilleteDistribuidorRepositoryG>();
  final LocalDistribuidorRepository _localDistribuidorRepository =
      Get.find<LocalDistribuidorRepository>();
  @override
  void onInit() {
    super.onInit();
    mensaje = new Mensaje();
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

  Future<bool> cargarListaBilletesDistribuidorPorEdicion(
      {@required Edicion edicion}) async {
    this.cargando.value = true;
    listaBilleteDistribuidor.clear();
    dynamic response = await _billeteRepository.billetesDistribuidorPorEdicion(
        edicion: edicion.id);
    this.cargando.value = false;
    if (response != null) {
      dynamic lista = response['billete'];
      for (int i = 0; i < lista.length; i++) {
        dynamic aux = lista[i];
        if (aux != null) {
          BilleteDistribuidor billeteDistribuidor =
              BilleteDistribuidor.fromJson(aux);
          listaBilleteDistribuidor.add(billeteDistribuidor);
        }
      }
    } else {
      mensaje.mensajeConError(mensaje: Mensaje.errorDeConsulta);
    }
    return true;
  }

  Future<List<BilletePuntoVenta>> cargarListaBilletePuntoVentas(
      {@required BilleteDistribuidor billetePuntoVenta}) async {
    this.cargando.value = true;
    dynamic response = await _billeteRepository.billetePuntoVentas(
        id: billetePuntoVenta.edicion.id);
    this.cargando.value = false;
    List<BilletePuntoVenta> listaPuntoVenta = new List<BilletePuntoVenta>();
    if (response != null) {
      dynamic lista = response['billetePuntoVenta'];
      for (int i = 0; i < lista.length; i++) {
        dynamic aux = lista[i];
        if (aux != null) {
          BilletePuntoVenta billetePuntoVenta = BilletePuntoVenta.fromJson(aux);
          listaPuntoVenta.add(billetePuntoVenta);
        }
      }
    } else {
      mensaje.mensajeConError(mensaje: Mensaje.errorDeConsulta);
    }
    return listaPuntoVenta;
  }

  Future<BilleteDistribuidor> getBilleteDistribuidorPorEdicion({int id}) async {
    dynamic response = await _billeteRepository.billetePorEdicion(edicion: id);
    dynamic data = response['billete'];
    BilleteDistribuidor billete = BilleteDistribuidor.fromJson(data);
    return billete;
  }

  goToVerInformacion({Edicion edicion}) async {
    this.cargando.value = true;

    dynamic response =
        await _billeteRepository.billetePorEdicion(edicion: edicion.id);

    if (response != null) {
      dynamic data = response['billete'];
      BilleteDistribuidor billete = BilleteDistribuidor.fromJson(data);
      if (billete != null) {
        Future.delayed(Duration(seconds: 1)).then((_) => Get.to(EditarScallfold(
              billete: billete,
            )));
      } else {
        this.cargando.value = false;
        mensaje.mensajeConError(mensaje: Mensaje.errorDeConsulta);
      }
    } else {
      this.cargando.value = false;
      mensaje.mensajeConError(mensaje: Mensaje.errorDeConsulta);
    }

    /* */
  }

  goToActualizar({BilleteDistribuidor billeteDistribuidor}) {
    this.cargando.value = true;
    Future.delayed(Duration(seconds: 1)).then((_) => Get.to(EditarScallfold(
          billete: billeteDistribuidor,
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
