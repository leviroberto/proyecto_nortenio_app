import 'dart:convert';

import 'package:get/get.dart';
import 'package:proyect_nortenio_app/data/models/edicion.dart';
import 'package:proyect_nortenio_app/data/models/notificacion.dart';
import 'package:proyect_nortenio_app/data/models/zona.dart';
import 'package:proyect_nortenio_app/data/repositories/local/local_auth_repository.dart';
import 'package:proyect_nortenio_app/data/repositories/local/local_distribuidor_repository.dart';
import 'package:proyect_nortenio_app/data/repositories/remote/distribuidor/punto_venta_repository.dart';
import 'package:proyect_nortenio_app/utils/mensaje.dart';
import 'package:proyect_nortenio_app/utils/util.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrincipalDistribuidorControllerD extends GetxController {
  Mensaje mensaje;
  RxBool cargando = true.obs;
  RxList<Edicion> listaEdiciones = List<Edicion>().obs;
  RxList<Notificacion> listaNotificaciones = List<Notificacion>().obs;
  PrincipalDistribuidorRepository _principalDistribuidorRepository =
      Get.find<PrincipalDistribuidorRepository>();
  RxString totalMotorizados = "0".obs;
  RxString totalPuntoVenta = "0".obs;
  Rx<Zona> zona;
  final LocalAuthRepository _localAuthRepository =
      Get.find<LocalAuthRepository>();

  final LocalDistribuidorRepository _localDistribuidorRepository =
      Get.find<LocalDistribuidorRepository>();
  @override
  void onInit() {
    super.onInit();
    mensaje = new Mensaje();
  }

  Future<bool> getDatosPrincipalApi() async {
    this.cargando.value = true;

    if (zona == null) {
      zona = new Zona().obs;
      zona.value = await _localAuthRepository.zona;
    }

    dynamic response = await _principalDistribuidorRepository.datosPrincipal(
        zona: zona.value.id);

    this.cargando.value = false;
    if (response != null) {
      listaEdiciones.clear();

      dynamic response1 = response['data'];

      dynamic lista = response1['ediciones'];
      for (int i = 0; i < lista.length; i++) {
        dynamic aux = lista[i];
        if (aux != null) {
          Edicion edicion = Edicion.fromJson(lista[i]);
          listaEdiciones.add(edicion);
        }
      }

      dynamic lista1 = response1['total_motorizado'];
      totalMotorizados.value = Util.checkString(lista1);

      dynamic lista2 = response1['total_punto_venta'];
      totalPuntoVenta.value = Util.checkString(lista2);

      return true;
    } else {
      mensaje.mensajeConError(mensaje: Mensaje.errorDeConsulta);
      return true;
    }
  }

  Future<bool> getDatosDistribuidorPrincipal() async {
    this.cargando.value = true;

    dynamic response = await _principalDistribuidorRepository.ediciones();
    this.cargando.value = false;
    if (response != null) {
      listaEdiciones.clear();
      dynamic lista = response['ediciones'];
      for (int i = 0; i < lista.length; i++) {
        dynamic aux = lista[i];
        if (aux != null) {
          Edicion edicion = Edicion.fromJson(lista[i]);
          listaEdiciones.add(edicion);
        }
      }
      return true;
    } else {
      mensaje.mensajeConError(mensaje: Mensaje.errorDeConsulta);
      return true;
    }
  }

  Future<void> agregarNotificacion(Notificacion notificacion) {
    this.listaNotificaciones.add(notificacion);
    this.setNotificacionesLocal();
  }

  Future<bool> getNotificacionesLocal() async {
    this.cargando.value = true;
    List<String> spList = await _localDistribuidorRepository.notificaciones;
    if (spList != null) {
      listaNotificaciones.clear();
      for (int i = 0; i < spList.length; i++) {
        Notificacion notificacion =
            Notificacion.fromJson(json.decode(spList[i]));
        if (notificacion != null) {
          listaNotificaciones.add(notificacion);
        }
      }
    }
    this.cargando.value = false;

    return true;
  }

  Future<void> setNotificacionesLocal() async {
    this.ordenarLista();
    List<String> spList =
        listaNotificaciones.map((e) => json.encode(e.toJson())).toList();
    await _localDistribuidorRepository.setNotificaciones(spList);
    return true;
  }

  Future<void> setSharedPreferencia(SharedPreferences store) async {
    await _localDistribuidorRepository.setSharedPreference(store);
  }

  void ordenarLista() {
    listaNotificaciones.sort((a, b) => b.date.compareTo(a.date));
  }

  void ponerNotificacionesVisto() {
    List<Notificacion> lista = new List<Notificacion>();
    this.listaNotificaciones.forEach((notificacion) {
      Notificacion aux = notificacion.copyWith(estado: 1);
      lista.add(aux);
    });
    this.listaNotificaciones.clear();
    this.listaNotificaciones.value = lista;
    this.setNotificacionesLocal();
  }

  int getNotificacionesActivasCantidad() {
    int contador = 0;
    this.listaNotificaciones.forEach((noti) {
      if (noti.estado == 0) {
        contador = contador + 1;
      }
    });
    return contador;
  }
}
