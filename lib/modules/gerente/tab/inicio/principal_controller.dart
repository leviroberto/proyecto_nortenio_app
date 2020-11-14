import 'dart:convert';

import 'package:get/get.dart';
import 'package:proyect_nortenio_app/data/models/edicion.dart';
import 'package:proyect_nortenio_app/data/models/notificacion.dart';
import 'package:proyect_nortenio_app/data/models/zona.dart';
import 'package:proyect_nortenio_app/data/repositories/local/local_gerente_perfil_repository.dart';
import 'package:proyect_nortenio_app/data/repositories/remote/gerente/principal_repository_G.dart';
import 'package:proyect_nortenio_app/utils/mensaje.dart';
import 'package:proyect_nortenio_app/utils/util.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrincipalGerenteControllerG extends GetxController {
  Mensaje mensaje;
  RxBool cargando = false.obs;
  RxString totalDistribuidores = "0".obs;
  RxString totalZonas = "0".obs;
  RxString totalBilletes = "0".obs;
  RxString totalEdiciones = "0".obs;
  RxString totalPuntoVenta = "0".obs;
  Rx<Edicion> edicionAciva = new Edicion().obs;

  RxList<Edicion> ediciones = List<Edicion>().obs;
  RxList<Zona> zonas = List<Zona>().obs;
  PrincipalRepositoryG _principalRepository = Get.find<PrincipalRepositoryG>();
  LocalGerentePerfilRepository _localGerentePerfilRepository =
      Get.find<LocalGerentePerfilRepository>();
  RxList<Notificacion> listaNotificaciones = List<Notificacion>().obs;
  @override
  void onInit() {
    super.onInit();
    mensaje = new Mensaje();
  }

  Future<bool> cargarListaZonas() async {
    this.cargando.value = true;
    dynamic response = await _principalRepository.zonas();
    if (response != null) {
      zonas.clear();
      dynamic lista = response['zonas'];
      for (int i = 0; i < lista.length; i++) {
        dynamic aux = lista[i];
        if (aux != null) {
          Zona zona = Zona.fromJson(lista[i]);
          zonas.add(zona);
        }
      }
      this.cargando.value = false;
      return true;
    } else {
      mensaje.mensajeConError(mensaje: Mensaje.errorDeConsulta);
      this.cargando.value = false;
      return false;
    }
  }

  Future<bool> cargarListaEdiciones() async {
    this.cargando.value = true;
    dynamic response = await _principalRepository.ediciones();
    if (response != null) {
      ediciones.clear();
      dynamic lista = response['ediciones'];
      for (int i = 0; i < lista.length; i++) {
        dynamic aux = lista[i];
        if (aux != null) {
          Edicion edicion = Edicion.fromJson(lista[i]);
          if (edicion.estado == 1) {
            edicionAciva.value = edicion;
          }
          ediciones.add(edicion);
        }
      }
      this.cargando.value = false;
      return true;
    } else {
      mensaje.mensajeConError(mensaje: Mensaje.errorDeConsulta);
      this.cargando.value = false;
      return false;
    }
  }

  Future<bool> cargarDatosPrincipal() async {
    this.cargando.value = true;
    dynamic response = await _principalRepository.catosPrincipal();
    if (response != null) {
      ediciones.clear();
      dynamic response1 = response['data'];
      dynamic lista1 = response1['total_administradores'];
      totalDistribuidores.value = Util.checkString(lista1);

      dynamic lista2 = response1['total_zonas'];
      totalZonas.value = Util.checkString(lista2);

      dynamic lista3 = response1['total_billetes'];
      totalBilletes.value = Util.checkString(lista3);

      dynamic lista4 = response1['total_ediciones'];
      totalEdiciones.value = Util.checkString(lista4);

      dynamic lista5 = response1['total_puntos_venta'];
      totalPuntoVenta.value = Util.checkString(lista5);

      dynamic lista6 = response1['ediciones_activas'];

      for (int i = 0; i < lista6.length; i++) {
        dynamic aux = lista6[i];
        if (aux != null) {
          Edicion edicion = Edicion.fromJson(aux);
          this.edicionAciva.value = edicion;

          ediciones.add(edicion);
        }
      }

      this.cargando.value = false;
      return true;
    } else {
      mensaje.mensajeConError(mensaje: Mensaje.errorDeConsulta);
      this.cargando.value = false;
      return false;
    }
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

  Future<void> agregarNotificacion(Notificacion notificacion) {
    this.listaNotificaciones.add(notificacion);
    this.setNotificacionesLocal();
  }

  Future<bool> getNotificacionesLocal() async {
    this.cargando.value = true;
    List<String> spList = await _localGerentePerfilRepository.notificaciones;
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
    await _localGerentePerfilRepository.setNotificaciones(spList);
    return true;
  }

  Future<void> setSharedPreferencia(SharedPreferences store) async {
    await _localGerentePerfilRepository.setSharedPreference(store);
  }

  void ordenarLista() {
    listaNotificaciones.sort((a, b) => b.date.compareTo(a.date));
  }
}
