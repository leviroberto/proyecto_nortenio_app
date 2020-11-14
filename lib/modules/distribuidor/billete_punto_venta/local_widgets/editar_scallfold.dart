import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:proyect_nortenio_app/data/models/billete_distribuidor_.dart';
import 'package:proyect_nortenio_app/data/models/billete_punto_venta.dart';
import 'package:proyect_nortenio_app/data/models/edicion.dart';
import 'package:proyect_nortenio_app/data/models/punto_venta.dart';
import 'package:proyect_nortenio_app/data/models/zonaMotorizado.dart';
import 'package:proyect_nortenio_app/global_widgets/botonRedondo.dart';
import 'package:proyect_nortenio_app/global_widgets/detalle_item.dart';
import 'package:proyect_nortenio_app/global_widgets/empty_state.dart';
import 'package:proyect_nortenio_app/global_widgets/input_form.dart';
import 'package:proyect_nortenio_app/global_widgets/loading_widget.dart';
import 'package:proyect_nortenio_app/modules/distribuidor/billete_punto_venta/billete_punto_venta_controller.dart';
import 'package:proyect_nortenio_app/utils/colores.dart';
import 'package:proyect_nortenio_app/utils/responsive.dart';
import 'package:proyect_nortenio_app/utils/util.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import 'item_motorizado_card.dart';

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
  BilletePuntoVentaControllerD _billetePuntoVentaController = Get.find();
  ZonaMotorizado _zonaMotorizado;
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
      _controllerEdicion,
      _controllerMotorizado,
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
    _controllerMotorizado = new TextEditingController();
    _controllerEdicion = new TextEditingController();
    _controllerDescripcion = new TextEditingController();
    _controllerReciboInicial = new TextEditingController();
    _controllerReciboFinal = new TextEditingController();
    _controllerPuntoVenta = new TextEditingController();
    _controllerCantidadDevuelto = new TextEditingController();

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
      _estado = getEstadoLetra(estado: widget.billetePuntoVenta.estado);
      _controllerPuntoVenta.text = _puntoVenta.propietario;
      _controllerCantidadDevuelto.text =
          widget.billetePuntoVenta.cantidadDevuelto;
      _controllerReciboInicial.text = widget.billetePuntoVenta.reciboInicial;
      _controllerReciboFinal.text = widget.billetePuntoVenta.reciboFinal;
      _cantidadVendida = widget.billetePuntoVenta.cantidadVendida;
      _controllerCantidadVendida.text =
          widget.billetePuntoVenta.cantidadVendida;
      _zonaMotorizado = widget.billetePuntoVenta.zonaMotorizado;
      _controllerMotorizado.text = _zonaMotorizado.motorizado.nombreCompleto;

      _calcularTotalBilletes();
      _realizarCalculos();
    });
  }

  int getEstadoNumero({String estado}) {
    int aux = 1;
    if (estado == 'Activo') {
      aux = 1;
    } else if (estado == "Entregado") {
      aux = 2;
    } else if (estado == "Recogido") {
      aux = 3;
    }
    return aux;
  }

  String getEstadoLetra({int estado}) {
    String aux = 'Activo';
    if (estado == 1) {
      aux = 'Activo';
    } else if (estado == 2) {
      aux = "Entregado";
    } else if (estado == 3) {
      aux = "Recogido";
    }
    return aux;
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
    _controllerMotorizado.dispose();

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

  String _validarPuntoVenta(String texto) {
    if (texto.isNotEmpty) {
      return null;
    }
    return "Punto venta incorrecto";
  }

  String _validarMotorizado(String texto) {
    if (texto.isNotEmpty) {
      return null;
    }
    return "Motorizado incorrecto";
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
    return "Edición incorrecto";
  }

  String _validarFechaInicial(String texto) {
    int cantidad = Util.checkInteger(texto);
    int reciboFinal = Util.checkInteger(billeteDistribuidor.reciboInicial);
    if (texto.isNotEmpty && cantidad >= reciboFinal) {
      _billetesInicial = texto;
      return null;
    }
    return "Recibo inicio debe ser mayor  a ${billeteDistribuidor.reciboInicial} ";
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
    return "Recibo fin debe ser menor  a ${billeteDistribuidor.reciboFinal} ";
  }

  BilletePuntoVenta _validarCampos() {
    final bool isValid = _formKey.currentState.validate();
    if (isValid) {
      BilletePuntoVenta billetePuntoVenta = new BilletePuntoVenta(
          edicion: _edicion,
          estado: getEstadoNumero(estado: _estado),
          cantidadExtraviada: _cantidadExtraviada,
          cantidadVendida: _cantidadVendida,
          porcentajeDescuento: _porcentajeDescuento,
          id: widget.billetePuntoVenta.id,
          reciboInicial: _billetesInicial,
          zonaMotorizado: _zonaMotorizado,
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
        elevation: 1,
        backgroundColor: Colores.colorBody,
        title: Center(
          child: Text(
            "Editar billete",
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
                            label: "Edicion",
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
                            validator: _validarPuntoVenta,
                            enabled: false,
                          ),
                          Stack(
                            children: [
                              InputForm(
                                keyboardType: TextInputType.phone,
                                width: 168,
                                label: "Motorizado",
                                enabled: false,
                                icon: Icon(Icons.view_carousel),
                                onFieldSubmitted: (String text) {
                                  _formKey.currentState.reset();
                                },
                                maxLength: 150,
                                controller: _controllerMotorizado,
                                validator: _validarMotorizado,
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
                                        mostrarBuscarMotorizado(
                                            context: context,
                                            zonaMotorizado: _zonaMotorizado);
                                      }),
                                ),
                              )
                            ],
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
                                    items: <String>[
                                      'Activo',
                                      'Entregado',
                                      'Recogido'
                                    ].map<DropdownMenuItem<String>>(
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
                                            .actualizar(
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

  @override
  void afterFirstLayout(BuildContext context) async {
    if (await _billetePuntoVentaController.cargarConfiguracion()) {
      dynamic billete = await _billetePuntoVentaController.billetePorEdicion(
          edicion: widget.billetePuntoVenta.edicion);
      if (billete != null) {
        if (await _billetePuntoVentaController.cargarListaMotorizados(
            edicion: widget.billetePuntoVenta.edicion)) {
          billeteDistribuidor = billete;
          _init();
        } else {
          Get.back();
        }
      }
    }
  }

  Future mostrarBuscarMotorizado(
      {BuildContext context, ZonaMotorizado zonaMotorizado}) async {
    final lista = _billetePuntoVentaController.listaMotorizados.toList();
    dynamic aux = await showSearch(
        context: context,
        delegate: BuscarMotorizados(
            listsZona: lista, zonaMotorizadoSeleccionado: zonaMotorizado));
    if (aux == null) {
      if (_zonaMotorizado != null) {
        _controllerMotorizado.text = _zonaMotorizado.motorizado.nombreCompleto;
      } else {
        _controllerMotorizado.text = "";
      }
    } else if (aux != null) {
      _zonaMotorizado = aux;
      _controllerMotorizado.text = _zonaMotorizado.motorizado.nombreCompleto;
    } else {
      _controllerMotorizado.text = "";
    }
  }
}

class BuscarMotorizados extends SearchDelegate<ZonaMotorizado> {
  final List<ZonaMotorizado> listsZona;
  ZonaMotorizado zonaMotorizadoSeleccionado;

  BuscarMotorizados({this.listsZona, this.zonaMotorizadoSeleccionado});

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
          close(context, zonaMotorizadoSeleccionado);
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
            .where((p) => p.motorizado.nombreCompleto
                .toLowerCase()
                .contains(query.toLowerCase()))
            .toList();

    return myList.isEmpty
        ? EmptyState()
        : ListView.builder(
            itemCount: myList.length,
            itemBuilder: (context, index) {
              ZonaMotorizado zonaMotorizado = myList[index];
              bool estado = zonaMotorizadoSeleccionado != null
                  ? zonaMotorizado.id == zonaMotorizadoSeleccionado.id
                      ? true
                      : false
                  : false;
              return ItemMotorizadoCard(
                  isSelected: estado,
                  zonaMotorizado: zonaMotorizado,
                  onTapActualizar: () {
                    close(context, zonaMotorizado);
                  });
            },
          );
  }
}
