import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:proyect_nortenio_app/data/models/punto_venta.dart';
import 'package:proyect_nortenio_app/global_widgets/empty_state.dart';
import 'package:proyect_nortenio_app/global_widgets/loading_widget.dart';
import 'package:proyect_nortenio_app/utils/colores.dart';
import 'package:proyect_nortenio_app/utils/dialogs.dart';
import 'package:proyect_nortenio_app/utils/utilidades.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'local_widgets/item_card.dart';
import 'punto_venta_controller.dart';

class PuntoVentaPage extends StatefulWidget {
  final bool isBack;

  const PuntoVentaPage({this.isBack = true});
  @override
  _PuntoVentaPageState createState() => _PuntoVentaPageState();
}

class _PuntoVentaPageState extends State<PuntoVentaPage> with AfterLayoutMixin {
  RefreshController _refreshController;
  PuntoVentaControllerD _puntoVentaController = Get.find();

  @override
  void initState() {
    _refreshController = RefreshController(initialRefresh: false);
    super.initState();
  }

  @override
  void dispose() {
    _puntoVentaController.onClose();
    _refreshController.dispose();
    super.dispose();
  }

  void _onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));

    bool response = await _puntoVentaController.getPuntoVentasApi();
    if (response) {
      _refreshController.refreshCompleted();
    } else {
      _puntoVentaController.getPuntoVentasLocal();
      _refreshController.refreshCompleted();
    }
  }

  void _onLoading() async {
    await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colores.bodyColor,
      appBar: AppBar(
        leading: widget.isBack
            ? IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colores.bodyColor,
                ),
                onPressed: () {
                  Navigator.pop(context);
                })
            : Container(),
        elevation: 1,
        backgroundColor: Colores.colorBody,
        title: Center(
          child: Text(
            "Puntos de ventas",
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colores.bodyColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [
          IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: () {
                openSearch(context);
              })
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
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
                        body =
                            Text("¡Error de carga! Haga clic en reintentar.");
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
                  child: Obx(() {
                    if (_puntoVentaController.listaPuntoVentas.length > 0) {
                      return SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Column(
                            children:
                                recorrerDistribuidores(_puntoVentaController),
                          ),
                        ),
                      );
                    }
                    return EmptyState();
                  })),
            ),
            Obx(() => _puntoVentaController.cargando.value == true
                ? loading()
                : Container())
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        child: Icon(
          Icons.add,
          size: 40,
        ),
        backgroundColor: Colores.colorButton,
        foregroundColor: Colores.bodyColor,
        onPressed: () {
          _puntoVentaController.goToAgregar();
        },
      ),
    );
  }

  List<Widget> recorrerDistribuidores(PuntoVentaControllerD state) {
    List<Widget> listaWidget = new List<Widget>();

    for (int i = 0; i < state.listaPuntoVentas.length; i++) {
      PuntoVenta puntoVenta = state.listaPuntoVentas[i];
      listaWidget.add(ItemCard(
        puntoVenta: puntoVenta,
        onTapActualizar: () {
          _puntoVentaController.goToActualizar(
            puntoVenta: puntoVenta,
          );
        },
        onTapEliminar: () {
          _confirmarEliminar(context: context, id: puntoVenta.id);
        },
      ));
    }

    return listaWidget;
  }

  _confirmarEliminar({BuildContext context, int id}) async {
    final isOk = await Dialogs.confirm(context,
        title: "ACCIÓN REQUERIDA", body: "Esta seguro de que desea eliminar?");
    print("isOk $isOk");
    if (isOk) {
      _puntoVentaController.eliminar(id: id);
    }
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    SharedPreferences _shared = await SharedPreferences.getInstance();
    await _puntoVentaController.setSharedPreferencia(_shared);
    verificarConexion();
  }

  verificarConexion() async {
    dynamic response = await Utilidades.verificarConexionInternet();
    if (response) {
      await _puntoVentaController.getPuntoVentasApi();
    } else {
      await _puntoVentaController.getPuntoVentasLocal();
    }
  }

  void openSearch(BuildContext context) async {
    final lista = _puntoVentaController.listaPuntoVentas.toList();
    await showSearch(context: context, delegate: DataSearch(lista: lista));
  }
}

class DataSearch extends SearchDelegate<PuntoVenta> {
  final List<PuntoVenta> lista;

  PuntoVentaControllerD _zonaController = Get.put(PuntoVentaControllerD());
  DataSearch({this.lista});

  _confirmarEliminar({BuildContext context, int id}) async {
    final isOk = await Dialogs.confirm(context,
        title: "ACCIÓN REQUERIDA", body: "Esta seguro de que desea eliminar?");
    print("isOk $isOk");
    if (isOk) {
      _zonaController.eliminar(id: id);
      close(context, null);
    }
  }

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
          close(context, null);
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
        : lista
            .where((p) =>
                p.razonSocial.toLowerCase().contains(query.toLowerCase()))
            .toList();

    return myList.isEmpty
        ? EmptyState()
        : ListView.builder(
            itemCount: myList.length,
            itemBuilder: (context, index) {
              final PuntoVenta puntoVenta = myList[index];

              return ItemCard(
                puntoVenta: puntoVenta,
                onTapActualizar: () {
                  _zonaController.goToActualizar(
                    puntoVenta: puntoVenta,
                  );
                  close(context, null);
                },
                onTapEliminar: () {
                  _confirmarEliminar(context: context, id: puntoVenta.id);
                },
              );
            },
          );
  }
}
