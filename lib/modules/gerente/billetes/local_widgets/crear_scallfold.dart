import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:proyect_nortenio_app/data/models/billete_distribuidor_.dart';
import 'package:proyect_nortenio_app/data/models/edicion.dart';
import 'package:proyect_nortenio_app/data/models/zona.dart';
import 'package:proyect_nortenio_app/global_widgets/botonRedondo.dart';
import 'package:proyect_nortenio_app/global_widgets/empty_state.dart';
import 'package:proyect_nortenio_app/global_widgets/input_form.dart';
import 'package:proyect_nortenio_app/global_widgets/loading_widget.dart';
import 'package:proyect_nortenio_app/utils/colores.dart';
import 'package:proyect_nortenio_app/utils/responsive.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../billetes_controller.dart';
import 'item_zona_card.dart';

class CrearScallfold extends StatefulWidget {
  final Edicion edicion;

  const CrearScallfold({Key key, @required this.edicion}) : super(key: key);
  @override
  _CrearScallfoldState createState() => _CrearScallfoldState();
}

class _CrearScallfoldState extends State<CrearScallfold> with AfterLayoutMixin {
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
    _edicion = widget.edicion;
    _controllerEdicion.text = _edicion.numero;
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
    return "Edición incorrecto";
  }

  String _validarEdicion(String texto) {
    if (texto.isNotEmpty) {
      return null;
    }
    return "Zona incorrecto";
  }

  String _validarReciboInicial(String texto) {
    if (texto.isNotEmpty) {
      _billetesInicial = texto;
      return null;
    }
    return "Billete Inicial incorrecto";
  }

  String _validarReciboFinal(String texto) {
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
            "Registrar billete",
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
                            icon: Icon(FontAwesomeIcons.moneyBillWave),
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
                                label: "Zona",
                                enabled: false,
                                icon: Icon(FontAwesomeIcons.globeAmericas),
                                onFieldSubmitted: (String text) {
                                  _formKey.currentState.reset();
                                },
                                maxLength: 150,
                                controller: _controllerZona,
                                validator: _validarZona,
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
                                        mostrarBuscadorZona(
                                            context: context, zona: _zona);
                                      }),
                                ),
                              )
                            ],
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
                            validator: _validarReciboFinal,
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
                              titulo: "Registrar",
                              onPressed: () async {
                                BilleteDistribuidor billete = _validarCampos();
                                if (billete != null) {
                                  dynamic response =
                                      await _billetesController.registrar(
                                          billete: billete,
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
    _billetesController.cargarListaZonas();
  }

  Future mostrarBuscadorZona({BuildContext context, Zona zona}) async {
    final lista = _billetesController.listaZona.toList();
    Zona _auxiliar = await showSearch(
        context: context,
        delegate: BuscarZonas(listsZona: lista, zonaSeleccionado: zona));
    if (_auxiliar != null) {
      _zona = _auxiliar;
      _controllerZona.text = _zona.zona;
    } else if (_zona != null) {
      _controllerZona.text = _zona.zona;
    } else {
      _controllerZona.text = "";
    }
  }
}

class BuscarZonas extends SearchDelegate<Zona> {
  final List<Zona> listsZona;
  Zona zonaSeleccionado;

  BuscarZonas({this.listsZona, this.zonaSeleccionado});

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
          close(context, zonaSeleccionado);
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
                p.descripcion.toLowerCase().contains(query.toLowerCase()))
            .toList();

    return myList.isEmpty
        ? EmptyState()
        : ListView.builder(
            itemCount: myList.length,
            itemBuilder: (context, index) {
              final Zona zona = myList[index];
              bool estado = zonaSeleccionado != null
                  ? zona.id == zonaSeleccionado.id
                      ? true
                      : false
                  : false;
              return ItemZonaCard(
                  isSelected: estado,
                  zona: zona,
                  onTapActualizar: () {
                    close(context, zona);
                  });
            },
          );
  }
}
