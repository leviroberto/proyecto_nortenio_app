import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:proyect_nortenio_app/data/models/usuario.dart';
import 'package:proyect_nortenio_app/data/models/zona.dart';
import 'package:proyect_nortenio_app/global_widgets/custom_app_bar.dart';
import 'package:proyect_nortenio_app/global_widgets/empty_state.dart';
import 'package:proyect_nortenio_app/global_widgets/loading_widget.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../../../global_widgets/botonRedondo.dart';
import '../../../../global_widgets/input_form.dart';
import '../../../../utils/colores.dart';
import '../../../../utils/responsive.dart';
import '../zona_controller.dart';
import 'item_distribuidor_card.dart';

class CrearScallfold extends StatefulWidget {
  @override
  _CrearScallfoldState createState() => _CrearScallfoldState();
}

class _CrearScallfoldState extends State<CrearScallfold> with AfterLayoutMixin {
  RoundedLoadingButtonController _btnControllerRegistrar;
  GlobalKey<FormState> _formKey;
  ZonaControllerG _zonaController = Get.find();

  String _zona = '', _descripcion = '';
  Usuario _distribuidor;

  FocusNode _focusZona, _focusDescripcion, _focusDistribuidor, _focusMotorizado;
  TextEditingController _controllerZona,
      _controllerDescripcion,
      _controllerDistribuidor;

  @override
  void initState() {
    _formKey = GlobalKey();
    _btnControllerRegistrar = new RoundedLoadingButtonController();
    _focusZona = FocusNode();
    _focusDescripcion = FocusNode();
    _focusDistribuidor = FocusNode();
    _focusMotorizado = FocusNode();

    _controllerZona = new TextEditingController();
    _controllerDescripcion = new TextEditingController();
    _controllerDistribuidor = new TextEditingController();

    super.initState();
    _zonaController.cargando.value = false;
  }

  @override
  void dispose() {
    _focusZona.dispose();
    _focusDescripcion.dispose();
    _focusDistribuidor.dispose();
    _focusMotorizado.dispose();
    _controllerZona.dispose();
    _controllerDescripcion.dispose();
    _controllerDistribuidor.dispose();
    super.dispose();
  }

  String _validarZona(String texto) {
    if (texto.isNotEmpty) {
      _zona = texto;
      return null;
    }
    return "Nombre incorrecto";
  }

  String _validarDescripcion(String texto) {
    if (texto.isNotEmpty) {
      _descripcion = texto;
      return null;
    }
    return "Descripción incorrecto";
  }

  String _validarDistribuidor(String texto) {
    if (texto.isNotEmpty) {
      return null;
    }
    return "Distrito incorrecto";
  }

  Zona _validarCampos() {
    final bool isValid = _formKey.currentState.validate();
    if (isValid) {
      Zona zona = new Zona(
          descripcion: _descripcion,
          distribuidor: _distribuidor,
          estado: 1,
          zona: _zona);
      return zona;
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
      appBar: CustomAppBar(
        title: "Registrar zona",
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
                            label: "Zona",
                            controller: _controllerZona,
                            icon: Icon(Icons.public),
                            maxLength: 60,
                            validator: _validarZona,
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
                                keyboardType: TextInputType.phone,
                                width: 168,
                                enabled: false,
                                label: "Distribuidor",
                                icon: Icon(Icons.view_carousel),
                                onFieldSubmitted: (String text) {
                                  _formKey.currentState.reset();
                                },
                                maxLength: 150,
                                validator: _validarDistribuidor,
                                controller: _controllerDistribuidor,
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
                                        mostrarBuscadorDistribuidor(
                                            context: context,
                                            usuario: _distribuidor);
                                      }),
                                ),
                              )
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: BotonRedondo(
                              width: butonSize * 0.9,
                              btnController: _btnControllerRegistrar,
                              titulo: "Registrar",
                              onPressed: () async {
                                Zona zona = _validarCampos();
                                if (zona != null) {
                                  dynamic response =
                                      await _zonaController.registrar(
                                          zona: zona,
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
            Obx(() => _zonaController.cargando.value == true
                ? loading()
                : Container())
          ],
        ),
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    _zonaController.distribuidores();
  }

  Future mostrarBuscadorDistribuidor(
      {BuildContext context, Usuario usuario}) async {
    final lista = _zonaController.listaDistribuidores.toList();
    Usuario _auxiliar = await showSearch(
        context: context,
        delegate:
            BuscarUsuario(listaUsuario: lista, usuarioSeleccionado: usuario));
    if (_auxiliar != null) {
      _distribuidor = _auxiliar;
      _controllerDistribuidor.text = _distribuidor.nombreCompleto;
    } else if (_distribuidor != null) {
      _controllerDistribuidor.text = _distribuidor.nombreCompleto;
    } else {
      _controllerDistribuidor.text = "";
    }
  }
}

class BuscarUsuario extends SearchDelegate<Usuario> {
  final List<Usuario> listaUsuario;
  Usuario usuarioSeleccionado;

  BuscarUsuario({this.listaUsuario, this.usuarioSeleccionado});

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
          close(context, usuarioSeleccionado);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final myList = query.isEmpty
        ? listaUsuario
        : listaUsuario
            .where((p) =>
                p.nombreCompleto.toLowerCase().contains(query.toLowerCase()))
            .toList();

    return myList.isEmpty
        ? EmptyState()
        : ListView.builder(
            itemCount: myList.length,
            itemBuilder: (context, index) {
              final Usuario distribuidor = myList[index];
              bool estado = usuarioSeleccionado != null
                  ? distribuidor.id == usuarioSeleccionado.id
                      ? true
                      : false
                  : false;
              return ItemDistribuidorCard(
                isSelected: estado,
                distribuidor: distribuidor,
                onTapActualizar: () {
                  close(context, distribuidor);
                },
              );
            },
          );
  }
}
