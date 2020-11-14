import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:proyect_nortenio_app/data/models/billete_distribuidor_.dart';
import 'package:proyect_nortenio_app/data/models/billete_punto_venta.dart';
import 'package:proyect_nortenio_app/data/models/edicion.dart';
import 'package:proyect_nortenio_app/data/models/punto_venta.dart';
import 'package:proyect_nortenio_app/data/models/zonaMotorizado.dart';
import 'package:proyect_nortenio_app/global_widgets/botonRedondo.dart';
import 'package:proyect_nortenio_app/global_widgets/empty_state.dart';
import 'package:proyect_nortenio_app/global_widgets/input_form.dart';
import 'package:proyect_nortenio_app/global_widgets/loading_widget.dart';
import 'package:proyect_nortenio_app/modules/distribuidor/billete_punto_venta/billete_punto_venta_controller.dart';
import 'package:proyect_nortenio_app/utils/colores.dart';
import 'package:proyect_nortenio_app/utils/mensaje.dart';
import 'package:proyect_nortenio_app/utils/responsive.dart';
import 'package:proyect_nortenio_app/utils/util.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import 'item_motorizado_card.dart';
import 'item_punto_venta_card.dart';

class CrearScallfold extends StatefulWidget {
  final Edicion edicion;
  const CrearScallfold({Key key, @required this.edicion}) : super(key: key);
  @override
  _CrearScallfoldState createState() => _CrearScallfoldState();
}

class _CrearScallfoldState extends State<CrearScallfold> with AfterLayoutMixin {
  RoundedLoadingButtonController _btnControllerRegistrar;
  GlobalKey<FormState> _formKey;
  BilletePuntoVentaControllerD _billetePuntoVentaController = Get.find();

  String _billetesInicial = '', _subTitle = '', _billetesFin = '';

  PuntoVenta _puntoVenta;
  ZonaMotorizado _zonaMotorizado;
  Edicion _edicion;

  BilleteDistribuidor billeteDistribuidor;

  FocusNode _fecusFinal;
  TextEditingController _controllerPuntoVenta,
      _controllerMotorizado,
      _controllerEdicion,
      _controllerCantidad,
      _controllerReciboInicial,
      _controllerReciboFinal,
      _controllerDescripcion;

  Mensaje mensaje;

  @override
  void initState() {
    _formKey = GlobalKey();
    _btnControllerRegistrar = new RoundedLoadingButtonController();
    _fecusFinal = FocusNode();

    _controllerCantidad = new TextEditingController();
    _controllerEdicion = new TextEditingController();
    _controllerMotorizado = new TextEditingController();
    _controllerDescripcion = new TextEditingController();
    _controllerReciboInicial = new TextEditingController();
    _controllerReciboFinal = new TextEditingController();
    _controllerPuntoVenta = new TextEditingController();
    mensaje = new Mensaje();
    super.initState();
    _billetePuntoVentaController.cargando.value = false;
    _init();
  }

  _init() {
    _edicion = widget.edicion;
    _controllerEdicion.text = _edicion.numero;
  }

