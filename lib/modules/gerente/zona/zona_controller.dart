import 'dart:convert';

import 'package:get/get.dart';
import 'package:proyect_nortenio_app/data/models/usuario.dart';
import 'package:proyect_nortenio_app/data/models/zona.dart';
import 'package:proyect_nortenio_app/data/repositories/local/local_gerente_repository.dart';
import 'package:proyect_nortenio_app/data/repositories/local/local_auth_repository.dart';
import 'package:proyect_nortenio_app/data/repositories/remote/gerente/zona_repository_G.dart';
import 'package:proyect_nortenio_app/utils/mensaje.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'local_widgets/crear_scallfold.dart';
import 'local_widgets/editar_scallfolld.dart';

class ZonaControllerG extends GetxController {
  RxBool cargando = true.obs;
  RxList<Zona> listaZonas = List<Zona>().obs;
  RxList<Usuario> listaDistribuidores = List<Usuario>().obs;

  Mensaje mensaje;
  final LocalAuthRepository _localAuthRepository =
      Get.find<LocalAuthRepository>();

  final LocalGerenteRepository _localGerenteRepository =
      Get.find<LocalGerenteRepository>();
  final ZonaRepositoryG _zonaRepository = Get.find<ZonaRepositoryG>();
  @override
  void onInit() {
    super.onInit();
    mensaje = new Mensaje();
  }

  Future<bool> getZonaApi() async {
    this.cargando.value = true;
    int pagina = this.listaZonas.length + 10;
    dynamic response = await _zonaRepository.zonas(pagina: pagina);

    if (response != null) {
      listaZonas.clear();
      dynamic lista = response['zonas'];
      for (int i = 0; i < lista.length; i++) {
        dynamic aux = lista[i];
        if (aux != null) {
          Zona motirizado = Zona.fromJson(lista[i]);
          listaZonas.add(motirizado);
        }
      }
      this.cargando.value = false;
      this.setZonasLocal();
      return true;
    } else {
      this.cargando.value = false;
      mensaje.mensajeConError(mensaje: Mensaje.errorDeConsulta);
      return false;
    }
  }

  Future<bool> distribuidores() async {
    this.cargando.value = true;
    this.listaDistribuidores.clear();

    dynamic response = await _zonaRepository.distribuidores();
    this.cargando.value = false;
    if (response != null) {
      dynamic responseDistri = response['distribuidores'];
      for (int i = 0; i < responseDistri.length; i++) {
        dynamic aux = responseDistri[i];
        if (aux != null) {
          Usuario distribuidor = Usuario.fromJson(responseDistri[i]);
          this.listaDistribuidores.add(distribuidor);
        }
      }
      return true;
    } else {
      mensaje.mensajeConError(mensaje: Mensaje.errorDeConsulta);
    }
    return true;
  }

  Future<bool> registrar(
      {Zona zona,
      RoundedLoadingButtonController btnControllerRegistrar}) async {
    this.cargando.value = true;

    Zona zonaUx = zona.copyWith(usuario: await _localAuthRepository.session);

    dynamic response = await _zonaRepository.registrar(zona: zonaUx);
    this.cargando.value = false;
    btnControllerRegistrar.reset();
    if (response != null) {
      dynamic estado = response['estado'];
      switch (estado) {
        case "1":
          Zona zonaAux = zonaUx.copyWith(id: response["id"]);
          this.listaZonas.add(zonaAux);
          this.setZonasLocal();
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
      {Zona zona,
      RoundedLoadingButtonController btnControllerRegistrar}) async {
    this.cargando.value = true;

    Zona zonaUx = zona.copyWith(usuario: await _localAuthRepository.session);

    dynamic response = await _zonaRepository.actualizar(zona: zonaUx);
    this.cargando.value = false;
    btnControllerRegistrar.reset();
    if (response != null) {
      dynamic estado = response['estado'];
      switch (estado) {
        case "1":
          this.getZonaApi();
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
    dynamic response = await _zonaRepository.eliminar(id: id);
    this.cargando.value = false;
    if (response != null) {
      dynamic estado = response['estado'];
      switch (estado) {
        case "1":
          mensaje.mensajeCorrecto(mensaje: Mensaje.afirmacionDeEliminacion);
          int posicion = obtenerPosicion(id);
          if (posicion != -1) {
            this.listaZonas.removeAt(posicion);
            this.setZonasLocal();
          } else {
            this.getZonaApi();
          }

          break;
        case "2":
          mensaje.mensajeConError(mensaje: Mensaje.errorDeEliminacion);
      }
    } else {
      mensaje.mensajeConError(mensaje: Mensaje.errorDeEliminacion);
    }
  }

  goToActualizar({Zona zona}) {
    this.cargando.value = true;
    Future.delayed(Duration(seconds: 1)).then((_) => Get.to(EditarScallfold(
          zona: zona,
        )));
  }

  goToAgregar() {
    this.cargando.value = true;
    Future.delayed(Duration(seconds: 1)).then((_) => Get.to(CrearScallfold()));
  }

  int obtenerPosicion(int id) {
    int posicion = -1;
    for (int i = 0; i < listaZonas.length; i++) {
      if (listaZonas[i].id == id) {
        posicion = i;
      }
    }
    return posicion;
  }

  /* ALMACENAMIENTO LOCA */
  Future<void> setSharedPreferencia(SharedPreferences store) async {
    await _localGerenteRepository.setSharedPreference(store);
  }

  Future<void> setZonasLocal() async {
    ordenarLista();
    List<String> spList =
        listaZonas.map((e) => json.encode(e.toJson())).toList();
    await _localGerenteRepository.setZonas(spList);
    return true;
  }

  Future<bool> getZonaLocal() async {
    this.cargando.value = true;
    List<String> spList = await _localGerenteRepository.zonas;
    if (spList != null) {
      listaZonas.clear();
      for (int i = 0; i < spList.length; i++) {
        Zona zona = Zona.fromJson(json.decode(spList[i]));
        if (zona != null) {
          listaZonas.add(zona);
        }
      }
    }
    this.cargando.value = false;

    return true;
  }

  void ordenarLista() {
    listaZonas.sort((a, b) => b.id.compareTo(a.id));
  }
}
