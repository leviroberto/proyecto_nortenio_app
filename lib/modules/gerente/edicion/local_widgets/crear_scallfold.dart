import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:proyect_nortenio_app/data/models/edicion.dart';
import 'package:proyect_nortenio_app/global_widgets/custom_app_bar.dart';
import 'package:proyect_nortenio_app/global_widgets/loading_widget.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../../../global_widgets/botonRedondo.dart';
import '../../../../global_widgets/input_form.dart';
import '../../../../utils/colores.dart';
import '../../../../utils/responsive.dart';
import '../edicion_controller.dart';

class CrearScallfold extends StatefulWidget {
  @override
  _CrearScallfoldState createState() => _CrearScallfoldState();
}

class _CrearScallfoldState extends State<CrearScallfold> with AfterLayoutMixin {
  RoundedLoadingButtonController _btnControllerRegistrar;
  GlobalKey<FormState> _formKey;
  EdicionControllerG _edicionController = Get.find();
  DateTime selectedDateFechaInicio;
  DateTime selectedDateFechaFin;
  String _numero = '', _descripcion = '', _fechaInicio = '', _fechaFin = '';

  FocusNode _focusNumero, _focusDescripcion, _focusFechaInicio, _focusFechaFin;
  TextEditingController _controllerNumeroEdicion,
      _controllerDescripcion,
      _controllerFechaInicio,
      _controllerFechaFin;

  @override
  void initState() {
    _formKey = GlobalKey();
    _btnControllerRegistrar = new RoundedLoadingButtonController();
    _focusNumero = FocusNode();
    _focusDescripcion = FocusNode();
    _focusFechaInicio = FocusNode();
    _focusFechaFin = FocusNode();

    _controllerNumeroEdicion = new TextEditingController();
    _controllerDescripcion = new TextEditingController();
    _controllerFechaInicio = new TextEditingController();
    _controllerFechaFin = new TextEditingController();

    super.initState();
    _edicionController.cargando.value = false;
    _init();
  }

  _init() {
    selectedDateFechaInicio = _edicionController.obtenerUltimaFechaEdicion();
    selectedDateFechaFin = selectedDateFechaInicio.add(Duration(days: 7));

    _controllerFechaInicio.text =
        "${selectedDateFechaInicio.toLocal()}".split(' ')[0];
    _controllerFechaFin.text =
        "${selectedDateFechaFin.toLocal()}".split(' ')[0];
  }

  @override
  void dispose() {
    _focusNumero.dispose();
    _focusDescripcion.dispose();
    _focusFechaInicio.dispose();
    _focusFechaFin.dispose();
    _controllerNumeroEdicion.dispose();
    _controllerDescripcion.dispose();
    _controllerFechaInicio.dispose();
    _controllerFechaFin.dispose();
    super.dispose();
  }

  String _validarNumeroEdicion(String texto) {
    if (texto.isNotEmpty) {
      _numero = texto;
      return null;
    }
    return "Nombre edición incorrecto";
  }

  String _validarDescripcion(String texto) {
    if (texto.isNotEmpty) {
      _descripcion = texto;
      return null;
    }
    return "Descripción incorrecta";
  }

  String _validarFechaIncio(String texto) {
    if (texto.isNotEmpty) {
      _fechaInicio = texto;
      return null;
    }
    return "Fecha Inicio incorrecto";
  }

  String _validarFechaFin(String texto) {
    if (texto.isNotEmpty) {
      _fechaFin = texto;
      return null;
    }
    return "Fecha Fin incorrecto";
  }

  Edicion _validarCampos() {
    final bool isValid = _formKey.currentState.validate();
    if (isValid) {
      Edicion edicion = new Edicion(
        numero: _numero,
        descripcion: _descripcion,
        fechaFin: _fechaFin,
        fechaInicio: _fechaInicio,
        estado: 1,
      );
      return edicion;
    } else {
      _btnControllerRegistrar.reset();
      return null;
    }
  }

