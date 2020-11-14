import 'dart:convert';

import 'package:get/get.dart';
import 'package:proyect_nortenio_app/data/models/edicion.dart';
import 'package:proyect_nortenio_app/data/models/notificacion.dart';
import 'package:proyect_nortenio_app/data/models/usuario.dart';
import 'package:proyect_nortenio_app/data/models/zona.dart';
import 'package:proyect_nortenio_app/data/repositories/local/local_auth_repository.dart';
import 'package:proyect_nortenio_app/data/repositories/local/local_motorizado_perfil_repository.dart';
import 'package:proyect_nortenio_app/data/repositories/remote/gerente/principal_repository_G.dart';
import 'package:proyect_nortenio_app/utils/mensaje.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrincipalMotorizadoController extends GetxController {
  Mensaje mensaje;
  RxBool cargando = false.obs;
  RxList<Edicion> listaEdiciones = List<Edicion>().obs;
  RxInt contadorPuntoVentas = 0.obs;
  RxList<Notificacion> listaNotificaciones = List<Notificacion>().obs;
  Rx<Usuario> usuario = new Usuario().obs;
  Rx<Zona> zona = new Zona().obs;
  final LocalAuthRepository _localAuthRepository =
      Get.find<LocalAuthRepository>();
  final PrincipalRepositoryG _principalRepository =
      Get.find<PrincipalRepositoryG>();
  final LocalMotorizadoPerfilRepository _localMotorizadoPerfilRepository =
      Get.find<LocalMotorizadoPerfilRepository>();
  @override
  void onInit() {
    super.onInit();
    mensaje = new Mensaje();
  }

  Future<bool> getUser() async {
    usuario.value = await _localAuthRepository.session;
    return true;
  }

  Future<bool> getContadorPuntoVenta() async {
    this.cargando.value = true;
    if (zona.value.id == null) {
      zona.value = await _localAuthRepository.zona;
    }
    dynamic response =
        await _principalRepository.puntoVentasPorZona(zona: zona.value.id);
    this.cargando.value = false;
    if (response != null) {
      dynamic lista = response['puntoVentas'];
      if (lista != null) {
        this.contadorPuntoVentas.value = lista;
      }
    } else {
      mensaje.mensajeConError(mensaje: Mensaje.errorDeConsulta);
    }
    return true;
  }

  Future<void> agregarNotificacion(Notificacion notificacion) {
    this.listaNotificaciones.add(notificacion);
    this.setNotificacionesLocal();
  }

  Future<bool> getNotificacionesLocal() async {
    this.cargando.value = true;
    List<String> spList = await _localMotorizadoPerfilRepository.notificaciones;
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
    await _localMotorizadoPerfilRepository.setNotificaciones(spList);
    return true;
  }

  Future<void> setSharedPreferencia(SharedPreferences store) async {
    await _localMotorizadoPerfilRepository.setSharedPreference(store);
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
