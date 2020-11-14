import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:proyect_nortenio_app/data/models/tipo_usuario.dart';
import 'package:proyect_nortenio_app/data/models/usuario.dart';
import 'package:proyect_nortenio_app/global_widgets/botonRedondo.dart';
import 'package:proyect_nortenio_app/global_widgets/custom_app_bar.dart';
import 'package:proyect_nortenio_app/global_widgets/input_form.dart';
import 'package:proyect_nortenio_app/global_widgets/loading_widget.dart';
import 'package:proyect_nortenio_app/utils/colores.dart';
import 'package:proyect_nortenio_app/utils/responsive.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../distribuidor_controller.dart';

class CrearScallfold extends StatefulWidget {
  @override
  _CrearScallfoldState createState() => _CrearScallfoldState();
}

class _CrearScallfoldState extends State<CrearScallfold> {
  RoundedLoadingButtonController _btnControllerRegistrar;
  GlobalKey<FormState> _formKey;
  DistribuidorControllerG _distribuidorController = Get.find();

  String _tipoDocumento = '',
      _dni = '',
      _nombre = '',
      _apellidos = '',
      _telefono = '',
      _direccion = '',
      _correoElectronico = '',
      _usuario = '',
      _password = '',
      _genero = '',
      _fechaNacimiento = '',
      errorPasswordRepetido = '';
  int tamanioDocumento = 8;

  bool _enabledImput = false;

  bool _passwordVisible;

  FocusNode _focusDni,
      _focusTelefono,
      _focusDireccion,
      _focusCorreoElectronico,
      _focusUsuario,
      _focusPassword;

  TextEditingController _controllerDni,
      _controllerNombre,
      _controllerApellidos,
      _controllerFechaNacimiento,
      _controllerUsuario,
      _controllerContrasenia,
      _controllerSexo;

  List<String> listaTipoDocuemnto = ['DNI', 'PASAPORTE', 'OTRO'];

  @override
  void initState() {
    _formKey = GlobalKey();
    _passwordVisible = false;
    _btnControllerRegistrar = new RoundedLoadingButtonController();
    _focusDni = FocusNode();
    _focusTelefono = FocusNode();
    _focusDireccion = FocusNode();
    _focusCorreoElectronico = FocusNode();
    _focusUsuario = FocusNode();
    _focusPassword = FocusNode();

    _controllerDni = new TextEditingController();
    _controllerUsuario = new TextEditingController();
    _controllerNombre = new TextEditingController();
    _controllerApellidos = new TextEditingController();
    _controllerSexo = new TextEditingController();
    _controllerFechaNacimiento = new TextEditingController();
    _controllerContrasenia = new TextEditingController();
    _tipoDocumento = 'DNI';
    super.initState();
    _distribuidorController.cargando.value = false;
  }

  @override
  void dispose() {
    _controllerDni.dispose();
    _focusDni.dispose();
    _focusTelefono.dispose();
    _focusDireccion.dispose();
    _focusCorreoElectronico.dispose();
    _focusPassword.dispose();
    _controllerUsuario.dispose();
    _controllerContrasenia.dispose();
    super.dispose();
  }

  String _validarDni(String dni) {
    if (dni.isNotEmpty) {
      _dni = dni;
      return null;
    }
    return "Dni incorrecto";
  }

  String _validarNombre(String texto) {
    if (texto.isNotEmpty) {
      _nombre = texto;
      return null;
    }
    return "Nombre incorrecto";
  }

  String _validarApellidos(String texto) {
    if (texto.isNotEmpty) {
      _apellidos = texto;
      return null;
    }
    return "Apellidos incorrecto";
  }

  String _validarSexo(String texto) {
    if (texto.isNotEmpty) {
      _genero = texto;
      return null;
    }
    return "Sexo incorrecto";
  }

  String _validarFechaNacimiento(String texto) {
    if (texto.isNotEmpty) {
      _fechaNacimiento = texto;
      return null;
    }
    return "Fecha Nacimiento incorrecto";
  }

  String _validarTelefono(String texto) {
    if (texto.isNotEmpty && texto.length >= 9) {
      _telefono = texto;
      return null;
    }
    return "Teléfono incorrecto";
  }

  String _validarDireccion(String texto) {
    if (texto.isNotEmpty) {
      _direccion = texto;
      return null;
    }
    return "Direcciòn incorrecta";
  }

