import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:proyect_nortenio_app/data/models/billete_distribuidor_.dart';
import 'package:proyect_nortenio_app/data/models/billete_punto_venta.dart';
import 'package:proyect_nortenio_app/data/models/edicion.dart';
import 'package:proyect_nortenio_app/data/models/punto_venta.dart';
import 'package:proyect_nortenio_app/global_widgets/botonRedondo.dart';
import 'package:proyect_nortenio_app/global_widgets/input_form.dart';
import 'package:proyect_nortenio_app/global_widgets/loading_widget.dart';
import 'package:proyect_nortenio_app/modules/motorizado/billete_punto_venta/billete_punto_venta_controller.dart';
import 'package:proyect_nortenio_app/utils/colores.dart';
import 'package:proyect_nortenio_app/utils/responsive.dart';
import 'package:proyect_nortenio_app/utils/util.dart';
import 'package:proyect_nortenio_app/utils/utilidades.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:url_launcher/url_launcher.dart';

class EntregarScallfold extends StatefulWidget {
  final BilletePuntoVenta billetePuntoVenta;
  const EntregarScallfold({Key key, @required this.billetePuntoVenta})
      : super(key: key);
  @override
  _EntregarScallfoldState createState() => _EntregarScallfoldState();
}

class _EntregarScallfoldState extends State<EntregarScallfold>
    with AfterLayoutMixin {
  RoundedLoadingButtonController _btnControllerRegistrar;
  GlobalKey<FormState> _formKey;
  BilletePuntoVentaControllerM _billetePuntoVentaController = Get.find();
  bool _checkBoxValueInicioEntrega = false, _checkBoxValueFinEntrega = false;

  List<String> listaEstado = ['Activo', 'Entregado', 'Recogido'];
  String _billetesInicial = '',
      _billetesFin = '',
      _fechaInicioEntrega = '',
      _fechaFinEntrega = '';

  PuntoVenta _puntoVenta;
  Edicion _edicion;

  FocusNode _fecusFinal;
  BilleteDistribuidor billeteDistribuidor;

  TextEditingController _controllerPuntoVenta,
      _controllerFechaEntrega,
      _controllerFechaRecojo,
      _controllerEdicion,
      _controllerCantidad,
      _controllerReciboInicial,
      _controllerReciboFinal,
      _controllerDescripcion;

  @override
  void initState() {
    _formKey = GlobalKey();
    _btnControllerRegistrar = new RoundedLoadingButtonController();
    _fecusFinal = FocusNode();

    _controllerCantidad = new TextEditingController();
    _controllerEdicion = new TextEditingController();
    _controllerDescripcion = new TextEditingController();
    _controllerReciboInicial = new TextEditingController();

    _controllerPuntoVenta = new TextEditingController();

    _controllerFechaEntrega = new TextEditingController();
    _controllerFechaRecojo = new TextEditingController();
    _controllerReciboFinal = new TextEditingController();

    super.initState();
    _billetePuntoVentaController.cargando.value = false;
    _edicion = widget.billetePuntoVenta.edicion;
    _puntoVenta = widget.billetePuntoVenta.puntoVenta;
  }

  String getEstadoPalabra({int estado}) {
    String aux = "Activo";
    switch (estado) {
      case 1:
        aux = "Activo";
        break;
      case 2:
        aux = "Entregado";
        break;
      case 3:
        aux = "Recogido";
        break;
    }
    return aux;
  }

  _init() {
    setState(() {
      _controllerEdicion.text = _edicion.numero;

      _controllerReciboFinal.text = widget.billetePuntoVenta.reciboFinal;

      _controllerPuntoVenta.text = _puntoVenta.propietario;

      _controllerReciboInicial.text = widget.billetePuntoVenta.reciboInicial;

      _fechaFinEntrega = widget.billetePuntoVenta.fechaFinEntrega;
      _fechaInicioEntrega = widget.billetePuntoVenta.fechaInicioEntrega;
      _checkBoxValueFinEntrega = _fechaFinEntrega == "" ? false : true;
      _checkBoxValueInicioEntrega = _fechaInicioEntrega == "" ? false : true;

      _calcularTotalBilletes();
    });
  }

  @override
  void dispose() {
    _fecusFinal.dispose();
    _controllerEdicion.dispose();

    _controllerPuntoVenta.dispose();
    _controllerCantidad.dispose();
    _controllerDescripcion.dispose();
    _controllerReciboInicial.dispose();
    _controllerFechaEntrega.dispose();
    _controllerFechaRecojo.dispose();
    _controllerReciboFinal.dispose();
    super.dispose();
  }

  _calcularTotalBilletes() {
    String recibo1 = _controllerReciboInicial.text;
    String recibo2 = _controllerReciboFinal.text;

    int reciboInicial = recibo1 == "" ? 0 : int.parse(recibo1);
    int reciboFinal = recibo2 == "" ? 0 : int.parse(recibo2);
    if (reciboInicial > 0 && reciboFinal > 0) {
      int resta = reciboFinal - reciboInicial;
      if (resta > 0) {
        _controllerCantidad.text = resta.toString();
      } else {
        _controllerCantidad.text = "0";
      }
    } else {
      _controllerCantidad.text = "0";
    }
  }

  String _validarZona(String texto) {
    if (texto.isNotEmpty) {
      return null;
    }
    return "Zona incorrecta";
  }

  String _validarEdicion(String texto) {
    if (texto.isNotEmpty) {
      return null;
    }
    return "Edición incorrecta";
  }

  String _validarFechaInicial(String texto) {
    int cantidad = Util.checkInteger(texto);
    int reciboFinal = Util.checkInteger(billeteDistribuidor.reciboInicial);
    if (texto.isNotEmpty && cantidad >= reciboFinal) {
      _billetesInicial = texto;
      return null;
    }
    return "Recibo inicial debe ser mayor  a ${billeteDistribuidor.reciboInicial} ";
  }

  String _validarFechaFin(String texto) {
    int cantidad = Util.checkInteger(texto);
    int reciboFinal = Util.checkInteger(billeteDistribuidor.reciboFinal);
    if (texto.isNotEmpty &&
        int.parse(texto) > int.parse(_billetesInicial) &&
        cantidad <= reciboFinal) {
      _billetesFin = texto;
      return null;
    }
    return "Recibo final debe ser menor  a ${billeteDistribuidor.reciboFinal} ";
  }

  BilletePuntoVenta _validarCampos() {
    final bool isValid = _formKey.currentState.validate();
    if (isValid) {
      BilletePuntoVenta billetePuntoVenta = widget.billetePuntoVenta.copyWith(
          estado: 2,
          reciboInicial: _billetesInicial,
          fechaInicioEntrega: _fechaInicioEntrega,
          fechaFinEntrega: _fechaFinEntrega,
          reciboFinal: _billetesFin,
          puntoVenta: _puntoVenta);

      return billetePuntoVenta;
    } else {
      _btnControllerRegistrar.reset();
      return null;
    }
  }

  _inicioEntrega({bool estado}) {
    if (!estado) {
      setState(() {
        _checkBoxValueInicioEntrega = estado;
        _fechaInicioEntrega = "";
        _checkBoxValueFinEntrega = false;
        _fechaFinEntrega = "";
      });
    } else {
      setState(() {
        _checkBoxValueInicioEntrega = estado;
        _fechaInicioEntrega = Utilidades.formatFecha(dateTime: DateTime.now());
      });
    }
  }

  _finEntrega({bool estado}) {
    if (!estado) {
      _checkBoxValueFinEntrega = estado;
      setState(() {
        _fechaFinEntrega = "";
      });
    } else {
      setState(() {
        _checkBoxValueFinEntrega = estado;
        _fechaFinEntrega = Utilidades.formatFecha(dateTime: DateTime.now());
      });
    }
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
        elevation: 2,
        backgroundColor: Colores.colorBody,
        title: Center(
          child: Text(
            "Entregar billete",
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colores.bodyColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
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
                          InputForm(
                            width: double.infinity,
                            label: "Edición",
                            icon: Icon(Icons.calendar_today),
                            maxLength: 20,
                            controller: _controllerEdicion,
                            validator: _validarEdicion,
                            enabled: false,
                          ),
                          InputForm(
                            width: double.infinity,
                            label: "Punto venta",
                            icon: Icon(Icons.store),
                            maxLength: 150,
                            controller: _controllerPuntoVenta,
                            validator: _validarZona,
                            enabled: false,
                          ),
                          InputForm(
                            enabled: false,
                            width: double.infinity,
                            label: "Recibo inicial",
                            icon: Icon(FontAwesomeIcons.moneyBillAlt),
                            maxLength: 20,
                            keyboardType: TextInputType.number,
                            controller: _controllerReciboInicial,
                            validator: _validarFechaInicial,
                            onChanged: (String valor) {
                              _calcularTotalBilletes();
                            },
                            onFieldSubmitted: (String valor) {
                              _calcularTotalBilletes();
                              _fecusFinal.nextFocus();
                            },
                          ),
                          InputForm(
                            enabled: false,
                            focusNone: _fecusFinal,
                            width: double.infinity,
                            label: "Recibo final",
                            icon: Icon(FontAwesomeIcons.moneyBill),
                            maxLength: 20,
                            keyboardType: TextInputType.number,
                            controller: _controllerReciboFinal,
                            validator: _validarFechaFin,
                            onChanged: (String valor) {
                              _calcularTotalBilletes();
                            },
                            onFieldSubmitted: (String valor) {
                              _calcularTotalBilletes();
                            },
                          ),
                          InputForm(
                            width: double.infinity,
                            label: "Cantidad",
                            icon: Icon(FontAwesomeIcons.campground),
                            maxLength: 20,
                            keyboardType: TextInputType.number,
                            controller: _controllerCantidad,
                            enabled: false,
                          ),
                          ListTile(
                            onTap: () {
                              if (_fechaInicioEntrega != "") {
                                DatePicker.showDateTimePicker(context,
                                    currentTime: Utilidades.formatDateTime(
                                        fecha: _fechaInicioEntrega),
                                    showTitleActions: true,
                                    minTime: DateTime(2020, 5, 5, 20, 50),
                                    onChanged: (date) {}, onConfirm: (date) {
                                  setState(() {
                                    _fechaInicioEntrega =
                                        Utilidades.formatFecha(dateTime: date);
                                  });
                                }, locale: LocaleType.es);
                              }
                            },
                            title: Text("Fecha inicio entrega"),
                            subtitle: Text(_fechaInicioEntrega),
                            trailing: Checkbox(
                                value: _checkBoxValueInicioEntrega,
                                activeColor: Colors.green,
                                onChanged: (bool estado) {
                                  _inicioEntrega(estado: estado);
                                }),
                          ),
                          ListTile(
                            onTap: () {
                              if (_fechaFinEntrega != "") {
                                DatePicker.showDateTimePicker(context,
                                    currentTime: Utilidades.formatDateTime(
                                        fecha: _fechaFinEntrega),
                                    showTitleActions: true,
                                    minTime: DateTime(2020, 5, 5, 20, 50),
                                    onChanged: (date) {}, onConfirm: (date) {
                                  setState(() {
                                    _fechaFinEntrega =
                                        Utilidades.formatFecha(dateTime: date);
                                  });
                                }, locale: LocaleType.es);
                              }
                            },
                            title: Text("Fecha llegada entrega"),
                            subtitle: Text(_fechaFinEntrega),
                            trailing: Checkbox(
                                value: _checkBoxValueFinEntrega,
                                activeColor: Colors.green,
                                onChanged: (bool estado) {
                                  _finEntrega(estado: estado);
                                }),
                          ),
                          ListTile(
                            trailing: IconButton(
                              icon: Icon(
                                Icons.person_pin_circle,
                                color: Colores.colorButton,
                                size: 30,
                              ),
                              onPressed: () {
                                if (widget.billetePuntoVenta.puntoVenta
                                        .geolocalizacion.direccion !=
                                    "") {
                                  abrirGoogleMaps();
                                }
                              },
                            ),
                            //leading: Icon(Icons.place),
                            title: Text(
                              "Dirección",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: Text(widget.billetePuntoVenta.puntoVenta
                                .geolocalizacion.direccion),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: BotonRedondo(
                              background: _edicion.estado == 1
                                  ? Colores.colorButton
                                  : Colores.textosColorGris,
                              width: butonSize * 1,
                              btnController: _btnControllerRegistrar,
                              titulo: "Entregar",
                              onPressed: () async {
                                if (_edicion.estado == 1) {
                                  BilletePuntoVenta billetePuntoVenta =
                                      _validarCampos();
                                  if (billetePuntoVenta != null) {
                                    dynamic response =
                                        await _billetePuntoVentaController
                                            .actualizarEntrega(
                                                billetePuntoVenta:
                                                    billetePuntoVenta,
                                                btnControllerRegistrar:
                                                    _btnControllerRegistrar);

                                    if (response) {
                                      Get.back(closeOverlays: true);
                                    }
                                  }
                                } else {
                                  _btnControllerRegistrar.reset();
                                }
                              },
                            ),
                          ),
                          SizedBox(height: rosponsive.heightPercent(2))
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Obx(() => _billetePuntoVentaController.cargando.value == true
                ? loading()
                : Container())
          ],
        ),
      ),
    );
  }

  abrirGoogleMaps() async {
    String homeLat =
        widget.billetePuntoVenta.puntoVenta.geolocalizacion.latitud.toString();
    String homeLng =
        widget.billetePuntoVenta.puntoVenta.geolocalizacion.longitud.toString();

    final String googleMapslocationUrl =
        "https://www.google.com/maps/search/?api=1&query=$homeLat,$homeLng";

    final String encodedURl = Uri.encodeFull(googleMapslocationUrl);

    if (await canLaunch(encodedURl)) {
      await launch(encodedURl);
    } else {
      print('Could not launch $encodedURl');
      throw 'Could not launch $encodedURl';
    }
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    dynamic billete = await _billetePuntoVentaController.billetePorEdicion(
        edicion: widget.billetePuntoVenta.edicion);
    if (billete != null) {
      billeteDistribuidor = billete;
      _init();
    }
  }
}
