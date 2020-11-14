import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:proyect_nortenio_app/data/models/billete_distribuidor_.dart';
import 'package:proyect_nortenio_app/data/models/billete_punto_venta.dart';
import 'package:proyect_nortenio_app/data/models/edicion.dart';
import 'package:proyect_nortenio_app/data/repositories/remote/gerente/reporte_repository_G.dart';
import 'package:proyect_nortenio_app/utils/mensaje.dart';

class ReporteControllerg extends GetxController {
  Mensaje mensaje;
  RxBool cargando = true.obs;
  RxBool isSelectedEdicion = false.obs;
  RxList<Edicion> listaEdicion = List<Edicion>().obs;
  RxList<String> listaAnio = List<String>().obs;
  RxList<BilleteDistribuidor> listaBilleteDistribuidor =
      new List<BilleteDistribuidor>().obs;
  final ReporteRepositoryG _reporteRepository = Get.find<ReporteRepositoryG>();
  @override
  void onInit() {
    super.onInit();
    mensaje = new Mensaje();
  }

  agregarAnio({String anio}) {
    this.listaAnio.add(anio);
  }

  Future<bool> cargarListaEdiciones({@required int anio}) async {
    this.cargando.value = true;

    dynamic response = await _reporteRepository.edicionesPorAnio(anio: anio);

    if (response != null) {
      listaEdicion.clear();
      dynamic lista = response['puntoVentas'];
      for (int i = 0; i < lista.length; i++) {
        dynamic aux = lista[i];
        if (aux != null) {
          Edicion edicion = Edicion.fromJson(lista[i]);
          listaEdicion.add(edicion);
        }
      }
    } else {
      mensaje.mensajeConError(mensaje: Mensaje.errorDeConsulta);
    }
    this.cargando.value = false;
    return true;
  }

  Future<bool> cargarListaAnio() async {
    this.cargando.value = true;

    dynamic response = await _reporteRepository.ediciones();

    if (response != null) {
      listaEdicion.clear();
      dynamic lista = response['ediciones'];
      for (int i = 0; i < lista.length; i++) {
        dynamic aux = lista[i];
        if (aux != null) {
          Edicion edicion = Edicion.fromJson(lista[i]);
          listaEdicion.add(edicion);
        }
      }
    } else {
      mensaje.mensajeConError(mensaje: Mensaje.errorDeConsulta);
    }
    this.cargando.value = false;
    return true;
  }

  Future<bool> cargarBilletePuntoVentaPorEdicion({String edicion}) async {
    this.isSelectedEdicion.value = true;
    int id = obtenrIdEdicion(aux: edicion);
    dynamic response =
        await _reporteRepository.cargarBilletePuntoVentaPorEdicion(edicion: id);

    if (response != null) {
      dynamic lista = response['billete'];
      if (lista.length > 0) {
        listaBilleteDistribuidor.clear();
      }
      for (int i = 0; i < lista.length; i++) {
        dynamic aux = lista[i];

        if (aux != null) {
          dynamic listaBillete = aux['billetePuntoVenta'];
          List<BilletePuntoVenta> listaBilletePuntoVenta =
              new List<BilletePuntoVenta>();
          if (listaBillete != null) {
            for (int j = 0; j < listaBillete.length; j++) {
              dynamic billete = listaBillete[j];
              if (billete != null) {
                BilletePuntoVenta billetePuntoVenta =
                    BilletePuntoVenta.fromJson(billete);
                listaBilletePuntoVenta.add(billetePuntoVenta);
              }
            }
          }
          BilleteDistribuidor billeteDistribuidor =
              BilleteDistribuidor.fromJson(aux);
          billeteDistribuidor.setListaBilletePuntoVenta(listaBilletePuntoVenta);
          listaBilleteDistribuidor.add(billeteDistribuidor);
        }
      }
    } else {
      mensaje.mensajeConError(mensaje: Mensaje.errorDeConsulta);
    }
    this.isSelectedEdicion.value = false;
    return true;
  }

  int obtenrIdEdicion({String aux}) {
    int id = -1;
    for (int i = 0; i < listaEdicion.length; i++) {
      Edicion edicion = listaEdicion[i];
      if (edicion.numero == aux) {
        id = edicion.id;
      }
    }
    return id;
  }
}
