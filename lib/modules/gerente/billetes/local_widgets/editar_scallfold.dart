import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:proyect_nortenio_app/data/models/billete_distribuidor_.dart';
import 'package:proyect_nortenio_app/data/models/edicion.dart';
import 'package:proyect_nortenio_app/data/models/zona.dart';
import 'package:proyect_nortenio_app/global_widgets/botonRedondo.dart';
import 'package:proyect_nortenio_app/global_widgets/input_form.dart';
import 'package:proyect_nortenio_app/global_widgets/loading_widget.dart';
import 'package:proyect_nortenio_app/utils/colores.dart';
import 'package:proyect_nortenio_app/utils/responsive.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../billetes_controller.dart';

class EditarScallfold extends StatefulWidget {
  final BilleteDistribuidor billete;

  const EditarScallfold({Key key, this.billete}) : super(key: key);
  @override
  _EditarScallfoldState createState() => _EditarScallfoldState();
}

class _EditarScallfoldState extends State<EditarScallfold>
    with AfterLayoutMixin {
  RoundedLoadingButtonController _btnControllerRegistrar;
  GlobalKey<FormState> _formKey;
  BilletesControllerG _billetesController = Get.find();

  String _billetesInicial = '', _billetesFin = '';

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
    _btnControllerRegistrar = new RoundedLoadingButtonController();
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
    _init();
  }

  _init() {
    _zona = widget.billete.zona;
    _edicion = widget.billete.edicion;
    _controllerEdicion.text = _edicion.numero;
    _controllerZona.text = _zona.zona;
    _controllerReciboInicial.text = widget.billete.reciboInicial;
    _controllerReciboFinal.text = widget.billete.reciboFinal;
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

  String _validarReciboInicial(String texto) {
    if (texto.isNotEmpty) {
      _billetesInicial = texto;
      return null;
    }
    return "Billete Inicial incorrecto";
  }

  String _validarReciboFin(String texto) {
    if (texto.isNotEmpty && int.parse(texto) > int.parse(_billetesInicial)) {
      _billetesFin = texto;
      return null;
    }
    return "Billete final incorrecto";
  }

  BilleteDistribuidor _validarCampos() {
    final bool isValid = _formKey.currentState.validate();
    if (isValid) {
      BilleteDistribuidor billete = new BilleteDistribuidor(
          id: widget.billete.id,
          edicion: _edicion,
          estado: 1,
          reciboInicial: _billetesInicial,
          reciboFinal: _billetesFin,
          zona: _zona);
      return billete;
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
                            icon: Icon(FontAwesomeIcons.moneyBill),
                            maxLength: 20,
                            controller: _controllerEdicion,
                            validator: _validarEdicion,
                            enabled: false,
                          ),
                          InputForm(
                            width: double.infinity,
                            label: "Zona",
                            icon: Icon(FontAwesomeIcons.globeAmericas),
                            maxLength: 20,
                            controller: _controllerZona,
                            validator: _validarZona,
                            enabled: false,
                          ),
                          InputForm(
                            width: double.infinity,
                            label: "Recibo inicial",
                            icon: Icon(FontAwesomeIcons.moneyBillAlt),
                            maxLength: 20,
                            keyboardType: TextInputType.phone,
                            controller: _controllerReciboInicial,
                            validator: _validarReciboInicial,
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
                            icon: Icon(FontAwesomeIcons.moneyBillWave),
                            maxLength: 20,
                            keyboardType: TextInputType.phone,
                            controller: _controllerReciboFinal,
                            validator: _validarReciboFin,
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
                            icon: Icon(FontAwesomeIcons.sortNumericUp),
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
                              background: widget.billete.edicion.estado == 1
                                  ? Colores.colorButton
                                  : Colores.textosColorGris,
                              titulo: "Actualizar",
                              onPressed: () async {
                                if (widget.billete.edicion.estado == 1) {
                                  BilleteDistribuidor billete =
                                      _validarCampos();
                                  if (billete != null) {
                                    dynamic response =
                                        await _billetesController.actualizar(
                                            billete: billete,
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
            Obx(() => _billetesController.cargando.value == true
                ? loading()
                : Container())
          ],
        ),
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    /* _billetesController.getEdicionesApi(); */
  }
}
