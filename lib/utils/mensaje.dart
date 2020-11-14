import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Mensaje {
  static const String nomre_empresa = "SMG Lottery";
  static const String error_cargar_datos = "Error al cargos los datos";
  static const String error_email = "Usuario incorrecto";
  static const String error_contrasenia = "Contraseña incorrecta";
  static const String error_cuenta_desabilitada = "Contraseña deshabilitada";
  static const String inici_sesion_correcto = "Bienvenido";
  static const String error_dni_ya_registrado = "El dni ya esta registrado";
  static const String falta_ingresar_dni = "Ingrese un N° DNI correcto";
  static const String falta_ingresar_ruc = "Ingrese un N° RUC correcto";
  static const String error_usuario_ya_registrado =
      "El campo usuario ya ha sido registrado";
  static const String error_contrasenia_mayor_a_8 =
      "La contraseña debe ser mayor a 8 digitos";
  static const String error_dni_incorrecto = "El dni es incorrecto";

  static final String errorDeConsulta =
      "No se puede recuperar la información. Verifica la conexión de red";
  static final String filaNoSeleccionada = "Seleccione una fila";
  static final String filaNoExiste = "La fila seleccionada ya no existe.";

  static final String preguntaDeEliminacion = "¿Está seguro de eliminar?";
  static final String afirmacionDeEliminacion = "El registro fue eliminado.";
  static final String advertenciaDeEliminacion =
      "El registro no puede ser eliminado, verifique";
  static final String errorDeEliminacion =
      "No se pudo eliminar, intente de nuevo o consulte con el Administrador";
  static final String afirmacionDeCreacion = "Los datos fueron guardados";
  static final String advertenciaDeCreacion =
      "Los datos no fueron guardados, verifique.";
  static final String errorDeCreacion = "No se pudieron guardar los datos.\n" +
      "Verifique los datos obligatorios y únicos.\n" +
      "Intente de nuevo o consulte con el Administrador.";
  static final String afirmacionDeActualizacion =
      "Los datos fueron actualizados.";
  static final String advertenciaDeActualizacion =
      "Los datos no fueron actualizados, verifique";
  static final String errorDeActualizacion =
      "No se pudieron actualizar los datos.\n" +
          "Verifique los datos obligatorios y únicos.\n" +
          "intente de nuevo o consulte con el Administrador.";

  static final String errorDeSistema =
      "Error inesperado\n" + "Intente de nuevo o consulte con el Administrador";

  static final String errorFaltaLlenar = "Error falta llenar ";
  static final String errorNoEncontrado = "No se ha encontrado ";
  static final String errorJDBC =
      "Error no se ha podido conectar a la Base Datos";

  void mensajeConError({String mensaje}) {
    Get.snackbar(Mensaje.nomre_empresa, mensaje,
        duration: Duration(seconds: 4),
        colorText: Colors.black45,
        snackPosition: SnackPosition.BOTTOM);
  }

  void mensajeCorrecto({String mensaje}) {
    Get.snackbar(Mensaje.nomre_empresa, mensaje,
        colorText: Colors.green, snackPosition: SnackPosition.BOTTOM);
  }
}
