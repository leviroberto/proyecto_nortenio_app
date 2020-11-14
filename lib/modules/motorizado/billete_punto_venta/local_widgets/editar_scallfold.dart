import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:proyect_nortenio_app/data/models/billete_distribuidor_.dart';
import 'package:proyect_nortenio_app/data/models/billete_punto_venta.dart';
import 'package:proyect_nortenio_app/data/models/edicion.dart';
import 'package:proyect_nortenio_app/data/models/punto_venta.dart';
import 'package:proyect_nortenio_app/global_widgets/botonRedondo.dart';
import 'package:proyect_nortenio_app/global_widgets/detalle_item.dart';
import 'package:proyect_nortenio_app/global_widgets/input_form.dart';
import 'package:proyect_nortenio_app/global_widgets/loading_widget.dart';
import 'package:proyect_nortenio_app/modules/motorizado/billete_punto_venta/billete_punto_venta_controller.dart';
import 'package:proyect_nortenio_app/utils/colores.dart';
import 'package:proyect_nortenio_app/utils/responsive.dart';
import 'package:proyect_nortenio_app/utils/util.dart';
import 'package:proyect_nortenio_app/utils/utilidades.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:url_launcher/url_launcher.dart';

class EditarScallfold extends StatefulWidget {
  final BilletePuntoVenta billetePuntoVenta;
  const EditarScallfold({Key key, @required this.billetePuntoVenta})
      : super(key: key);
  @override
  _EditarScallfoldState createState() => _EditarScallfoldState();
}