  String _validarUsuario(String texto) {
    if (texto.isNotEmpty && texto.length >= 3) {
      _usuario = texto;
      return null;
    }
    return "Usuario incorrecta";
  }

  String _validarCorreoElectronico(String texto) {
    if (texto.isNotEmpty && texto.contains("@")) {
      _correoElectronico = texto;
      return null;
    }
    return "Correo electronico incorrecto";
  }

  String _validarPassword(String password) {
    if (password.isNotEmpty && password.length >= 5) {
      _password = password;
      return null;
    }
    return "Contraseña incorrecto";
  }

  Usuario _validarCampos() {
    final bool isValid = _formKey.currentState.validate();

    if (isValid) {
      TipoUsuario tipoUsuario =
          new TipoUsuario(descripcion: "Distribuidor", id: 4);
      Usuario distribuidor = new Usuario(
          estado: 1,
          tipoDocumento: _tipoDocumento,
          fechaNacimiento: _fechaNacimiento,
          genero: _genero == "Masculino" ? 1 : 2,
          nombreCompleto: _apellidos + ", " + _nombre,
          username: _usuario,
          apellidos: _apellidos,
          celular: _telefono,
          correoElectronico: _correoElectronico,
          direccion: _direccion,
          dni: _dni,
          nombre: _nombre,
          password: _password,
          tipoUsuario: tipoUsuario);

      return distribuidor;
    } else {
      _btnControllerRegistrar.reset();
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Responsive rosponsive = Responsive.of(context);
    final double butonSize = rosponsive.widthPercent(80);
    return Scaffold(
      appBar: CustomAppBar(
        title: "Registrar Distribuidor",
        onTapAtras: () {
          Navigator.pop(context);
        },
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: GestureDetector(
                  child: Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: 15),
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colores.colorSubTitulos),
                                borderRadius: BorderRadius.circular(50)),
                            width: double.infinity,
                            child: Row(
                              children: [
                                Container(
                                    margin: EdgeInsets.only(left: 5, right: 5),
                                    child: Icon(Icons.keyboard_arrow_down)),
                                Expanded(
                                  child: DropdownButton<String>(
                                    value: _tipoDocumento,
                                    iconSize: 24,
                                    icon: Container(),
                                    underline: Container(
                                      height: 2,
                                      color: Colores.bodyColor,
                                    ),
                                    onChanged: (String newValue) {
                                      setState(() {
                                        if (newValue == 'DNI') {
                                          _enabledImput = false;
                                          tamanioDocumento = 8;
                                        } else if (newValue == 'PASAPORTE') {
                                          _enabledImput = true;
                                          tamanioDocumento = 15;
                                        } else {
                                          _enabledImput = true;
                                          tamanioDocumento = 15;
                                        }
                                        _controllerDni.text = "";
                                        _tipoDocumento = newValue;
                                      });
                                    },
                                    items: listaTipoDocuemnto
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Stack(
                            children: [
                              InputForm(
                                keyboardType: TextInputType.phone,
                                width: 168,
                                label: "DOCUMENTO",
                                icon: Icon(Icons.view_carousel),
                                hint: "23456798",
                                focusNone: _focusDni,
                                onChanged: (String text) => _dni = text,
                                onFieldSubmitted: (String text) {
                                  if (!_enabledImput) {
                                    _distribuidorController.buscarDni(
                                        dni: _dni,
                                        controllerApellidos:
                                            _controllerApellidos,
                                        controllerContrasenia:
                                            _controllerContrasenia,
                                        controllerFechaNacimiento:
                                            _controllerFechaNacimiento,
                                        controllerNombre: _controllerNombre,
                                        controllerUsuario: _controllerUsuario,
                                        controllerSexo: _controllerSexo);
                                  }
                                },
                                validator: _validarDni,
                                maxLength: tamanioDocumento,
                                controller: _controllerDni,
                              ),
                              _enabledImput
                                  ? Container()
                                  : Positioned(
                                      right: 3,
                                      top: 4,
                                      child: Transform.scale(
                                        scale: 1.54,
                                        child: IconButton(
                                            icon: Icon(
                                              Icons.search,
                                              color: Colores.textosColorGris,
                                            ),
                                            onPressed: () {
                                              _distribuidorController.buscarDni(
                                                  dni: _dni,
                                                  controllerApellidos:
                                                      _controllerApellidos,
                                                  controllerContrasenia:
                                                      _controllerContrasenia,
                                                  controllerFechaNacimiento:
                                                      _controllerFechaNacimiento,
                                                  controllerUsuario:
                                                      _controllerUsuario,
                                                  controllerNombre:
                                                      _controllerNombre,
                                                  controllerSexo:
                                                      _controllerSexo);
                                            }),
                                      ),
                                    )
                            ],
                          ),
                          InputForm(
                            width: double.infinity,
                            label: "Nombre",
                            controller: _controllerNombre,
                            icon: Icon(Icons.person),
                            maxLength: 60,
                            validator: _validarNombre,
                          ),
                          InputForm(
                            width: double.infinity,
                            label: "Apellidos",
                            icon: Icon(Icons.people),
                            maxLength: 150,
                            controller: _controllerApellidos,
                            validator: _validarApellidos,
                          ),
                          InputForm(
                            width: double.infinity,
                            label: "Sexo",
                            icon: Icon(Icons.multiline_chart),
                            maxLength: 150,
                            controller: _controllerSexo,
                            validator: _validarSexo,
                          ),
                          InputForm(
                            width: double.infinity,
                            label: "Fecha Nacimiento",
                            icon: Icon(Icons.calendar_today),
                            maxLength: 150,
                            controller: _controllerFechaNacimiento,
                            validator: _validarFechaNacimiento,
                          ),
                          InputForm(
                              validator: _validarTelefono,
                              width: 168,
                              label: "Teléfono",
                              icon: Icon(Icons.phone),
                              hint: "987456321",
                              focusNone: _focusTelefono,
                              maxLength: 9,
                              keyboardType: TextInputType.phone,
                              onFieldSubmitted: (String text) {
                                _focusDireccion.nextFocus();
                              }),
                          InputForm(
                              validator: _validarDireccion,
                              width: double.infinity,
                              label: "Dirección",
                              icon: Icon(Icons.place),
                              focusNone: _focusDireccion,
                              onFieldSubmitted: (String text) {
                                _focusCorreoElectronico.nextFocus();
                              }),
                          InputForm(
                              validator: _validarCorreoElectronico,
                              width: double.infinity,
                              label: "Correo eletrónico",
                              icon: Icon(Icons.email),
                              focusNone: _focusCorreoElectronico,
                              onFieldSubmitted: (String text) {
                                _focusUsuario.nextFocus();
                              }),
                          InputForm(
                              validator: _validarUsuario,
                              controller: _controllerUsuario,
                              width: double.infinity,
                              label: "Usuario ",
                              icon: Icon(Icons.person_pin),
                              focusNone: _focusUsuario,
                              onFieldSubmitted: (String text) {
                                _focusPassword.nextFocus();
                              }),
                          InputForm(
                            maxLength: 50,
                            onPressedIconPassword: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                            passwordVisible: _passwordVisible,
                            isPassword: true,
                            label: "Contraseña",
                            icon: Icon(Icons.vpn_key),
                            hint: "********",
                            focusNone: _focusPassword,
                            validator: _validarPassword,
                            controller: _controllerContrasenia,
                            onFieldSubmitted: (String password) async {
                              _formKey.currentState.initState();
                              Usuario distribuidor = _validarCampos();
                              if (distribuidor != null) {
                                dynamic response =
                                    await _distribuidorController.registrar(
                                        distribuidor: distribuidor,
                                        btnControllerRegistrar:
                                            _btnControllerRegistrar);

                                if (response) {
                                  Get.back();
                                }
                              }
                            },
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: BotonRedondo(
                              width: butonSize * 0.9,
                              btnController: _btnControllerRegistrar,
                              titulo: "Registrar",
                              onPressed: () async {
                                Usuario distribuidor = _validarCampos();
                                if (distribuidor != null) {
                                  dynamic response =
                                      await _distribuidorController.registrar(
                                          distribuidor: distribuidor,
                                          btnControllerRegistrar:
                                              _btnControllerRegistrar);

                                  if (response) {
                                    Get.back();
                                  }
                                }
                              },
                            ),
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Obx(() => _distribuidorController.cargando.value == true
                ? loading()
                : Container())
          ],
        ),
      ),
    );
  }
}