  @override
  void dispose() {
    _fecusFinal.dispose();
    _controllerEdicion.dispose();

    _controllerPuntoVenta.dispose();
    _controllerCantidad.dispose();
    _controllerDescripcion.dispose();
    _controllerReciboFinal.dispose();
    _controllerReciboInicial.dispose();
    _controllerMotorizado.dispose();
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

  String _validarEdicion(String texto) {
    if (texto.isNotEmpty) {
      return null;
    }
    return "Edición incorrecto";
  }

  String _validarEdicionInicial(String texto) {
    int cantidad = Util.checkInteger(texto);
    int reciboInicial = Util.checkInteger(billeteDistribuidor.reciboInicial);

    int reciboFinal = Util.checkInteger(billeteDistribuidor.reciboFinal);
    bool estado = false;
    String mensaje = "";
    if (cantidad >= reciboInicial && cantidad <= reciboFinal) {
      estado = true;
    } else if (cantidad < reciboInicial) {
      estado = false;
      mensaje =
          "Recibo inicio debe ser mayor  a ${billeteDistribuidor.reciboInicial} ";
    } else if (cantidad > reciboFinal) {
      estado = false;
      mensaje =
          "Recibo inicio debe ser menor  a ${billeteDistribuidor.reciboFinal} ";
    }
    if (texto.isNotEmpty && estado) {
      _billetesInicial = texto;
      return null;
    }
    return mensaje;
  }

  String _validarEdicionFin(String texto) {
    int cantidad = Util.checkInteger(texto);
    int reciboInicial = Util.checkInteger(billeteDistribuidor.reciboInicial);

    int reciboFinal = Util.checkInteger(billeteDistribuidor.reciboFinal);
    bool estado = false;
    String mensaje = "";
    if (cantidad > Util.checkInteger(_billetesInicial)) {
      estado = true;
    } else {
      estado = false;
      mensaje = "Recibo final debe ser mayor a $_billetesInicial";
    }

    if (cantidad >= reciboInicial && cantidad <= reciboFinal) {
      estado = true;
    } else if (cantidad < Util.checkInteger(_billetesInicial)) {
      estado = false;
      mensaje = "Recibo final debe ser mayor  a $_billetesInicial ";
    } else if (cantidad > reciboFinal) {
      estado = false;
      mensaje =
          "Recibo final debe ser menor  a ${billeteDistribuidor.reciboFinal} ";
    }

    if (texto.isNotEmpty && estado) {
      _billetesFin = texto;
      return null;
    }
    return mensaje;
  }

  bool estaDentroFechaFin(String billete) {
    bool estado = false;

    return estado;
  }

  BilletePuntoVenta _validarCampos() {
    final bool isValid = _formKey.currentState.validate();
    if (isValid) {
      BilletePuntoVenta billetePuntoVenta = new BilletePuntoVenta(
          edicion: _edicion,
          estado: 1,
          reciboInicial: _billetesInicial,
          reciboFinal: _billetesFin,
          zonaMotorizado: _zonaMotorizado,
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
          child: ListTile(
            subtitle: Text(
              _subTitle,
              style: TextStyle(
                color: Colores.bodyColor,
              ),
            ),
            title: Text(
              "Registrar billete",
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colores.bodyColor,
                fontWeight: FontWeight.bold,
              ),
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
                          Stack(
                            children: [
                              InputForm(
                                keyboardType: TextInputType.phone,
                                width: 168,
                                label: "Punta venta",
                                enabled: false,
                                icon: Icon(Icons.view_carousel),
                                onFieldSubmitted: (String text) {
                                  _formKey.currentState.reset();
                                },
                                maxLength: 150,
                                controller: _controllerPuntoVenta,
                                validator: _validarPuntoVenta,
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
                                        mostrarBuscarPuntoVenta(
                                            context: context,
                                            puntoVenta: _puntoVenta);
                                      }),
                                ),
                              )
                            ],
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
                            validator: _validarEdicionInicial,
                            onChanged: (String valor) {
                              _calcularTotalBilletes();
                            },
                            onFieldSubmitted: (String valor) {
                              _calcularTotalBilletes();
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
                            validator: _validarEdicionFin,
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
                            icon: Icon(Icons.people),
                            maxLength: 20,
                            keyboardType: TextInputType.phone,
                            controller: _controllerCantidad,
                            enabled: false,
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
                              titulo: "Registrar",
                              onPressed: () async {
                                BilletePuntoVenta billetePuntoVenta =
                                    _validarCampos();
                                if (billetePuntoVenta != null) {
                                  dynamic response =
                                      await _billetePuntoVentaController
                                          .registrar(
                                              billetePuntoVenta:
                                                  billetePuntoVenta,
                                              btnControllerRegistrar:
                                                  _btnControllerRegistrar);

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
    dynamic billete = await _billetePuntoVentaController.billetePorEdicion(
        edicion: widget.edicion);

    billeteDistribuidor = billete;
    if (billeteDistribuidor == null) {
      Get.back();
    }
    setState(() {
      _subTitle = "Billetes de" +
          billeteDistribuidor.reciboInicial +
          " hasta  " +
          billeteDistribuidor.reciboFinal;
    });

    if (await _billetePuntoVentaController.cargarListaPuntoVentas(
        edicion: widget.edicion)) {
      if (await _billetePuntoVentaController.cargarListaMotorizados(
          edicion: widget.edicion)) {
      } else {
        Get.back();
      }
    } else {
      Get.back();
    }
  }

  Future mostrarBuscarPuntoVenta(
      {BuildContext context, PuntoVenta puntoVenta}) async {
    final lista = _billetePuntoVentaController.listaPuntaVentas.toList();
    dynamic aux = await showSearch(
        context: context,
        delegate:
            BuscarPuntoVenta(listsZona: lista, puntoSeleccionado: puntoVenta));
    if (aux == null) {
      if (_puntoVenta != null) {
        _controllerPuntoVenta.text = _puntoVenta.razonSocial;
      } else {
        _controllerPuntoVenta.text = "";
      }
    } else if (aux != null) {
      _puntoVenta = aux;
      _controllerPuntoVenta.text = _puntoVenta.razonSocial;
    } else {
      _controllerPuntoVenta.text = "";
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
                p.razonSocial.toLowerCase().contains(query.toLowerCase()))
            .toList();

    return myList.isEmpty
        ? EmptyState()
        : ListView.builder(
            itemCount: myList.length,
            itemBuilder: (context, index) {
              final PuntoVenta puntoVenta = myList[index];
              bool estado = puntoSeleccionado != null
                  ? puntoVenta.id == puntoSeleccionado.id
                      ? true
                      : false
                  : false;
              return ItemPuntoVentaCard(
                  isSelected: estado,
                  puntoVenta: puntoVenta,
                  onTapActualizar: () {
                    close(context, puntoVenta);
                  });
            },
          );
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