class _EditarScallfoldState extends State<EditarScallfold>
    with AfterLayoutMixin {
  RoundedLoadingButtonController _btnControllerRegistrar;
  GlobalKey<FormState> _formKey;
  BilletePuntoVentaControllerM _billetePuntoVentaController = Get.find();

  String _billetesInicial = '',
      _billetesFin = '',
      _montoPagadoPorcentaje = '0',
      _montoPagado = '0',
      _montoExtraviado = '0',
      _montoVendido = '0',
      _precioBillete = '0',
      _porcentajeDescuento = '0',
      _cantidadExtraviada = '0',
      _cantidadDevuelto = '0',
      _estado = 'Activo',
      _cantidadVendida = '0';

  PuntoVenta _puntoVenta;
  Edicion _edicion;

  FocusNode _fecusFinal, _focusCantidadVendida, _focusCantidadDevuelto;
  BilleteDistribuidor billeteDistribuidor;

  TextEditingController _controllerPuntoVenta,
      _controllerFechaEntrega,
      _controllerFechaRecojo,
      _controllerEdicion,
      _controllerCantidad,
      _controllerReciboInicial,
      _controllerCantidadVendida,
      _controllerCantidadDevuelto,
      _controllerReciboFinal,
      _controllerMontoExtraviado,
      _controllerDescripcion;

  @override
  void initState() {
    _formKey = GlobalKey();
    _btnControllerRegistrar = new RoundedLoadingButtonController();
    _fecusFinal = FocusNode();
    _focusCantidadDevuelto = FocusNode();
    _focusCantidadVendida = FocusNode();

    _controllerCantidad = new TextEditingController();
    _controllerEdicion = new TextEditingController();
    _controllerDescripcion = new TextEditingController();
    _controllerReciboInicial = new TextEditingController();
    _controllerReciboFinal = new TextEditingController();
    _controllerPuntoVenta = new TextEditingController();
    _controllerCantidadDevuelto = new TextEditingController();
    _controllerFechaEntrega = new TextEditingController();
    _controllerFechaRecojo = new TextEditingController();

    _controllerMontoExtraviado = new TextEditingController();
    _controllerCantidadVendida = new TextEditingController();

    super.initState();
    _billetePuntoVentaController.cargando.value = false;
    _edicion = widget.billetePuntoVenta.edicion;
    _puntoVenta = widget.billetePuntoVenta.puntoVenta;
  }

  _init() {
    setState(() {
      _controllerEdicion.text = _edicion.numero;

      if (widget.billetePuntoVenta.porcentajeDescuento != "" &&
          widget.billetePuntoVenta.porcentajeDescuento != null) {
        _porcentajeDescuento = widget.billetePuntoVenta.porcentajeDescuento;
      } else {
        _porcentajeDescuento = _billetePuntoVentaController
            .configuracion.value.porcentajeDescuento;
      }

      if (widget.billetePuntoVenta.precioBillete != "" &&
          widget.billetePuntoVenta.precioBillete != null) {
        _precioBillete = widget.billetePuntoVenta.precioBillete;
      } else {
        _precioBillete =
            _billetePuntoVentaController.configuracion.value.precioBillete;
      }
      _estado = widget.billetePuntoVenta.estado == 1 ? "Activo" : "Pagado";
      _controllerPuntoVenta.text = _puntoVenta.propietario;
      _controllerCantidadDevuelto.text =
          widget.billetePuntoVenta.cantidadDevuelto;
      _controllerReciboInicial.text = widget.billetePuntoVenta.reciboInicial;
      _controllerReciboFinal.text = widget.billetePuntoVenta.reciboFinal;
      _cantidadVendida = widget.billetePuntoVenta.cantidadVendida;
      _controllerCantidadVendida.text =
          widget.billetePuntoVenta.cantidadVendida;
      /* _controllerFechaEntrega.text = widget.billetePuntoVenta.fechaEntrega;
      _controllerFechaRecojo.text = widget.billetePuntoVenta.fechaRecojo; */
      _calcularTotalBilletes();
      _realizarCalculos();
    });
  }

  @override
  void dispose() {
    _fecusFinal.dispose();
    _controllerEdicion.dispose();
    _focusCantidadVendida.dispose();
    _focusCantidadDevuelto.dispose();

    _controllerCantidadVendida.dispose();
    _controllerCantidadDevuelto.dispose();
    _controllerPuntoVenta.dispose();
    _controllerCantidad.dispose();
    _controllerDescripcion.dispose();
    _controllerReciboFinal.dispose();
    _controllerReciboInicial.dispose();
    _controllerFechaEntrega.dispose();
    _controllerFechaRecojo.dispose();
    _controllerMontoExtraviado.dispose();

    super.dispose();
  }

  _realizarCalculos() {
    _calcularMontoVendido();

    _calcularCantidadExtraviada();
    _calcularMontoExtraviado();
    _calcularMontoPagadoPorcentaje();
    _calcularMontoPagado();
  }

  _calcularCantidadExtraviada() {
    String cantidadEntregada = _controllerCantidad.text;
    String cantidadDevuelto = _controllerCantidadDevuelto.text;
    String cantidadVendida = _controllerCantidadVendida.text;

    int reciboInicial =
        cantidadEntregada == "" ? 0 : int.parse(cantidadEntregada);
    int reciboDevuelto =
        cantidadDevuelto == "" ? 0 : int.parse(cantidadDevuelto);
    int reciboFinal = cantidadVendida == "" ? 0 : int.parse(cantidadVendida);
    String texto = "0";
    if (reciboInicial > 0 && reciboFinal > 0) {
      int cantidad = reciboInicial - (reciboFinal + reciboDevuelto);
      if (cantidad > 0) {
        texto = cantidad.toString();
      } else {
        texto = "0";
      }
    } else {
      texto = "0";
    }

    setState(() {
      _cantidadExtraviada = texto;
    });
  }

  _calcularMontoExtraviado() {
    String cantidadExtraviado = _cantidadExtraviada;
    String montoBilleteExtraviado = _billetePuntoVentaController
        .configuracion.value.precioBilleteExtraviado;

    int reciboInicial =
        cantidadExtraviado == "" ? 0 : int.parse(cantidadExtraviado);

    int reciboFinal =
        montoBilleteExtraviado == "" ? 0 : int.parse(montoBilleteExtraviado);

    String texto = "0";
    if (reciboInicial > 0 && reciboFinal > 0) {
      int cantidad = reciboInicial * reciboFinal;
      if (cantidad > 0) {
        texto = cantidad.toString();
      } else {
        texto = "0";
      }
    } else {
      texto = "0";
    }

    setState(() {
      _montoExtraviado = texto;
    });
  }

  _calcularMontoPagadoPorcentaje() {
    String montoVendido = _montoVendido;
    String porcentaje = _porcentajeDescuento;

    int reciboInicial = montoVendido == "" ? 0 : int.parse(montoVendido);
    int reciboFinal = porcentaje == "" ? 0 : int.parse(porcentaje);
    String texto = "0";
    if (reciboInicial > 0 && reciboFinal > 0) {
      double monto = (reciboFinal * reciboInicial) / 100;
      if (monto > 0) {
        texto = monto.toString();
      } else {
        texto = "0";
      }
    } else {
      texto = "0";
    }

    setState(() {
      _montoPagadoPorcentaje = texto;
    });
  }

  _calcularMontoPagado() {
    String montoVendido = _montoPagadoPorcentaje;
    String porcentaje = _montoExtraviado;

    double reciboInicial = montoVendido == "" ? 0 : double.parse(montoVendido);
    int reciboFinal = porcentaje == "" ? 0 : int.parse(porcentaje);
    String texto = "0";
    if (reciboInicial >= 0 && reciboFinal >= 0) {
      double monto = reciboInicial - reciboFinal;
      if (monto > 0) {
        texto = monto.toString();
      } else {
        texto = "0";
      }
    } else {
      texto = "0";
    }

    setState(() {
      _montoPagado = texto;
    });
  }

  _calcularMontoVendido() {
    String cantidadVendida = _controllerCantidadVendida.text;
    String precioBillete = _precioBillete;

    int reciboInicial = cantidadVendida == "" ? 0 : int.parse(cantidadVendida);
    int reciboFinal = precioBillete == "" ? 0 : int.parse(precioBillete);
    String texto = "0";
    if (reciboInicial > 0 && reciboFinal > 0) {
      int monto = reciboFinal * reciboInicial;
      if (monto > 0) {
        texto = monto.toString();
      } else {
        texto = "0";
      }
    } else {
      texto = "0";
    }

    setState(() {
      _montoVendido = texto;
    });
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

  String _validarCantidadVendida(String texto) {
    int cantidadEntregado = Util.checkInteger(_controllerCantidad.text);
    int catidadVendido = Util.checkInteger(texto);
    String mensaje;
    if (texto.isEmpty) {
      _cantidadVendida = texto;
      mensaje = null;
    } else if (catidadVendido <= cantidadEntregado) {
      _cantidadVendida = texto;
      mensaje = null;
    } else if (catidadVendido > cantidadEntregado) {
      mensaje = "La cantidad vendida debe ser menor a $cantidadEntregado";
    }

    return mensaje;
  }

  String _validarCantidadDevuelto(String texto) {
    _cantidadDevuelto = texto;
    return null;
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
      BilletePuntoVenta billetePuntoVenta = new BilletePuntoVenta(
          edicion: _edicion,
          estado: _estado == "Activo" ? 1 : 0,
          cantidadExtraviada: _cantidadExtraviada,
          cantidadVendida: _cantidadVendida,
          porcentajeDescuento: _porcentajeDescuento,
          id: widget.billetePuntoVenta.id,
          reciboInicial: _billetesInicial,
          reciboFinal: _billetesFin,
          cantidadDevuelto: _cantidadDevuelto,
          precioBillete:
              _billetePuntoVentaController.configuracion.value.precioBillete,
          precioBilleteExtraviado: _billetePuntoVentaController
              .configuracion.value.precioBilleteExtraviado,
          puntoVenta: _puntoVenta);
      return billetePuntoVenta;
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
            "Actualizar billete",
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
                            icon: Icon(Icons.people),
                            maxLength: 20,
                            controller: _controllerEdicion,
                            validator: _validarEdicion,
                            enabled: false,
                          ),
                          InputForm(
                            width: double.infinity,
                            label: "Punto venta",
                            icon: Icon(Icons.view_carousel),
                            maxLength: 150,
                            controller: _controllerPuntoVenta,
                            validator: _validarZona,
                            enabled: false,
                          ),
                          InputForm(
                            width: double.infinity,
                            label: "Recibo inicial",
                            icon: Icon(Icons.people),
                            maxLength: 20,
                            keyboardType: TextInputType.phone,
                            controller: _controllerReciboInicial,
                            validator: _validarFechaInicial,
                            onChanged: (String valor) {
                              _calcularTotalBilletes();
                              _realizarCalculos();
                            },
                            onFieldSubmitted: (String valor) {
                              _calcularTotalBilletes();
                              _realizarCalculos();
                              _fecusFinal.nextFocus();
                            },
                          ),
                          InputForm(
                            focusNone: _fecusFinal,
                            width: double.infinity,
                            label: "Recibo final",
                            icon: Icon(Icons.people),
                            maxLength: 20,
                            keyboardType: TextInputType.phone,
                            controller: _controllerReciboFinal,
                            validator: _validarFechaFin,
                            onChanged: (String valor) {
                              _calcularTotalBilletes();
                              _realizarCalculos();
                            },
                            onFieldSubmitted: (String valor) {
                              _calcularTotalBilletes();
                              _realizarCalculos();
                            },
                          ),
                          Stack(
                            children: [
                              InputForm(
                                width: 168,
                                label: "Fecha de entrega",
                                enabled: false,
                                icon: Icon(Icons.timer),
                                onFieldSubmitted: (String text) {
                                  _formKey.currentState.reset();
                                },
                                maxLength: 150,
                                controller: _controllerFechaEntrega,
                              ),
                              Positioned(
                                right: 3,
                                top: 4,
                                child: Transform.scale(
                                  scale: 1.54,
                                  child: FlatButton(
                                      onPressed: () {
                                        DatePicker.showDateTimePicker(context,
                                            currentTime:
                                                Utilidades.formatDateTime(
                                                    fecha:
                                                        _controllerFechaEntrega
                                                            .text),
                                            showTitleActions: true,
                                            minTime:
                                                DateTime(2020, 5, 5, 20, 50),
                                            onChanged: (date) {},
                                            onConfirm: (date) {
                                          _controllerFechaEntrega.text =
                                              Utilidades.formatFecha(
                                                  dateTime: date);
                                        }, locale: LocaleType.es);
                                      },
                                      child: Icon(
                                        Icons.search,
                                        color: Colores.textosColorGris,
                                      )),
                                ),
                              )
                            ],
                          ),
                          Stack(
                            children: [
                              InputForm(
                                width: 168,
                                label: "Fecha de recojo",
                                enabled: false,
                                icon: Icon(Icons.timer),
                                onFieldSubmitted: (String text) {
                                  _formKey.currentState.reset();
                                },
                                maxLength: 150,
                                controller: _controllerFechaRecojo,
                              ),
                              Positioned(
                                right: 3,
                                top: 4,
                                child: Transform.scale(
                                  scale: 1.54,
                                  child: FlatButton(
                                      onPressed: () {
                                        DatePicker.showDateTimePicker(context,
                                            currentTime:
                                                Utilidades.formatDateTime(
                                                    fecha:
                                                        _controllerFechaRecojo
                                                            .text),
                                            showTitleActions: true,
                                            minTime:
                                                DateTime(2020, 5, 5, 20, 50),
                                            onChanged: (date) {},
                                            onConfirm: (date) {
                                          _controllerFechaRecojo.text =
                                              Utilidades.formatFecha(
                                                  dateTime: date);
                                        }, locale: LocaleType.es);
                                      },
                                      child: Icon(
                                        Icons.search,
                                        color: Colores.textosColorGris,
                                      )),
                                ),
                              )
                            ],
                          ),
                          InputForm(
                            width: double.infinity,
                            label: "Cantidad entregada",
                            icon: Icon(Icons.people),
                            maxLength: 20,
                            keyboardType: TextInputType.phone,
                            controller: _controllerCantidad,
                            enabled: false,
                          ),
                          InputForm(
                            focusNone: _focusCantidadVendida,
                            width: double.infinity,
                            label: "Cantidad vendida",
                            icon: Icon(Icons.people),
                            maxLength: 20,
                            enabled:
                                widget.billetePuntoVenta.edicion.estado == 1
                                    ? true
                                    : false,
                            keyboardType: TextInputType.phone,
                            controller: _controllerCantidadVendida,
                            validator: _validarCantidadVendida,
                            onChanged: (String valor) {
                              _cantidadVendida = valor;
                              _realizarCalculos();
                            },
                            onFieldSubmitted: (String valor) {
                              _realizarCalculos();
                              _focusCantidadDevuelto.nextFocus();
                            },
                          ),
                          InputForm(
                            focusNone: _focusCantidadDevuelto,
                            width: double.infinity,
                            label: "Cantidad Devuelto",
                            icon: Icon(Icons.people),
                            maxLength: 20,
                            enabled:
                                widget.billetePuntoVenta.edicion.estado == 1
                                    ? true
                                    : false,
                            keyboardType: TextInputType.phone,
                            controller: _controllerCantidadDevuelto,
                            validator: _validarCantidadDevuelto,
                            onChanged: (String valor) {
                              _cantidadDevuelto = valor;
                              _realizarCalculos();
                            },
                            onFieldSubmitted: (String valor) {
                              _realizarCalculos();
                            },
                          ),
                          DetalleItem(
                            textoDerecha: "%. $_porcentajeDescuento",
                            textoIzquierda: "Porcentaje descuento",
                          ),
                          DetalleItem(
                            textoDerecha: "S/. $_precioBillete",
                            textoIzquierda: "Precio por boleta",
                          ),
                          DetalleItem(
                            textoDerecha: "U/. $_cantidadExtraviada",
                            textoIzquierda: "Cantidad extraviada",
                          ),
                          DetalleItem(
                            textoDerecha: "S/. $_montoVendido",
                            textoIzquierda: "Monto vendido",
                          ),
                          DetalleItem(
                            textoDerecha: "S/. $_montoExtraviado",
                            textoIzquierda: "Monto extraviado",
                          ),
                          DetalleItem(
                            textoDerecha: "S/. $_montoPagadoPorcentaje",
                            textoIzquierda: "Monto Porcentaje",
                          ),
                          DetalleItem(
                            textoDerecha: "S/. $_montoPagado",
                            textoIzquierda: "Monto Pagado",
                          ),
                          ListTile(
                            trailing: IconButton(
                              icon: Icon(
                                Icons.person_pin_circle,
                                color: Colores.colorButton,
                                size: 30,
                              ),
                              onPressed: () {
                                abrirGoogleMaps();
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
                            subtitle: Text(widget.billetePuntoVenta.puntoVenta
                                .geolocalizacion.direccion),
                          ),
                          Container(
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
                                    items: <String>['Activo', 'Pagado']
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
                              background: _edicion.estado == 1
                                  ? Colores.colorButton
                                  : Colores.textosColorGris,
                              icon: Icon(
                                Icons.save,
                                color: Colors.white,
                                size: 30,
                              ),
                              width: butonSize * 0.9,
                              btnController: _btnControllerRegistrar,
                              titulo: "Actualizar",
                              onPressed: () async {
                                if (_edicion.estado == 1) {
                                  BilletePuntoVenta billetePuntoVenta =
                                      _validarCampos();
                                  if (billetePuntoVenta != null) {
                                    dynamic response =
                                        await _billetePuntoVentaController
                                            .actualizarRecojo(
                                                billetePuntoVenta:
                                                    billetePuntoVenta,
                                                btnControllerRegistrar:
                                                    _btnControllerRegistrar);

                                    if (response) {
                                      Get.back();
                                    }
                                  }
                                } else {
                                  _btnControllerRegistrar.reset();
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
    if (await _billetePuntoVentaController.cargarConfiguracion()) {
      dynamic billete = await _billetePuntoVentaController.billetePorEdicion(
          edicion: widget.billetePuntoVenta.edicion);
      if (billete != null) {
        billeteDistribuidor = billete;
        _init();
      }
    }
  }

  Future mostrarBuscarPuntoVenta(
      {BuildContext context, PuntoVenta puntoVenta}) async {
    final lista = _billetePuntoVentaController.listaPuntaVentas.toList();
    _puntoVenta = await showSearch(
        context: context,
        delegate:
            BuscarPuntoVenta(listsZona: lista, puntoSeleccionado: puntoVenta));
    if (_puntoVenta != null) {
      _controllerPuntoVenta.text = _puntoVenta.propietario;
    } else {
      _controllerPuntoVenta.text = "";
    }
  }
}

class BuscarPuntoVenta extends SearchDelegate<PuntoVenta> {
  final List<PuntoVenta> listsZona;
  PuntoVenta puntoSeleccionado;

  BuscarPuntoVenta({this.listsZona, this.puntoSeleccionado});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          close(context, puntoSeleccionado);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final myList = query.isEmpty
        ? listsZona
        : listsZona
            .where((p) =>
                p.propietario.toLowerCase().contains(query.toLowerCase()))
            .toList();

    return myList.isEmpty
        ? Text("No encontrado")
        : ListView.builder(
            itemCount: myList.length,
            itemBuilder: (context, index) {
              final PuntoVenta puntoVenta = myList[index];
              bool estado = puntoSeleccionado != null
                  ? puntoVenta.id == puntoSeleccionado.id
                      ? true
                      : false
                  : false;
              return ListTile(
                onTap: () {
                  close(context, puntoVenta);
                },
                title: Text(
                  puntoVenta.propietario,
                  style:
                      TextStyle(color: estado ? Colors.black38 : Colors.black),
                ),
                subtitle: Text(puntoVenta.celular,
                    style: TextStyle(
                        color: estado ? Colors.black38 : Colors.black)),
              );
            },
          );
  }
}
