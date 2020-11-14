import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:proyect_nortenio_app/data/models/geolocalizacion.dart';
import 'package:proyect_nortenio_app/data/models/punto_venta.dart';

import 'package:proyect_nortenio_app/data/models/zona.dart';
import 'package:proyect_nortenio_app/global_widgets/loading_widget.dart';
import 'package:proyect_nortenio_app/modules/distribuidor/punto_venta/local_widgets/geolocalizacion_crear.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../../../global_widgets/botonRedondo.dart';
import '../../../../global_widgets/input_form.dart';
import '../../../../utils/colores.dart';
import '../../../../utils/responsive.dart';
import '../punto_venta_controller.dart';

class CrearScallfold extends StatefulWidget {
  final Zona zona;

  const CrearScallfold({Key key, @required this.zona}) : super(key: key);
  @override
  _CrearScallfoldState createState() => _CrearScallfoldState();
}

class _CrearScallfoldState extends State<CrearScallfold> with AfterLayoutMixin {
  RoundedLoadingButtonController _btnControllerRegistrar;
  GlobalKey<FormState> _formKey;
  PuntoVentaControllerD _puntoVentaController = Get.find();

  Zona _zona;

  String _celular = '',
      _propietario = '',
      _telefono = '',
      _razonSocial = '',
      _ruc = '',
      _correoElectronico = '',
      _referencia = '';

  FocusNode _focusZona, _focusDescripcion, _focusDistribuidor, _focusMotorizado;
  TextEditingController _controllerRuc, _controllerRazonSocial, _controllerZona;

  @override
  void initState() {
    _formKey = GlobalKey();
    _btnControllerRegistrar = new RoundedLoadingButtonController();
    _focusZona = FocusNode();
    _focusDescripcion = FocusNode();
    _focusDistribuidor = FocusNode();
    _focusMotorizado = FocusNode();

    _controllerRuc = new TextEditingController();
    _controllerRazonSocial = new TextEditingController();
    _controllerZona = new TextEditingController();
    _iniciarPuntoVenta();
    super.initState();
    _puntoVentaController.cargando.value = false;
    _init();
  }

  _iniciarPuntoVenta() {
    PuntoVenta puntoVenta = new PuntoVenta(geolocalizacion: Geolocalizacion());
    _puntoVentaController.setPuntoVentaCrear(puntoVenta: puntoVenta);
  }

  _init() {
    _zona = widget.zona;
    if (!_zona.isNull) {
      _controllerZona.text = _zona.zona;
    }
  }

  @override
  void dispose() {
    _focusZona.dispose();
    _focusDescripcion.dispose();
    _focusDistribuidor.dispose();
    _focusMotorizado.dispose();
    _controllerRuc.dispose();
    _controllerRazonSocial.dispose();
    _controllerZona.dispose();

    super.dispose();
  }

  String _validarRazonSocial(String texto) {
    if (texto.isNotEmpty) {
      _razonSocial = texto;
      return null;
    }
    return "Razón social incorrecto";
  }

  String _validarReferencia(String texto) {
    if (texto.isNotEmpty) {
      _referencia = texto;
      return null;
    }
    return "Referencia incorrecto";
  }

  String _validarRuc(String texto) {
    if (texto.isNotEmpty && texto.length >= 11) {
      _ruc = texto;
      return null;
    }
    return "Ruc incorrecto";
  }

  String _validarCorreoElectronico(String email) {
    if (email.length > 0) {
      if (email.isNotEmpty && email.contains("@")) {
        _correoElectronico = email;
        return null;
      }
      return "Correo electrónico invalido";
    }

    return null;
  }

  String _validarCelular(String texto) {
    if (texto.isNotEmpty) {
      _celular = texto;
      return null;
    }
    return "Celular incorrecto";
  }

  String _validarPropietario(String texto) {
    if (texto.isNotEmpty) {
      _propietario = texto;
      return null;
    }
    return "Propietario incorrecto";
  }

  String _validarTelefono(String texto) {
    _telefono = texto;
    return null;
  }

  String _validarZona(String texto) {
    if (texto.isNotEmpty) {
      return null;
    }
    return "Zona incorrecta";
  }

  PuntoVenta _validarCampos() {
    final bool isValid = _formKey.currentState.validate();
    if (isValid) {
      PuntoVenta puntoVenta = new PuntoVenta(
          geolocalizacion:
              _puntoVentaController.puntoVentaCrear.value.geolocalizacion,
          celular: _celular,
          corrreoElectronico: _correoElectronico,
          estado: 1,
          propietario: _propietario,
          razonSocial: _razonSocial,
          referencia: _referencia,
          ruc: _ruc,
          telefono: _telefono,
          zona: _zona);

      return puntoVenta;
    } else {
      _btnControllerRegistrar.reset();
      return null;
    }
  }

