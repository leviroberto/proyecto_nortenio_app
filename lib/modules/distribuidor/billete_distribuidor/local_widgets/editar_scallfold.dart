import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:proyect_nortenio_app/data/models/billete_distribuidor_.dart';
import 'package:proyect_nortenio_app/data/models/billete_punto_venta.dart';
import 'package:proyect_nortenio_app/data/models/edicion.dart';
import 'package:proyect_nortenio_app/data/models/zona.dart';
import 'package:proyect_nortenio_app/global_widgets/detalle_item.dart';
import 'package:proyect_nortenio_app/global_widgets/input_form.dart';
import 'package:proyect_nortenio_app/global_widgets/loading_widget.dart';
import 'package:proyect_nortenio_app/utils/colores.dart';

import '../billete_distribuidor_controller.dart';
import 'item_detalle_card.dart';

class EditarScallfold extends StatefulWidget {
  static const routeName = 'editar_billete_distribuidor';
  final BilleteDistribuidor billete;

  const EditarScallfold({Key key, this.billete}) : super(key: key);
  @override
  _EditarScallfoldState createState() => _EditarScallfoldState();
}

class _EditarScallfoldState extends State<EditarScallfold>
    with AfterLayoutMixin {
  GlobalKey<FormState> _formKey;
  BilleteControllerD _billetesController = Get.find();

  String _montoPagadoPorcentaje = '0',
      _montoPagado = '0',
      _montoExtraviado = '0',
      _montoVendido = '0',
      _precioBillete = '0',
      _porcentajeDescuento = '0',
      _cantidadExtraviada = '0',
      _cantidadDevuelto = '0',
      _cantidadVendida = '0';
  Zona _zona;
  Edicion _edicion;

  FocusNode _fecusFinal;
  TextEditingController _controllerZona,
      _controllerEdicion,
      _controllerCantidad,
      _controllerReciboInicial,
      _controllerReciboFinal,
      _controllerDescripcion;

  @override
  void initState() {
    _formKey = GlobalKey();
    _fecusFinal = FocusNode();

    _controllerZona = new TextEditingController();
    _controllerCantidad = new TextEditingController();
    _controllerEdicion = new TextEditingController();
    _controllerDescripcion = new TextEditingController();
    _controllerZona = new TextEditingController();
    _controllerReciboInicial = new TextEditingController();
    _controllerReciboFinal = new TextEditingController();

    super.initState();
    _billetesController.cargando.value = false;
  }

  _init() {
    _zona = widget.billete.zona;
    _edicion = widget.billete.edicion;
    _controllerEdicion.text = _edicion.numero;
    _controllerZona.text = _zona.zona;
    _controllerReciboInicial.text = widget.billete.reciboInicial;
    _controllerReciboFinal.text = widget.billete.reciboFinal;

    setState(() {
      _cantidadVendida = widget.billete.cantidadVendida;
      _cantidadDevuelto = widget.billete.calcularCantidadDevuelto();
      _porcentajeDescuento = widget.billete.porcentajeDescuento;
      _precioBillete = widget.billete.precioBillete;
      _cantidadExtraviada = widget.billete.calcularCantidadExtraviado();
      _montoVendido = widget.billete.calcularMontoVendido();
      _montoExtraviado = widget.billete.calcularMontoExtraviado();
      _montoPagadoPorcentaje = widget.billete.calcularMontoPorcentaje();
      _montoPagado = widget.billete.calcularMontoPagado();
    });
    _calcularTotalBilletes();
  }

  @override
  void dispose() {
    _fecusFinal.dispose();
    _controllerEdicion.dispose();

    _controllerZona.dispose();
    _controllerCantidad.dispose();
    _controllerDescripcion.dispose();
    _controllerReciboFinal.dispose();
    _controllerReciboInicial.dispose();
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
    return "Zona incorrecto";
  }

  String _validarEdicion(String texto) {
    if (texto.isNotEmpty) {
      return null;
    }
    return "Edición incorrecto";
  }

  String _validarFechaInicial(String texto) {
    if (texto.isNotEmpty) {
      return null;
    }
    return "Billete Inicial incorrecto";
  }

  String _validarFechaFin(String texto) {
    if (texto.isNotEmpty) {
      return null;
    }
    return "Billete final incorrecto";
  }

  @override
  Widget build(BuildContext context) {
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
            "Billete",
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
                            label: "Zona",
                            icon: Icon(Icons.people),
                            maxLength: 20,
                            controller: _controllerZona,
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
                            enabled: false,
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
                            validator: _validarFechaFin,
                            enabled: false,
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
                          ListTile(
                            title: Text("Puntos de ventas"),
                            trailing: IconButton(
                              icon: Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.green,
                                size: 40,
                              ),
                              onPressed: () {
                                mostrarCarritoPromocion(
                                  context: context,
                                );
                              },
                            ),
                          ),
                          DetalleItem(
                            textoDerecha: "U/. $_cantidadVendida",
                            textoIzquierda: "Cantidad vendido",
                          ),
                          DetalleItem(
                            textoDerecha: "U/. $_cantidadDevuelto",
                            textoIzquierda: "Cantidad devuelto",
                          ),
                          DetalleItem(
                            textoDerecha: "%. $_porcentajeDescuento",
                            textoIzquierda: "Porcentaje descuento",
                          ),
                          DetalleItem(
                            textoDerecha: "S/. $_precioBillete",
                            textoIzquierda: "Precio por billete",
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
                          /*  Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: BotonRedondo(
                              icon: Icon(
                                Icons.save,
                                color: Colors.white,
                                size: 30,
                              ),
                              width: butonSize * 0.9,
                              btnController: _btnControllerRegistrar,
                              background: widget.billete.edicion.estado == 1
                                  ? Colores.colorButton
                                  : Colores.textosColorGris,
                              titulo: "Actualizar",
                              onPressed: () async {
                                if (widget.billete.edicion.estado == 1) {
                                  /*  Billete billete = _validarCampos();
                                  if (billete != null) {
                                    dynamic response =
                                     /*    await _billetesController.actualizar(
                                            billete: billete,
                                            btnControllerRegistrar:
                                                _btnControllerRegistrar); */

                                    /* if (response) {
                                      Get.back();
                                    } */
                                  } */
                                } else {
                                  _btnControllerRegistrar.reset();
                                }
                              },
                            ),
                          ) */
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Obx(() => _billetesController.cargando.value == true
                ? loading()
                : Container())
          ],
        ),
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    dynamic lista = await _billetesController.cargarListaBilletePuntoVentas(
        billetePuntoVenta: widget.billete);
    widget.billete.setListaBilletePuntoVenta(lista);
    _init();
  }

  Future mostrarCarritoPromocion({BuildContext context}) async {
    dynamic lista = widget.billete.listaBilletePuntoVenta;
    bool estado =
        await showModalBilletePuntoVenta(context: context, lista: lista);

    if (estado != null && estado == true) {}
  }

  Future<bool> showModalBilletePuntoVenta(
      {BuildContext context, List<BilletePuntoVenta> lista}) async {
    bool estado = false;
    bool respnse = await showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Container(
            color: Colors.white,
            child: ListView.builder(
              itemCount: lista.length,
              itemBuilder: (context, index) {
                BilletePuntoVenta billetePuntoVenta = lista[index];
                return ItemDetalleCard(billetePuntoVenta: billetePuntoVenta);
              },
            ),
          );
        });

    if (respnse != null) {
      print("hola");
    }
    return estado;
  }
}
