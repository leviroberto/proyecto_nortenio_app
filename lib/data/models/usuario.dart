import 'package:flutter/cupertino.dart';
import 'package:proyect_nortenio_app/utils/colores.dart';
import 'package:proyect_nortenio_app/utils/util.dart';

import 'tipo_usuario.dart';

class Usuario {
  final int id, estado, genero;

  final String apellidos,
      token,
      tipoDocumento,
      nombre,
      fechaNacimiento,
      dni,
      celular,
      direccion,
      correoElectronico,
      username,
      password,
      nombreCompleto,
      imagen,
      ultimoLogin;
  final TipoUsuario tipoUsuario;

  Usuario(
      {this.id = -1,
      this.apellidos,
      this.nombre,
      this.token = "",
      this.tipoDocumento = "DNI",
      this.fechaNacimiento,
      this.dni,
      this.celular,
      this.direccion,
      this.correoElectronico,
      this.username,
      this.password,
      this.nombreCompleto,
      this.imagen,
      this.estado,
      this.genero,
      this.ultimoLogin,
      this.tipoUsuario});

  Usuario copyWith({
    int id,
    int estado,
    int genero,
    String apellidos,
    String nombre,
    String fechaNacimiento,
    String dni,
    String celular,
    String direccion,
    String correoElectronico,
    String username,
    String password,
    String nombreCompleto,
    String imagen,
    String ultimoLogin,
    String tipoUsuario,
  }) {
    return Usuario(
      id: id ?? this.id,
      estado: estado ?? this.estado,
      genero: genero ?? this.genero,
      token: token ?? this.token,
      tipoDocumento: tipoDocumento ?? this.tipoDocumento,
      apellidos: apellidos ?? this.apellidos,
      nombre: nombre ?? this.nombre,
      fechaNacimiento: fechaNacimiento ?? this.fechaNacimiento,
      dni: dni ?? this.dni,
      celular: celular ?? this.celular,
      direccion: direccion ?? this.direccion,
      correoElectronico: correoElectronico ?? this.correoElectronico,
      username: username ?? this.username,
      password: password ?? this.password,
      nombreCompleto: nombreCompleto ?? this.nombreCompleto,
      imagen: imagen ?? this.imagen,
      ultimoLogin: ultimoLogin ?? this.ultimoLogin,
      tipoUsuario: tipoUsuario ?? this.tipoUsuario,
    );
  }

  static Usuario initialState() => Usuario(
        id: 0,
        apellidos: "",
        nombre: "",
        fechaNacimiento: "",
        dni: "",
        celular: "",
        direccion: "",
        correoElectronico: "",
        username: "",
        password: "",
        nombreCompleto: "",
        token: "",
        tipoDocumento: "DNI",
        imagen: "",
        genero: 0,
        ultimoLogin: "",
      );

  bool esDistribuidor() {
    return this.tipoUsuario.id == 4;
  }

  bool esMotorizado() {
    return this.tipoUsuario.id == 3;
  }

  bool esGerente() {
    return this.tipoUsuario.id == 2;
  }

  factory Usuario.fromJson(Map jsonData) {
    return Usuario(
        id: Util.checkInteger(jsonData['id']),
        apellidos: Util.checkString(jsonData['apellidos']),
        token: Util.checkString(jsonData['token']),
        nombre: Util.checkString(jsonData['nombre']),
        fechaNacimiento: Util.checkString(jsonData['fecha_nacimiento']),
        dni: Util.checkString(jsonData['dni']),
        celular: Util.checkString(jsonData['celular']),
        direccion: Util.checkString(jsonData['direccion']),
        correoElectronico: jsonData['correo_electronico'] ?? "",
        username: Util.checkString(jsonData['username']),
        password: Util.checkString(jsonData['password']),
        tipoDocumento: Util.checkString(jsonData['tipo_documento']),
        nombreCompleto: Util.checkString(jsonData['nombre_completo']),
        imagen: Util.checkString(jsonData['imagen']),
        estado: Util.checkInteger(jsonData['estado']),
        genero: Util.checkInteger(jsonData['genero']),
        ultimoLogin: Util.checkString(jsonData['ultimo_login']),
        tipoUsuario: TipoUsuario.fromJson(jsonData['tipoUsuario']));
  }

  // method
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'apellidos': apellidos,
      'nombre': nombre,
      'fecha_nacimiento': fechaNacimiento,
      'dni': dni,
      'celular': celular,
      'token': token,
      'tipo_documento': tipoDocumento,
      'direccion': direccion,
      'correo_electronico': correoElectronico,
      'username': username,
      'password': password,
      'nombre_completo': nombreCompleto,
      'imagen': imagen,
      'estado': estado,
      'genero': genero,
      'ultimo_login': ultimoLogin,
      'tipoUsuario': tipoUsuario.toJson(),
    };
  }

  String generarEstado() {
    return estado == 1 ? 'Activo' : 'Inactivo';
  }

  Color generarEstadoColor() =>
      estado == 1 ? Colores.colorBody : Colores.colorRojo;
}
