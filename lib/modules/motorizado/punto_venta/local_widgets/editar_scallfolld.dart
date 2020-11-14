import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:proyect_nortenio_app/data/models/punto_venta.dart';
import 'package:proyect_nortenio_app/data/models/zona.dart';
import 'package:proyect_nortenio_app/global_widgets/loading_widget.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../../../global_widgets/botonRedondo.dart';
import '../../../../global_widgets/input_form.dart';
import '../../../../utils/colores.dart';
import '../../../../utils/responsive.dart';
import '../punto_venta_controller.dart';
import 'geolocalizacion_punto_venta.dart';

class EditarScallfold extends StatefulWidget {
  final PuntoVenta puntoVenta;

  const EditarScallfold({Key key, this.puntoVenta}) : super(key: key);
  @override
  _EditarScallfoldState createState() => _EditarScallfoldState();
}

class _EditarScallfoldState extends State<EditarScallfold>
    with AfterLayoutMixin {
  RoundedLoadingButtonController _btnControllerRegistrar;
  GlobalKey<FormState> _formKey;
  PuntoVentaControllerM _puntoVentaController = Get.find();

  String _celular = '',
      _propietario = '',
      _telefono = '',
      _razonSocial = '',
      _ruc = '',
      _estado = '',
      _correoElectronico = '',
      _referencia = '';
  Zona _zona;

  FocusNode _focusZona, _focusDescripcion, _focusDistribuidor, _focusMotorizado;
  TextEditingController _controllerRuc,
      _controllerRazonSocial,
      _controllerReferencia,
      _controllerCorreoElectronico,
      _controllerTelefono,
      _controllerCelular,
      _controllerPropietario,
      _controllerZona;

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

    _controllerReferencia = new TextEditingController();
    _controllerCorreoElectronico = new TextEditingController();
    _controllerTelefono = new TextEditingController();
    _controllerCelular = new TextEditingController();
    _controllerPropietario = new TextEditingController();

    super.initState();
    _puntoVentaController.cargando.value = false;
    _init();
  }

  _init() {
    _controllerRuc.text = widget.puntoVenta.ruc;
    _controllerRazonSocial.text = widget.puntoVenta.razonSocial;
    _estado = widget.puntoVenta.estado == 1 ? "Activo" : "Inactivo";
    _controllerZona.text =
        widget.puntoVenta.zona.isNull ? "" : widget.puntoVenta.zona.zona;
    _zona = widget.puntoVenta.zona;
    _controllerReferencia.text = widget.puntoVenta.referencia;
    _controllerCorreoElectronico.text = widget.puntoVenta.corrreoElectronico;
    _controllerTelefono.text = widget.puntoVenta.telefono;
    _controllerCelular.text = widget.puntoVenta.celular;
    _controllerPropietario.text = widget.puntoVenta.propietario;
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
    _controllerReferencia.dispose();
    _controllerCorreoElectronico.dispose();
    _controllerTelefono.dispose();
    _controllerCelular.dispose();
    _controllerPropietario.dispose();
    super.dispose();
  }

  String _validarRazonSocial(String texto) {
    if (texto.isNotEmpty) {
      _razonSocial = texto;
      return null;
    }
    return "Razon social incorrecto";
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
      return "Correo electronico invalido";
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

  PuntoVenta _validarCampos() {
    final bool isValid = _formKey.currentState.validate();
    if (isValid) {
      PuntoVenta puntoVenta = new PuntoVenta(
          id: widget.puntoVenta.id,
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
    _formKey.currentState.reset();
    _puntoVentaController.estaRegistradoRuc(
        ruc: ruc,
        controllerRazonSocial: _controllerRazonSocial,
        controllerRuc: _controllerRuc);
  }

  @override
  Widget build(BuildContext context) {
    final Responsive rosponsive = Responsive.of(context);
    final double butonSize = rosponsive.widthPercent(80);
    _puntoVentaController.setPuntoVentaEditar(puntoVenta: widget.puntoVenta);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colores.textosColorGris,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        elevation: 1,
        backgroundColor: Colores.bodyColor,
        title: Center(
          child: Text(
            "Registrar Punto de venta",
            style: TextStyle(
              color: Colores.colorTitulos,
              fontFamily: 'poppins',
              fontSize: 16,
              letterSpacing: 1,
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
                              width: 168,
                              enabled: false,
                              label: "Zona",
                              icon: Icon(Icons.view_carousel),
                              maxLength: 150,
                              controller: _controllerZona,
                            ),
                            InputForm(
                              width: 168,
                              label: "RUC",
                              keyboardType: TextInputType.phone,
                              icon: Icon(Icons.view_carousel),
                              enabled: false,
                              maxLength: 11,
                              controller: _controllerRuc,
                              validator: _validarRuc,
                            ),
                            InputForm(
                              width: double.infinity,
                              label: "Razon social",
                              enabled: false,
                              controller: _controllerRazonSocial,
                              icon: Icon(Icons.person),
                              maxLength: 100,
                              validator: _validarRazonSocial,
                            ),
                            InputForm(
                              width: double.infinity,
                              label: "Referencia",
                              icon: Icon(Icons.person),
                              maxLength: 100,
                              validator: _validarReferencia,
                              controller: _controllerReferencia,
                            ),
                            InputForm(
                              width: double.infinity,
                              label: "Correo electronico",
                              icon: Icon(Icons.person),
                              maxLength: 100,
                              validator: _validarCorreoElectronico,
                              controller: _controllerCorreoElectronico,
                            ),
                            InputForm(
                              width: double.infinity,
                              label: "Teléfono",
                              icon: Icon(Icons.person),
                              maxLength: 12,
                              keyboardType: TextInputType.phone,
                              validator: _validarTelefono,
                              controller: _controllerTelefono,
                            ),
                            InputForm(
                              width: double.infinity,
                              label: "Celular",
                              icon: Icon(Icons.person),
                              maxLength: 9,
                              controller: _controllerCelular,
                              keyboardType: TextInputType.phone,
                              validator: _validarCelular,
                            ),
                            InputForm(
                              width: double.infinity,
                              label: "Propiertario",
                              icon: Icon(Icons.people),
                              maxLength: 150,
                              controller: _controllerPropietario,
                              validator: _validarPropietario,
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
                                          GeolocalizacionPuntoVenta(),
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
                                    _puntoVentaController.puntoVentaEditar.value
                                        .geolocalizacion.direccion,
                                  )),
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
                                          GeolocalizacionPuntoVenta(),
                                    ),
                                  );
                                },
                              ),
                              leading: Icon(Icons.place),
                              title: Text(
                                "Horario",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              subtitle: Obx(() => Text(
                                    _puntoVentaController.puntoVentaEditar.value
                                        .geolocalizacion.direccion,
                                  )),
                            ),
                            Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colores.colorSubTitulos),
                                  borderRadius: BorderRadius.circular(50)),
                              width: double.infinity,
                              child: Row(
                                children: [
                                  Container(
                                      margin:
                                          EdgeInsets.only(left: 5, right: 5),
                                      child: Icon(Icons.ac_unit)),
                                  Expanded(
                                    child: DropdownButton<String>(
                                      value: _estado,
                                      iconSize: 24,
                                      icon: Container(),
                                      underline: Container(
                                        height: 2,
                                        color: Colores.bodyColor,
                                      ),
                                      onChanged: (String newValue) {
                                        setState(() {
                                          _estado = newValue;
                                        });
                                      },
                                      items: <String>['Activo', 'Inactivo']
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
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: BotonRedondo(
                                icon: Icon(
                                  Icons.save,
                                  color: Colors.white,
                                  size: 30,
                                ),
                                width: butonSize * 0.9,
                                btnController: _btnControllerRegistrar,
                                titulo: "Actualizar",
                                onPressed: () async {
                                  final puntoVenta = _validarCampos();
                                  if (puntoVenta != null) {
                                    dynamic response =
                                        await _puntoVentaController.actualizar(
                                            btnControllerRegistrar:
                                                _btnControllerRegistrar,
                                            puntoVenta: puntoVenta);

                                    if (response) {
                                      Get.back();
                                    }
                                  }
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Obx(() => _puntoVentaController.cargando.value == true
                  ? loading()
                  : Container())
            ],
          ),
        ),
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    _puntoVentaController.cargarListaZonas();
  }
}
