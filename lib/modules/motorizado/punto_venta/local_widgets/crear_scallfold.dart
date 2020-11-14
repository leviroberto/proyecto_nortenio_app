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

class CrearScallfold extends StatefulWidget {
  final Zona zona;

  const CrearScallfold({Key key, @required this.zona}) : super(key: key);
  @override
  _CrearScallfoldState createState() => _CrearScallfoldState();
}

class _CrearScallfoldState extends State<CrearScallfold> with AfterLayoutMixin {
  RoundedLoadingButtonController _btnControllerRegistrar;
  GlobalKey<FormState> _formKey;
  PuntoVentaControllerM _puntoVentaController = Get.find();

  Zona _zona;

  String _provincia = '',
      _distrito = '',
      _celular = '',
      _propietario = '',
      _telefono = '',
      _razonSocial = '',
      _ruc = '',
      _departamento = '',
      _correoElectronico = '',
      _referencia = '';

  FocusNode _focusZona, _focusDescripcion, _focusDistribuidor, _focusMotorizado;
  TextEditingController _controllerRuc,
      _controllerRazonSocial,
      _controllerProvincia,
      _controllerDepartamento,
      _controllerDistrito,
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
    _controllerProvincia = new TextEditingController();
    _controllerDistrito = new TextEditingController();
    _controllerDepartamento = new TextEditingController();
    _controllerRazonSocial = new TextEditingController();
    _controllerZona = new TextEditingController();