  _selectDateFechaInicio(BuildContext context) async {
    DateTime ultimaFecha = _edicionController.obtenerUltimaFechaEdicion();
    final DateTime picked = await showDatePicker(
      selectableDayPredicate: (DateTime val) =>
          val.day < ultimaFecha.day ? false : true,
      context: context,
      initialDate: selectedDateFechaInicio, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDateFechaInicio)
      selectedDateFechaInicio = picked;
    selectedDateFechaFin = selectedDateFechaInicio.add(Duration(days: 7));

    _controllerFechaInicio.text =
        "${selectedDateFechaInicio.toLocal()}".split(' ')[0];
    _controllerFechaFin.text =
        "${selectedDateFechaFin.toLocal()}".split(' ')[0];
  }

  _selectDateFechaFin(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDateFechaFin, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDateFechaFin)
      selectedDateFechaFin = picked;

    _controllerFechaFin.text =
        "${selectedDateFechaFin.toLocal()}".split(' ')[0];
  }

  @override
  Widget build(BuildContext context) {
    final Responsive rosponsive = Responsive.of(context);
    final double butonSize = rosponsive.widthPercent(80);
    return Scaffold(
      backgroundColor: Colores.bodyColor,
      appBar: CustomAppBar(
        title: "Registrar Distribuidor",
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
                          InputForm(
                            width: double.infinity,
                            label: "Número edición",
                            controller: _controllerNumeroEdicion,
                            icon: Icon(Icons.inbox),
                            keyboardType: TextInputType.phone,
                            maxLength: 5,
                            validator: _validarNumeroEdicion,
                          ),
                          InputForm(
                            width: double.infinity,
                            label: "Descripción",
                            icon: Icon(Icons.text_fields),
                            maxLength: 150,
                            controller: _controllerDescripcion,
                            validator: _validarDescripcion,
                          ),
                          Stack(
                            children: [
                              InputForm(
                                controller: _controllerFechaInicio,
                                validator: _validarFechaIncio,
                                keyboardType: TextInputType.phone,
                                width: 168,
                                label: "Fecha Inicio",
                                icon: Icon(Icons.calendar_today),
                                maxLength: 10,
                              ),
                              Positioned(
                                right: 3,
                                top: 4,
                                child: Transform.scale(
                                  scale: 1.54,
                                  child: IconButton(
                                      icon: Icon(
                                        Icons.date_range,
                                        color: Colores.textosColorGris,
                                      ),
                                      onPressed: () {
                                        _selectDateFechaInicio(context);
                                      }),
                                ),
                              )
                            ],
                          ),
                          Stack(
                            children: [
                              InputForm(
                                controller: _controllerFechaFin,
                                validator: _validarFechaFin,
                                keyboardType: TextInputType.phone,
                                width: 168,
                                label: "Fecha Fin",
                                icon: Icon(Icons.calendar_today),
                                maxLength: 10,
                              ),
                              Positioned(
                                right: 3,
                                top: 4,
                                child: Transform.scale(
                                  scale: 1.54,
                                  child: IconButton(
                                      icon: Icon(
                                        Icons.date_range,
                                        color: Colores.textosColorGris,
                                      ),
                                      onPressed: () {
                                        _selectDateFechaFin(context);
                                      }),
                                ),
                              )
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: BotonRedondo(
                              width: butonSize * 0.9,
                              btnController: _btnControllerRegistrar,
                              titulo: "Registrar",
                              onPressed: () async {
                                Edicion edicion = _validarCampos();
                                if (edicion != null) {
                                  dynamic response =
                                      await _edicionController.registrar(
                                    edicion: edicion,
                                    btnControllerRegistrar:
                                        _btnControllerRegistrar,
                                  );

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
            Obx(() => _edicionController.cargando.value == true
                ? loading()
                : Container())
          ],
        ),
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    int ultimaEdicion = await _edicionController.ultimaEdicion();
    int numero = ultimaEdicion + 1;
    _controllerNumeroEdicion.text = numero.toString();
  }
}
