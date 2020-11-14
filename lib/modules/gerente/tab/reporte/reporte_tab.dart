import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:proyect_nortenio_app/data/models/billete_distribuidor_.dart';
import 'package:proyect_nortenio_app/data/models/edicion.dart';
import 'package:proyect_nortenio_app/global_widgets/empty_state.dart';
import 'package:proyect_nortenio_app/global_widgets/loading_widget.dart';
import 'package:proyect_nortenio_app/modules/gerente/tab/reporte/reporte_controller.dart';
import 'package:proyect_nortenio_app/utils/colores.dart';
import 'package:proyect_nortenio_app/utils/lista.dart';
import 'package:proyect_nortenio_app/utils/responsive.dart';
import 'package:proyect_nortenio_app/utils/util.dart';
import 'package:proyect_nortenio_app/utils/utilidades.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../widgets/ListDropdown.dart';
import '../widgets/chart_semanal.dart';

class ReporteTab extends StatefulWidget {
  @override
  _ReporteTabState createState() => _ReporteTabState();
}

class _ReporteTabState extends State<ReporteTab> with AfterLayoutMixin {
  String _edicion;
  String _mes;
  String _anio;
  RefreshController _refreshController;
  Widget widgetYear = Container();
  Widget widgetEdicion = Container();
  Widget widgetMes = Container();

  List<String> listaAnio = new List<String>();
  List<String> listaEdicion = new List<String>();
  List<String> listaMes = Lista.listaMeses;

  bool isSelectedEdicion = false;

  ReporteControllerg _reporteController = Get.put(ReporteControllerg());

  @override
  void initState() {
    _refreshController = RefreshController(initialRefresh: false);
    super.initState();
  }

  void _onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));

    bool response = await _reporteController.cargarListaAnio();
    if (response) {
      _init();
      _refreshController.refreshCompleted();
    }
  }

  void _onLoading() async {
    await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.loadComplete();
  }

  _selectPais({String val}) {
    if (_anio == null) {
      setState(() {
        isSelectedEdicion = false;
        _anio = val;
        _mes = null;
        _edicion = null;
        listaEdicion = [];
        listaMes = [];
        listaMes = Lista.listaMeses;
      });
    } else if (val != _anio) {
      setState(() {
        isSelectedEdicion = false;
        _anio = val;
        _mes = null;
        _edicion = null;
        listaEdicion = [];
        listaMes = [];
        listaMes = Lista.listaMeses;
      });
    }
  }

  _selectMes({String val}) {
    if (_mes == null) {
      setState(() {
        isSelectedEdicion = false;
        _mes = val;
        _edicion = null;
        listaEdicion = [];
        _reporteController.listaBilleteDistribuidor.clear();
        listaEdicion = obtenerEdicion(anio: _anio, mes: _mes);
      });
    } else if (_mes != val) {
      setState(() {
        isSelectedEdicion = false;
        _mes = val;
        _edicion = null;
        listaEdicion = [];
        _reporteController.listaBilleteDistribuidor.clear();
        listaEdicion = obtenerEdicion(anio: _anio, mes: _mes);
      });
    }
  }

  _selectEdicion({String val}) async {
    List<String> valor = val.split("E");
    if (_edicion == null) {
      setState(() {
        _edicion = val;
        isSelectedEdicion = true;
      });
      await _reporteController.cargarBilletePuntoVentaPorEdicion(
          edicion: valor[1]);
    } else if (_edicion != val) {
      setState(() {
        _edicion = val;
        isSelectedEdicion = true;
      });
      await _reporteController.cargarBilletePuntoVentaPorEdicion(
          edicion: valor[1]);
    }
  }

  _init() {
    isSelectedEdicion = false;
    _anio = null;
    _mes = null;
    _edicion = null;
    listaMes = [];
    listaEdicion = [];
    _reporteController.listaBilleteDistribuidor.clear();
  }

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              child: SmartRefresher(
                enablePullDown: true,
                enablePullUp: true,
                header: WaterDropHeader(),
                footer: CustomFooter(
                  builder: (BuildContext context, LoadStatus mode) {
                    Widget body;
                    if (mode == LoadStatus.idle) {
                      body = Text("Se cargo todo");
                    } else if (mode == LoadStatus.loading) {
                      body = loading();
                    } else if (mode == LoadStatus.failed) {
                      body = Text("¡Error de carga! Haga clic en reintentar.");
                    } else if (mode == LoadStatus.canLoading) {
                      body = Text("suelte para cargar más");
                    } else {
                      body = Text("No hay mas datos");
                    }
                    return Container(
                      height: 55.0,
                      child: Center(child: body),
                    );
                  },
                ),
                controller: _refreshController,
                onRefresh: _onRefresh,
                onLoading: _onLoading,
                child: CustomScrollView(
                  physics: ClampingScrollPhysics(),
                  slivers: [
                    _buildHeader(responsive.height),
                    _reportesSemanal(responsive.height),
                  ],
                ),
              ),
            ),
            Obx(() => _reporteController.isSelectedEdicion.value == true
                ? loading()
                : Container())
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildHeader(double height) {
    final Responsive responsive = Responsive.of(context);
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colores.colorBody,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(40.0),
            bottomRight: Radius.circular(40.0),
            topLeft: Radius.circular(40.0),
            topRight: Radius.circular(40.0),
          ),
        ),
        child: Obx(
          () {
            if (_reporteController.listaEdicion.length > 0) {
              listaAnio =
                  Utilidades.generaListaAnios(_reporteController.listaEdicion);
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ListDropdown(
                          title: _anio,
                          listas: listaAnio,
                          onChanged: (val) {
                            _selectPais(val: val);
                          },
                        ),
                        SizedBox(width: responsive.heightPercent(3)),
                        listaMes.length > 0
                            ? ListDropdown(
                                listas: listaMes,
                                title: _mes,
                                onChanged: (val) {
                                  _selectMes(val: val);
                                },
                              )
                            : Container(),
                        SizedBox(width: responsive.heightPercent(3)),
                        listaEdicion.length > 0
                            ? ListDropdown(
                                listas: listaEdicion,
                                title: _edicion,
                                onChanged: (val) {
                                  _selectEdicion(val: val);
                                },
                              )
                            : Container(),
                      ],
                    ),
                  ],
                ),
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }

  SliverToBoxAdapter _reportesSemanal(double height) {
    return SliverToBoxAdapter(
      child: Container(
        decoration: BoxDecoration(
          color: Colores.bodyColor,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(40.0),
            bottomRight: Radius.circular(40.0),
          ),
        ),
        child: Obx(() => _reporteController.listaBilleteDistribuidor.length > 0
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: contrastruirChartSemanal(),
              )
            : EmptyState()),
      ),
    );
  }

  List<Widget> contrastruirChartSemanal() {
    List<Widget> listaWidget = new List<Widget>();

    for (int i = 0;
        i < _reporteController.listaBilleteDistribuidor.length;
        i++) {
      BilleteDistribuidor billeteDistribuidor =
          _reporteController.listaBilleteDistribuidor[i];
      listaWidget.add(ChartSemanal(
        billeteDistribuidor: billeteDistribuidor,
      ));
    }

    return listaWidget;
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    await _reporteController.cargarListaAnio();
    _init();
  }

  List<String> obtenerEdicion({String anio, String mes}) {
    this._reporteController.cargando.value = true;
    List<String> listaEdicionAux = new List<String>();
    for (int i = 0; i < _reporteController.listaEdicion.length; i++) {
      Edicion edicion = _reporteController.listaEdicion[i] ?? null;
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
    this._reporteController.cargando.value = false;

    return listaEdicionAux;
  }
}