    super.initState();
    _puntoVentaController.cargando.value = false;
    _init();
  }

  _init() {
    _zona = widget.zona;
    if (!_zona.isNull) {
      _controllerZona.text = _zona.zona;
    }
  }

  @override
  void dispose() {
    _focusZona.dispose();
    _focusDescripcion.dispose();
    _focusDistribuidor.dispose();
    _focusMotorizado.dispose();
    _controllerRuc.dispose();
    _controllerRazonSocial.dispose();
    _controllerDistrito.dispose();
    _controllerDistrito.dispose();
    _controllerDepartamento.dispose();
    _controllerZona.dispose();
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

  String _validarZona(String texto) {
    if (texto.isNotEmpty) {
      return null;
    }
    return "Zona incorrecto";
  }

  PuntoVenta _validarCampos() {
    final bool isValid = _formKey.currentState.validate();
    if (isValid) {
      PuntoVenta puntoVenta = new PuntoVenta(
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
            "Registrar Punto Venta",
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
                              width: double.infinity,
                              label: "Zona",
                              controller: _controllerZona,
                              icon: Icon(Icons.person),
                              maxLength: 100,
                              enabled: false,
                              validator: _validarZona,
                            ),
                            Stack(
                              children: [
                                InputForm(
                                  width: 168,
                                  label: "RUC",
                                  keyboardType: TextInputType.phone,
                                  icon: Icon(Icons.view_carousel),
                                  onFieldSubmitted: (String text) {
                                    buscarRuc(context: context);
                                  },
                                  maxLength: 11,
                                  controller: _controllerRuc,
                                  validator: _validarRuc,
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
                                          buscarRuc(context: context);
                                        }),
                                  ),
                                )
                              ],
                            ),
                            InputForm(
                              width: double.infinity,
                              label: "Razon social",
                              controller: _controllerRazonSocial,
                              icon: Icon(Icons.person),
                              maxLength: 100,
                              enabled: false,
                              validator: _validarRazonSocial,
                            ),
                            Stack(
                              children: [
                                InputForm(
                                  keyboardType: TextInputType.phone,
                                  width: 168,
                                  enabled: false,
                                  label: "Departamento",
                                  icon: Icon(Icons.view_carousel),
                                  onFieldSubmitted: (String text) {
                                    _formKey.currentState.reset();
                                  },
                                  maxLength: 150,
                                  controller: _controllerDepartamento,
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
                                          mostrarBuscadorDepartamento(
                                              context: context,
                                              departamento: _departamento);
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
                                  enabled: false,
                                  label: "Provincia",
                                  icon: Icon(Icons.view_carousel),
                                  onFieldSubmitted: (String text) {
                                    _formKey.currentState.reset();
                                  },
                                  maxLength: 150,
                                  controller: _controllerProvincia,
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
                                          mostrarBuscadorProvincia(
                                              context: context,
                                              provincia: _provincia);
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
                                  enabled: false,
                                  label: "Distrito",
                                  icon: Icon(Icons.view_carousel),
                                  onFieldSubmitted: (String text) {
                                    _formKey.currentState.reset();
                                  },
                                  maxLength: 150,
                                  controller: _controllerDistrito,
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
                                          mostrarBuscadorDistritos(
                                              context: context,
                                              provincia: _provincia,
                                              distrito: _distrito);
                                        }),
                                  ),
                                )
                              ],
                            ),
                            InputForm(
                              width: double.infinity,
                              label: "Referencia",
                              icon: Icon(Icons.person),
                              maxLength: 100,
                              validator: _validarReferencia,
                            ),
                            InputForm(
                              width: double.infinity,
                              label: "Correo electronico",
                              icon: Icon(Icons.person),
                              maxLength: 100,
                              validator: _validarCorreoElectronico,
                            ),
                            InputForm(
                              width: double.infinity,
                              label: "Teléfono",
                              icon: Icon(Icons.person),
                              maxLength: 12,
                              keyboardType: TextInputType.phone,
                              validator: _validarTelefono,
                            ),
                            InputForm(
                              width: double.infinity,
                              label: "Celular",
                              icon: Icon(Icons.person),
                              maxLength: 9,
                              keyboardType: TextInputType.phone,
                              validator: _validarCelular,
                            ),
                            InputForm(
                              width: double.infinity,
                              label: "Propiertario",
                              icon: Icon(Icons.people),
                              maxLength: 150,
                              validator: _validarPropietario,
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
                                  final puntoVenta = _validarCampos();
                                  if (puntoVenta != null) {
                                    dynamic response =
                                        await _puntoVentaController.registrar(
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

  Future mostrarBuscadorDepartamento(
      {BuildContext context, String departamento}) async {
    String pais = "Peù";
    final lista = List<String>();
    lista.add("La Libertad");
    _departamento = await showSearch(
        context: context,
        delegate: BuscarDepartamentos(
            lista: lista, title: departamento, subTile: pais));
    if (_departamento != "" && _departamento != null) {
      _controllerDepartamento.text = _departamento;
      _distrito = "";
      _provincia = "";
      _controllerDistrito.text = "";
      _controllerProvincia.text = "";
      _puntoVentaController.cargarProvincias(departamento: _departamento);
    } else {
      _provincia = "";
    }
  }

  Future mostrarBuscadorProvincia(
      {BuildContext context, String provincia}) async {
    String departamento = "La Libertad";
    final lista = _puntoVentaController.listaProvincias.toList();
    _provincia = await showSearch(
        context: context,
        delegate: BuscarDepartamentos(
            lista: lista, title: provincia, subTile: departamento));
    if (_provincia != "" && _provincia != null) {
      _controllerProvincia.text = _provincia;
      _distrito = "";
      _controllerDistrito.text = "";
      int posicion = _puntoVentaController.buscarPosicionProvincia(_provincia);
      _puntoVentaController.cargarDistritos(provincia: posicion);
    } else {
      _provincia = "";
    }
  }

  Future mostrarBuscadorDistritos(
      {BuildContext context, String distrito, String provincia}) async {
    final lista = _puntoVentaController.listaDistritos.toList();
    _distrito = await showSearch(
        context: context,
        delegate: BuscarDepartamentos(
            lista: lista, title: distrito, subTile: provincia));
    if (_distrito != "" && _distrito != null) {
      _controllerDistrito.text = _distrito;
    } else {
      _distrito = "";
    }
  }

  Future mostrarBuscadorZona({BuildContext context, Zona zona}) async {
    final lista = _puntoVentaController.listaZonas.toList();
    _zona = await showSearch(
        context: context,
        delegate: BuscarZona(lista: lista, zonaSeleccionada: zona));
    if (_zona != null) {
      _controllerZona.text = _zona.zona;
    }
  }
}

class BuscarDepartamentos extends SearchDelegate<String> {
  final List<String> lista;
  String title;
  String subTile;

  BuscarDepartamentos({this.lista, this.title, this.subTile});

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
          close(context, title);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final myList = query.isEmpty
        ? lista
        : lista.where((p) {
            String uno = p.toLowerCase().toString();
            String dos = query.toLowerCase().toString();
            return uno.startsWith(dos);
          }).toList();

    return myList.isEmpty
        ? Text("No encontrado")
        : ListView.builder(
            itemCount: myList.length,
            itemBuilder: (context, index) {
              final String cadena = myList[index];
              bool estado = title != ""
                  ? cadena.toLowerCase().toLowerCase() ==
                          title.toLowerCase().toString()
                      ? true
                      : false
                  : false;
              return ListTile(
                onTap: () {
                  close(context, cadena);
                },
                title: Text(
                  cadena,
                  style:
                      TextStyle(color: estado ? Colors.black38 : Colors.black),
                ),
                subtitle: Text(subTile,
                    style: TextStyle(
                        color: estado ? Colors.black38 : Colors.black)),
              );
            },
          );
  }
}

class BuscarZona extends SearchDelegate<Zona> {
  final List<Zona> lista;
  Zona zonaSeleccionada;

  BuscarZona({this.lista, this.zonaSeleccionada});

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
          close(context, zonaSeleccionada);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final myList = query.isEmpty
        ? lista
        : lista.where((p) {
            String uno = p.zona.toLowerCase().toString();
            String dos = query.toLowerCase().toString();
            return uno.startsWith(dos);
          }).toList();

    return myList.isEmpty
        ? Text("No encontrado")
        : ListView.builder(
            itemCount: myList.length,
            itemBuilder: (context, index) {
              final Zona cadena = myList[index];
              bool estado = zonaSeleccionada != null
                  ? cadena.zona.toLowerCase().toLowerCase() ==
                          zonaSeleccionada.zona.toLowerCase().toString()
                      ? true
                      : false
                  : false;
              return ListTile(
                onTap: () {
                  close(context, cadena);
                },
                title: Text(
                  cadena.zona,
                  style:
                      TextStyle(color: estado ? Colors.black38 : Colors.black),
                ),
                subtitle: Text(cadena.descripcion,
                    style: TextStyle(
                        color: estado ? Colors.black38 : Colors.black)),
              );
            },
          );
  }
}
