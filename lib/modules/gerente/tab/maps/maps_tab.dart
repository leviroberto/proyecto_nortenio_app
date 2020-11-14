import 'dart:async';
import 'dart:ui';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:proyect_nortenio_app/data/models/billete_punto_venta.dart';
import 'package:proyect_nortenio_app/data/models/conifiguracion_maps.dart';
import 'package:proyect_nortenio_app/data/models/edicion.dart';
import 'package:proyect_nortenio_app/global_widgets/loading_widget.dart';
import 'package:proyect_nortenio_app/modules/gerente/tab/maps/maps_controller.dart';
import 'package:proyect_nortenio_app/modules/gerente/tab/maps/widgets/item_detalle_card.dart';
import 'package:proyect_nortenio_app/modules/gerente/tab/widgets/ListDropdown.dart';
import 'package:proyect_nortenio_app/utils/colores.dart';
import 'package:proyect_nortenio_app/utils/lista.dart';
import 'package:proyect_nortenio_app/utils/util.dart';
import 'package:proyect_nortenio_app/utils/utilidades.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MapsTabG extends StatefulWidget {
  @override
  _MapsTabGState createState() => _MapsTabGState();
}

class _MapsTabGState extends State<MapsTabG>
    with AfterLayoutMixin, SingleTickerProviderStateMixin {
  RefreshController _refreshController;
  Circle circle;

  AnimationController _animationController;

  Animation<Color> _buttonColor;
  Animation<double> _animationIcon;
  Animation<double> _translateButton;
  Curve _curve = Curves.easeOut;
  double _fabHeight = 56.0;
  List<Marker> listaMarkers = [];
  Widget widgetYear = Container();
  Widget widgetEdicion = Container();
  Widget widgetMes = Container();
  String estado = "Todos";
  dynamic iconoActivo, iconoEntregado, iconoRecogido;

  ConfiguracionMap configuracionMap;

  List<String> listaAnio = new List<String>();

  bool isSelectedEdicion = false;

  bool isFilter = false;

  MapsControllerG _mapsController = Get.find();

  BuildContext buildContext;

  @override
  void initState() {
    _refreshController = RefreshController(initialRefresh: false);

    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500))
          ..addListener(() {
            setState(() {});
          });

    _animationIcon =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);

    _buttonColor = ColorTween(begin: Colors.blue, end: Colors.red).animate(
        CurvedAnimation(
            parent: _animationController,
            curve: Interval(0.00, 1.00, curve: Curves.linear)));
    _translateButton = Tween<double>(begin: _fabHeight, end: -14.0).animate(
        CurvedAnimation(
            parent: _animationController,
            curve: Interval(0.0, 0.75, curve: _curve)));
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  _seleccionarBilletesPorEstado({int estado}) {
    _mapsController.listaBilletePuntoVentaFilter.clear();
    _mapsController.listaBilletePuntoVenta.forEach((billete) {
      if (billete.estado == estado) {
        _mapsController.listaBilletePuntoVentaFilter.add(billete);
      }
    });
    cargarMarkerMaps();
  }

  Widget buttonFaltaEntregar() {
    return Container(
      child: FloatingActionButton(
        heroTag: null,
        tooltip: "falta entregar",
        backgroundColor: Colores.colorRojo,
        child: Icon(Icons.place),
        onPressed: () {
          setState(() {
            estado = "Falta entregar";
          });
          isFilter = true;
          _seleccionarBilletesPorEstado(estado: 1);
        },
      ),
    );
  }

  Widget buttonEntregado() {
    return Container(
      child: FloatingActionButton(
        heroTag: null,
        tooltip: "Entregado",
        child: Icon(Icons.place),
        backgroundColor: Colores.textosColorMorado,
        onPressed: () {
          setState(() {
            estado = "Entregados";
          });
          isFilter = true;

          _seleccionarBilletesPorEstado(estado: 2);
        },
      ),
    );
  }

  Widget buttonRecogido() {
    return Container(
      child: FloatingActionButton(
        heroTag: null,
        tooltip: "Recogido",
        child: Icon(Icons.place),
        backgroundColor: Colores.colorBody,
        onPressed: () {
          setState(() {
            estado = "Recogidos";
          });
          isFilter = true;

          _seleccionarBilletesPorEstado(estado: 3);
        },
      ),
    );
  }

  Widget buttonTodos() {
    return Container(
      child: FloatingActionButton(
        heroTag: null,
        tooltip: "Todos",
        child: Icon(Icons.list_alt),
        backgroundColor: Colores.colorBody,
        onPressed: () {
          setState(() {
            estado = "Todos";
          });
          isFilter = false;
          cargarMarkerMaps();
        },
      ),
    );
  }

  Widget buttonTogle() {
    return Container(
      child: FloatingActionButton(
        heroTag: null,
        backgroundColor: _buttonColor.value,
        tooltip: "Toogle",
        child: AnimatedIcon(
          icon: AnimatedIcons.menu_close,
          progress: _animationIcon,
        ),
        onPressed: animate,
      ),
    );
  }

  void _onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));
    setState(() {
      estado = "Todos";
      isFilter = false;
    });
    dynamic response1 = await _mapsController.cargarEdiciones();
    if (response1) {
      dynamic response = await _mapsController.cargarListaZonas();
      if (response) {
        _mapsController.generarListaZonas();
        _init();
        _refreshController.refreshCompleted();
      } else {
        _refreshController.refreshCompleted();
      }
    } else {
      _refreshController.refreshCompleted();
    }
  }

  _init() {
    isSelectedEdicion = false;
    _mapsController.setAnio(null);
    _mapsController.setMes(null);
    _mapsController.setEdicion(null);
    _mapsController.setZona(null);
    setState(() {
      listaMarkers.clear();
    });
    _mapsController.generarListaAnios();
    _mapsController.setListaMes([]);
    _mapsController.setListaEdiciones([]);
    _mapsController.listaBilletePuntoVenta.clear();
  }

  _selectAnio({String val}) {
    if (_mapsController.anioSeleccionado.value == null) {
      setState(() {
        isSelectedEdicion = false;
        _mapsController.setAnio(val);
        _mapsController.setMes(null);
        _mapsController.setEdicion(null);

        _mapsController.setListaEdiciones([]);
        _mapsController.setListaMes([]);
        _mapsController.setListaMes(Lista.listaMeses);
      });
    } else if (val != _mapsController.anioSeleccionado.value) {
      setState(() {
        isSelectedEdicion = false;
        _mapsController.setAnio(val);

        _mapsController.setMes(null);
        _mapsController.setEdicion(null);

        _mapsController.setListaEdiciones([]);
        _mapsController.setListaMes([]);
        _mapsController.setListaMes(Lista.listaMeses);
      });
    }
  }

  _buscarPuntosVentas() async {
    String edicion = "-1";
    if (_mapsController.edicionSeleccionado.value != null) {
      List<String> valor = _mapsController.edicionSeleccionado.value.split("E");
      edicion = valor[1];
    }

    isSelectedEdicion = true;
    dynamic estado = await _mapsController.billetePuntoVentaPorEdicion(
        edicion: edicion, zona: _mapsController.zonaSeleccionado.value);

    if (estado) {
      cargarMarkerMaps();
      if (configuracionMap == null) {
        configuracionMap = new ConfiguracionMap();
      }
      configuracionMap.edicion = _mapsController.edicionSeleccionado.value;
      configuracionMap.mes = _mapsController.mesSeleccionado.value;
      configuracionMap.anio = _mapsController.anioSeleccionado.value;
      configuracionMap.zona = _mapsController.zonaSeleccionado.value;
      _mapsController.guardarConfiguracionMaps(
          configuracionMap: configuracionMap);
    }
  }

  _selectEdicion({String val}) async {
    if (_mapsController.edicionSeleccionado.value == null) {
      setState(() {
        _mapsController.setEdicion(val);
      });
    } else if (_mapsController.edicionSeleccionado.value != val) {
      setState(() {
        _mapsController.setEdicion(val);
      });
    }
  }

  _selectZona({String val}) async {
    if (_mapsController.zonaSeleccionado.value == null) {
      setState(() {
        _mapsController.setZona(val);
      });
    } else if (_mapsController.zonaSeleccionado.value != val) {
      setState(() {
        _mapsController.setZona(val);
      });
    }
  }

  List<String> obtenerEdicion({String anio, String mes}) {
    List<String> listaEdicionAux = new List<String>();
    for (int i = 0; i < _mapsController.ediciones.length; i++) {
      Edicion edicion = _mapsController.ediciones[i] ?? null;
      if (edicion != null) {
        String anioAux = Utilidades.getAnio(edicion.fechaFin);
        String mesAux =
            Utilidades.getMesPalabra(Utilidades.getMes(edicion.fechaFin));
        if (Util.checkInteger(anio) == Util.checkInteger(anioAux) &&
            Util.checkString(mes) == Util.checkString(mesAux)) {
          listaEdicionAux.add("E" + edicion.numero);
        }
      }
    }

    return listaEdicionAux;
  }

  void cargarMarkerMaps() {
    this._mapsController.cargando.value = true;
    setState(() {
      listaMarkers.clear();
    });
    List<BilletePuntoVenta> lista = [];
    if (isFilter) {
      lista = _mapsController.listaBilletePuntoVentaFilter.value;
    } else {
      lista = _mapsController.listaBilletePuntoVenta.value;
    }

    lista.forEach((billetePuntoVenta) async {
      if (billetePuntoVenta != null) {
        if (billetePuntoVenta.puntoVenta.geolocalizacion.latitud != null &&
            billetePuntoVenta.puntoVenta.geolocalizacion.longitud != null) {
          dynamic icono;
          if (billetePuntoVenta.estado == 1) {
            icono = iconoActivo;
          } else if (billetePuntoVenta.estado == 2) {
            icono = iconoEntregado;
          } else if (billetePuntoVenta.estado == 3) {
            icono = iconoRecogido;
          }
          listaMarkers.add(Marker(
              infoWindow: InfoWindow(
                  title:
                      Util.checkString(_mapsController.zonaSeleccionado.value),
                  snippet: Util.checkString(
                      billetePuntoVenta.puntoVenta.razonSocial),
                  onTap: () {
                    showModalDetalleBilletePuntoVenta(
                        context: buildContext,
                        billetePuntoVenta: billetePuntoVenta);
                  }),
              icon: icono,
              position: LatLng(
                  billetePuntoVenta.puntoVenta.geolocalizacion.latitud,
                  billetePuntoVenta.puntoVenta.geolocalizacion.longitud),
              markerId: MarkerId(billetePuntoVenta.id.toString()),
              draggable: false,
              onTap: () {}));
        }
      }
    });
    this._mapsController.cargando.value = false;
  }

  bool isOpened = false;

  @override
  Widget build(BuildContext context) {
    buildContext = context;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height - 60,
              width: MediaQuery.of(context).size.width,
              child: GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(
                    zoom: 12.0,
                    target: LatLng(-8.1248577205195, -79.038926884532)),
                markers: Set.from(listaMarkers),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: () {},
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.all(5),
                      height: 40.0,
                      width: 40.0,
                      child: IconButton(
                        color: Colors.green,
                        icon: Icon(
                          Icons.settings,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          mostrarFiltroBusqueda(context);
                        },
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Colors.green),
                    ),
                    Container(
                      margin: EdgeInsets.all(5),
                      height: 40.0,
                      width: 40.0,
                      child: IconButton(
                        color: Colors.green,
                        icon: Icon(
                          Icons.refresh,
                          color: Colors.white,
                        ),
                        onPressed: _onRefresh,
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Colors.green),
                    ),
                    Text(
                      estado,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
            Obx(() => _mapsController.cargando.value == true
                ? loading()
                : Container())
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Transform(
              transform: Matrix4.translationValues(
                  0.0, _translateButton.value * 4.0, 0.0),
              child: buttonTodos()),
          Transform(
              transform: Matrix4.translationValues(
                  0.0, _translateButton.value * 3.0, 0.0),
              child: buttonFaltaEntregar()),
          Transform(
              transform: Matrix4.translationValues(
                  0.0, _translateButton.value * 2.0, 0.0),
              child: buttonEntregado()),
          Transform(
              transform: Matrix4.translationValues(
                  0.0, _translateButton.value * 1, 0.0),
              child: buttonRecogido()),
          buttonTogle()
        ],
      ),
    );
  }

  _selectMes({String val}) {
    if (_mapsController.mesSeleccionado.value == null) {
      setState(() {
        isSelectedEdicion = false;

        _mapsController.setMes(val);
        _mapsController.setEdicion(null);

        _mapsController.listaBilletePuntoVenta.clear();

        _mapsController.setListaEdiciones(obtenerEdicion(
            anio: _mapsController.anioSeleccionado.value,
            mes: _mapsController.mesSeleccionado.value));
        listaMarkers.clear();
      });
    } else if (_mapsController.mesSeleccionado.value != val) {
      setState(() {
        isSelectedEdicion = false;
        _mapsController.setMes(val);
        _mapsController.setEdicion(null);
        _mapsController.listaBilletePuntoVenta.clear();
        _mapsController.setListaEdiciones(obtenerEdicion(
            anio: _mapsController.anioSeleccionado.value,
            mes: _mapsController.mesSeleccionado.value));
        listaMarkers.clear();
      });
    }
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    SharedPreferences _shared = await SharedPreferences.getInstance();
    await _mapsController.setSharedPreferencia(_shared);

    iconoActivo = await Utilidades.formarIcono(color: Colores.colorRojo);
    iconoEntregado =
        await Utilidades.formarIcono(color: Colores.textosColorMorado);
    iconoRecogido = await Utilidades.formarIcono(color: Colores.colorBody);
    dynamic response1 = await _mapsController.cargarEdiciones();
    if (response1) {
      dynamic response = await _mapsController.cargarListaZonas();
      if (response) {
        _mapsController.generarListaZonas();
        _init();
      } else {}
    } else {}
  }

  Future mostrarFiltroBusqueda(BuildContext context) async {
    bool estado = await showModalFiltroBusqueda(context: context);
    if (estado != null && estado == true) {
      isFilter = false;
      _buscarPuntosVentas();
    }
  }

  Future<bool> showModalFiltroBusqueda({BuildContext context}) async {
    bool estado = false;
    await showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Container(
            padding: EdgeInsets.all(5.0),
            color: Colors.white,
            child: Stack(
              children: [
                Column(
                  children: [
                    Text("Filtro de búsqueda"),
                    Obx(() {
                      return ListTile(
                        leading: Text("Zona"),
                        title: ListDropdown(
                          listas: _mapsController.listaZonas.value,
                          title: _mapsController.zonaSeleccionado.value,
                          onChanged: (val) {
                            _selectZona(val: val);
                          },
                        ),
                      );
                    }),
                    Obx(() {
                      return ListTile(
                        leading: Text("Año"),
                        title: ListDropdown(
                          title: _mapsController.anioSeleccionado.value,
                          listas: _mapsController.listaAnio.value,
                          onChanged: (val) {
                            _selectAnio(val: val);
                          },
                        ),
                      );
                    }),
                    Obx(() {
                      return ListTile(
                        leading: Text("Mes"),
                        title: ListDropdown(
                          listas: _mapsController.listaMes.value,
                          title: _mapsController.mesSeleccionado.value,
                          onChanged: (val) {
                            _selectMes(val: val);
                          },
                        ),
                      );
                    }),
                    Obx(() {
                      return ListTile(
                        leading: Text("Edición"),
                        title: ListDropdown(
                          listas: _mapsController.listaEdiciones.value,
                          title: _mapsController.edicionSeleccionado.value,
                          onChanged: (val) {
                            _selectEdicion(val: val);
                          },
                        ),
                      );
                    }),
                    Container(
                      height: 2.0,
                      width: double.infinity,
                      color: Colors.grey[300],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        MaterialButton(
                          onPressed: () {
                            estado = false;
                            Navigator.pop(context);
                          },
                          minWidth: 100.0,
                          height: 40.0,
                          child: Text(
                            "Cancelar",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                        MaterialButton(
                          onPressed: () {
                            estado = true;
                            Navigator.pop(context);
                          },
                          minWidth: 100.0,
                          height: 40.0,
                          child: Text(
                            "Aplicar",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                Obx(() => _mapsController.cargando.value == true
                    ? loading()
                    : Container())
              ],
            ),
          );
        });

    return estado;
  }

  Future<bool> showModalDetalleBilletePuntoVenta(
      {@required BuildContext context,
      @required BilletePuntoVenta billetePuntoVenta}) async {
    bool estado = false;
    await showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Container(
            padding: EdgeInsets.all(5.0),
            color: Colors.white,
            child: Column(
              children: [
                ItemDetalleCard(
                  billetePuntoVenta: billetePuntoVenta,
                )
              ],
            ),
          );
        });

    return estado;
  }

  void animate() {
    if (!isOpened)
      _animationController.forward();
    else
      _animationController.reverse();

    isOpened = !isOpened;
  }
}
