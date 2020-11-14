import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:proyect_nortenio_app/data/models/usuario.dart';
import 'package:proyect_nortenio_app/global_widgets/custom_app_bar.dart';
import 'package:proyect_nortenio_app/global_widgets/loading_widget.dart';
import 'package:proyect_nortenio_app/utils/responsive.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../../../global_widgets/botonRedondo.dart';
import '../../../../global_widgets/input_form.dart';
import '../../../../utils/colores.dart';
import '../distribuidor_controller.dart';

class EditarScallfol extends StatefulWidget {
  final Usuario distribuidor;

  const EditarScallfol({Key key, this.distribuidor}) : super(key: key);
  @override
  _EditarScallfolState createState() => _EditarScallfolState();
}

class _EditarScallfolState extends State<EditarScallfol> {
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
      _password = '',
      _genero = '',
      _usuario = '',
      _fechaNacimiento = '',
      errorPasswordRepetido = '';

  bool _enabledImput = false;
  int tamanioDocumento = 8;
  List<String> listaTipoDocuemnto = ['DNI', 'PASAPORTE', 'OTRO'];
  FocusNode _focusDni,
      _focusTelefono,
      _focusDireccion,
      _focusCorreoElectronico,
      _focusPassword,
      _focusUsuario;

  TextEditingController _controllerDni,
      _controllerNombre,
      _controllerApellidos,
      _controllerFechaNacimiento,
      _controllerTelefono,
      _controllerDireccion,
      _controllerCorreoElectronico,
      _controllerUsuario,
      _controllerSexo;

  @override
  void initState() {
    _formKey = GlobalKey();
    _btnControllerRegistrar = new RoundedLoadingButtonController();
    _focusDni = FocusNode();
    _focusTelefono = FocusNode();
    _focusDireccion = FocusNode();
    _focusCorreoElectronico = FocusNode();
    _focusPassword = FocusNode();
    _focusUsuario = FocusNode();

    _controllerDni = new TextEditingController();
    _controllerNombre = new TextEditingController();
    _controllerApellidos = new TextEditingController();
    _controllerSexo = new TextEditingController();
    _controllerFechaNacimiento = new TextEditingController();

    _controllerTelefono = new TextEditingController();
    _controllerDireccion = new TextEditingController();
    _controllerCorreoElectronico = new TextEditingController();
    _controllerUsuario = new TextEditingController();

    super.initState();
    _distribuidorController.cargando.value = false;
    init();
  }

  void init() {
    _controllerDni.text = widget.distribuidor.dni;
    _controllerNombre.text = widget.distribuidor.nombre;
    _controllerApellidos.text = widget.distribuidor.apellidos;
    _controllerSexo.text =
        widget.distribuidor.genero == 1 ? 'Masculino' : 'Femenino';
    _controllerFechaNacimiento.text = widget.distribuidor.fechaNacimiento;

    _controllerTelefono.text = widget.distribuidor.celular;
    _controllerDireccion.text = widget.distribuidor.direccion;
    _controllerCorreoElectronico.text = widget.distribuidor.correoElectronico;
    _controllerUsuario.text = widget.distribuidor.username;

    setState(() {
      _tipoDocumento = widget.distribuidor.tipoDocumento;
      if (_tipoDocumento == 'DNI') {
        tamanioDocumento = 8;
        _enabledImput = false;
      } else {
        tamanioDocumento = 15;
        _enabledImput = true;
      }
    });
  }

  @override
  void dispose() {
    _controllerDni.dispose();
    _focusDni.dispose();
    _focusTelefono.dispose();
    _focusDireccion.dispose();
    _focusCorreoElectronico.dispose();
    _focusPassword.dispose();
    _focusUsuario.dispose();

    _controllerTelefono.dispose();
    _controllerDireccion.dispose();
    _controllerCorreoElectronico.dispose();
    _controllerUsuario.dispose();

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
    return "Apellidos incorrecto";
  }

  String _validarFechaNacimiento(String texto) {
    if (texto.isNotEmpty) {
      _fechaNacimiento = texto;
      return null;
    }
    return "Fecha Nacimiento incorrecto";
  }

  String _validarUsuario(String texto) {
    if (texto.isNotEmpty && texto.length >= 3) {
      _usuario = texto;
      return null;
    }
    return "Usuario incorrecto";
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

  String _validarCorreoElectronico(String texto) {
    if (texto.isNotEmpty && texto.contains("@")) {
      _correoElectronico = texto;
      return null;
    }
    return "Correo electronico incorrecto";
  }

  Usuario _validarCampos() {
    final bool isValid = _formKey.currentState.validate();
    if (isValid) {
      Usuario distribuidor = new Usuario(
        estado: 1,
        tipoDocumento: _tipoDocumento,
        id: widget.distribuidor.id,
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
      );

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
      backgroundColor: Colores.bodyColor,
      appBar: CustomAppBar(
        title: "Editar Distribuidor",
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
                                        _tipoDocumento = newValue;
                                        _controllerDni.text = "";
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
                          InputForm(
                            width: 168,
                            label: "DNI",
                            icon: Icon(Icons.view_carousel),
                            hint: "23456798",
                            focusNone: _focusDni,
                            validator: _validarDni,
                            maxLength: tamanioDocumento,
                            controller: _controllerDni,
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
                              label: "Télefono",
                              icon: Icon(Icons.phone),
                              hint: "987456321",
                              focusNone: _focusTelefono,
                              controller: _controllerTelefono,
                              maxLength: 9,
                              keyboardType: TextInputType.phone,
                              onFieldSubmitted: (String text) {
                                _focusDireccion.nextFocus();
                              }),
                          InputForm(
                              validator: _validarDireccion,
                              width: double.infinity,
                              label: "Dirección",
                              controller: _controllerDireccion,
                              icon: Icon(Icons.place),
                              focusNone: _focusDireccion,
                              onFieldSubmitted: (String text) {
                                _focusCorreoElectronico.nextFocus();
                              }),
                          InputForm(
                              validator: _validarCorreoElectronico,
                              width: double.infinity,
                              controller: _controllerCorreoElectronico,
                              label: "Correo eletrónico",
                              icon: Icon(Icons.email),
                              onFieldSubmitted: (String text) {
                                _focusUsuario.nextFocus();
                              }),
                          InputForm(
                              validator: _validarUsuario,
                              width: double.infinity,
                              controller: _controllerUsuario,
                              label: "Usuario",
                              enabled: false,
                              icon: Icon(Icons.person_pin),
                              focusNone: _focusUsuario,
                              onFieldSubmitted: (String text) async {
                                await actualizarDatos();
                              }),
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: BotonRedondo(
                              width: butonSize * 0.9,
                              btnController: _btnControllerRegistrar,
                              titulo: "Actualizar",
                              onPressed: () async {
                                await actualizarDatos();
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

  Future actualizarDatos() async {
    Usuario distribuidor = _validarCampos();
    if (distribuidor != null) {
      dynamic response = await _distribuidorController.actualizar(
          distribuidor: distribuidor,
          btnControllerRegistrar: _btnControllerRegistrar);

      if (response) {
        Get.back();
      }
    }
  }
}