  void buscarRuc({BuildContext context}) {
    String ruc = _controllerRuc.text;
    _puntoVentaController.estaRegistradoRuc(
      ruc: ruc,
      controllerRazonSocial: _controllerRazonSocial,
    );
  }

  @override
  Widget build(BuildContext context) {
    final Responsive rosponsive = Responsive.of(context);
    final double butonSize = rosponsive.widthPercent(80);
    return Scaffold(
      backgroundColor: Colores.bodyColor,
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colores.bodyColor,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        elevation: 1,
        backgroundColor: Colores.colorBody,
        title: Center(
          child: Text(
            "Registrar Punto Venta",
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colores.bodyColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
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
                            InputForm(
                              width: double.infinity,
                              label: "Zona",
                              controller: _controllerZona,
                              icon: Icon(Icons.store),
                              maxLength: 100,
                              enabled: false,
                              validator: _validarZona,
                            ),
                            Stack(
                              children: [
                                InputForm(
                                  width: 168,
                                  label: "RUC",
                                  keyboardType: TextInputType.phone,
                                  icon: Icon(Icons.view_carousel),
                                  onFieldSubmitted: (String text) {
                                    buscarRuc(context: context);
                                  },
                                  maxLength: 11,
                                  controller: _controllerRuc,
                                  validator: _validarRuc,
                                ),
                                Positioned(
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
                                          buscarRuc(context: context);
                                        }),
                                  ),
                                )
                              ],
                            ),
                            InputForm(
                              width: double.infinity,
                              label: "Razón social",
                              controller: _controllerRazonSocial,
                              icon: Icon(FontAwesomeIcons.scroll),
                              maxLength: 100,
                              enabled: false,
                              validator: _validarRazonSocial,
                            ),
                            ListTile(
                              trailing: IconButton(
                                icon: Icon(
                                  Icons.person_pin_circle,
                                  color: Colores.colorButton,
                                  size: 30,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          GeolocalizacionCrear(),
                                    ),
                                  );
                                },
                              ),
                              leading: Icon(Icons.place),
                              title: Text(
                                "Dirección",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              subtitle: Obx(() => Text(
                                    _puntoVentaController.puntoVentaCrear.value
                                        .geolocalizacion.direccion,
                                  )),
                            ),
                            InputForm(
                              width: double.infinity,
                              label: "Referencia",
                              icon: Icon(FontAwesomeIcons.road),
                              maxLength: 100,
                              validator: _validarReferencia,
                            ),
                            InputForm(
                              width: double.infinity,
                              label: "Correo electrónico",
                              icon: Icon(Icons.email),
                              maxLength: 100,
                              validator: _validarCorreoElectronico,
                            ),
                            InputForm(
                              width: double.infinity,
                              label: "Teléfono",
                              icon: Icon(Icons.phone),
                              maxLength: 12,
                              keyboardType: TextInputType.phone,
                              validator: _validarTelefono,
                            ),
                            InputForm(
                              width: double.infinity,
                              label: "Celular",
                              icon: Icon(FontAwesomeIcons.mobileAlt),
                              maxLength: 9,
                              keyboardType: TextInputType.phone,
                              validator: _validarCelular,
                            ),
                            InputForm(
                              width: double.infinity,
                              label: "Propietario",
                              icon: Icon(Icons.people),
                              maxLength: 150,
                              validator: _validarPropietario,
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: BotonRedondo(
                                width: butonSize * 0.9,
                                btnController: _btnControllerRegistrar,
                                titulo: "Registrar",
                                onPressed: () async {
                                  final puntoVenta = _validarCampos();
                                  if (puntoVenta != null) {
                                    dynamic response =
                                        await _puntoVentaController.registrar(
                                            btnControllerRegistrar:
                                                _btnControllerRegistrar,
                                            puntoVenta: puntoVenta);

                                    if (response) {
                                      Get.back();
                                    }
                                  }
                                },
                              ),
                            ),
                            SizedBox(height: rosponsive.heightPercent(2)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Obx(
                () => _puntoVentaController.cargando.value == true
                    ? loading()
                    : Container(),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    /* _puntoVentaController.cargarListaZonas(); */
  }
}
