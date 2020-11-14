import 'dart:convert';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:proyect_nortenio_app/data/models/edicion.dart';
import 'package:proyect_nortenio_app/data/repositories/local/local_gerente_repository.dart';
import 'package:proyect_nortenio_app/data/repositories/local/local_auth_repository.dart';
import 'package:proyect_nortenio_app/data/repositories/remote/gerente/edicion_repository_G.dart';
import 'package:proyect_nortenio_app/utils/mensaje.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'local_widgets/crear_scallfold.dart';
import 'local_widgets/editar_scallfold.dart';

class EdicionControllerG extends GetxController {
  RxBool cargando = false.obs;
  RxList<Edicion> listaEdiciones = List<Edicion>().obs;
  final EdicionRepositoryG _edicionRepository = Get.find<EdicionRepositoryG>();

  final LocalAuthRepository _localAuthRepository =
      Get.find<LocalAuthRepository>();

  final LocalGerenteRepository _localGerenteRepository =
      Get.find<LocalGerenteRepository>();
  Mensaje mensaje;
  @override
  void onInit() {
    super.onInit();
    mensaje = new Mensaje();
  }

  Future<bool> getEdicionesApi() async {
    this.cargando.value = true;

    dynamic response = await _edicionRepository.ediciones();

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
      this.cargando.value = false;
      this.setEdicionesLocal();
    } else {
      this.cargando.value = false;
      mensaje.mensajeConError(mensaje: Mensaje.errorDeConsulta);
    }
    return true;
  }

  Future<bool> registrar({
    Edicion edicion,
    RoundedLoadingButtonController btnControllerRegistrar,
  }) async {
    this.cargando.value = true;

    Edicion edicionAux =
        edicion.copyWith(usuario: await _localAuthRepository.session);

    dynamic response = await _edicionRepository.registrar(edicion: edicionAux);
    this.cargando.value = false;
    btnControllerRegistrar.reset();
    if (response != null) {
      dynamic estado = response['estado'];
      switch (estado) {
        case "1":
          mensaje.mensajeConError(mensaje: "Existe una dición activa");
          return false;
          break;
        case "2":
          Edicion zonaAux = edicionAux.copyWith(id: response["id"]);
          this.listaEdiciones.add(zonaAux);
          this.setEdicionesLocal();
          return true;
          break;
        case "3":
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
      {Edicion edicion,
      RoundedLoadingButtonController btnControllerRegistrar}) async {
    this.cargando.value = true;

    dynamic response = await _edicionRepository.actualizar(edicion: edicion);
    this.cargando.value = false;
    btnControllerRegistrar.reset();
    if (response != null) {
      dynamic estado = response['estado'];
      switch (estado) {
        case "1":
          this.getEdicionesApi();
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
    dynamic response = await _edicionRepository.eliminar(id: id);
    this.cargando.value = false;
    if (response != null) {
      dynamic estado = response['estado'];
      switch (estado) {
        case "1":
          mensaje.mensajeCorrecto(mensaje: Mensaje.afirmacionDeEliminacion);
          int posicion = obtenerPosicion(id);
          if (posicion != -1) {
            this.listaEdiciones.removeAt(posicion);
            this.setEdicionesLocal();
          } else {
            this.getEdicionesApi();
          }

          break;
        case "2":
          mensaje.mensajeConError(mensaje: Mensaje.errorDeEliminacion);
      }
    } else {
      mensaje.mensajeConError(mensaje: Mensaje.errorDeEliminacion);
    }
  }

  Future<int> ultimaEdicion() async {
    this.cargando.value = true;
    int mayor = 1;
    for (int i = 0; i < listaEdiciones.length; i++) {
      int numero = int.parse(listaEdiciones[i].numero);
      if (numero > mayor) {
        mayor = numero;
      }
    }
    this.cargando.value = false;
    return mayor;
  }

  Future<bool> verificarEdicionesActivos() async {
    this.cargando.value = true;
    dynamic response = await _edicionRepository.verificarEdicionesActivos();
    this.cargando.value = false;
    if (response != null) {
      dynamic estado = response['estado'];
      switch (estado) {
        case "1":
          return true;
          break;
        case "2":
          return false;
      }
    } else {
      mensaje.mensajeConError(mensaje: Mensaje.errorDeConsulta);
      return false;
    }
    return false;
  }

  goToActualizar({Edicion edicion}) {
    this.cargando.value = true;
    Future.delayed(Duration(seconds: 1)).then((_) => Get.to(EditarScallfold(
          edicion: edicion,
        )));
  }

  goToAgregar() async {
    this.cargando.value = true;

    final response = await this.verificarEdicionesActivos();
    if (response) {
      mensaje.mensajeConError(mensaje: "Existe un numero ediciòn activo");
      return;
    }
    Future.delayed(Duration(seconds: 1)).then((_) => Get.to(CrearScallfold()));
  }

  int obtenerPosicion(int id) {
    int posicion = -1;
    for (int i = 0; i < listaEdiciones.length; i++) {
      if (listaEdiciones[i].id == id) {
        posicion = i;
      }
    }
    return posicion;
  }

  DateTime obtenerUltimaFechaEdicion() {
    int mayor = 0;
    int contador = 0;
    for (int i = 0; i < listaEdiciones.length; i++) {
      Edicion edicion = listaEdiciones[i];
      if (edicion.id > mayor) {
        mayor = edicion.id;
        contador = i;
      }
    }
    DateTime fechaformateada;
    if (mayor > 0) {
      Edicion edicion = listaEdiciones[contador];
      DateFormat inputFormat = DateFormat("yyyy-MM-dd");
      fechaformateada = inputFormat.parse(edicion.fechaFin);
    } else {
      fechaformateada = DateTime.now();
    }
    return fechaformateada;
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

  //METODOS

  void ordenarLista() {
    listaEdiciones.sort((a, b) => b.id.compareTo(a.id));
  }
}
