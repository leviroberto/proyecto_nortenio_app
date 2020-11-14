import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:proyect_nortenio_app/data/models/billete_punto_venta.dart';
import 'package:proyect_nortenio_app/data/models/edicion.dart';
import 'package:proyect_nortenio_app/global_widgets/empty_state.dart';
import 'package:proyect_nortenio_app/global_widgets/loading_widget.dart';
import 'package:proyect_nortenio_app/utils/colores.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'billete_punto_venta_controller.dart';
import 'local_widgets/item_card.dart';

class BilletePuntoVentaPorEdicion extends StatefulWidget {
  final Edicion edicion;

  const BilletePuntoVentaPorEdicion({Key key, this.edicion}) : super(key: key);
  @override
  _BilletePuntoVentaPorEdicionState createState() =>
      _BilletePuntoVentaPorEdicionState();
}

class _BilletePuntoVentaPorEdicionState
    extends State<BilletePuntoVentaPorEdicion> with AfterLayoutMixin {
  RefreshController _refreshController;
  BilletePuntoVentaControllerM _billetePuntoVentaController;

  @override
  void initState() {
    _refreshController = RefreshController(initialRefresh: false);

    super.initState();
  }

  void _onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));

    bool response =
        await _billetePuntoVentaController.listaBilletePuntoVentaPorEdicion();
    if (response) {
      _refreshController.refreshCompleted();
    }
  }

  void _onLoading() async {
    await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    _billetePuntoVentaController = Get.put(BilletePuntoVentaControllerM());
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
        elevation: 2,
        backgroundColor: Colores.colorBody,
        title: Center(
          child: Text(
            "Punto de ventas",
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
                    if (_billetePuntoVentaController.listaEdiciones.length >
                        0) {
                      return SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Column(
                            children: recorrerDistribuidores(
                                _billetePuntoVentaController),
                          ),
                        ),
                      );
                    }
                    return EmptyState();
                  })),
            ),
            Obx(() => _billetePuntoVentaController.cargando.value == true
                ? loading()
                : Container())
          ],
        ),
      ),
    );
  }

  List<Widget> recorrerDistribuidores(BilletePuntoVentaControllerM state) {
    List<Widget> listaWidget = new List<Widget>();

    for (int i = 0; i < state.listaBilletesPuntoVenta.length; i++) {
      BilletePuntoVenta billetePuntoVenta = state.listaBilletesPuntoVenta[i];
      listaWidget.add(ItemCard(
        billetePuntoVenta: billetePuntoVenta,
        onTapActualizar: () {
          _billetePuntoVentaController.goToOpciones(
              billetePuntoVenta: billetePuntoVenta);
        },
      ));
    }
    return listaWidget;
  }

  @override
  void afterFirstLayout(BuildContext context) {
    _init();
  }

  void _init() {
    _billetePuntoVentaController.setEdicion(edicion: widget.edicion);
    _billetePuntoVentaController.listaBilletePuntoVentaPorEdicion();
  }

  void openSearch(BuildContext context) async {
    final lista = _billetePuntoVentaController.listaBilletesPuntoVenta.toList();
    await showSearch(context: context, delegate: DataSearch(lista: lista));
  }
}

class DataSearch extends SearchDelegate<Edicion> {
  final List<BilletePuntoVenta> lista;

  BilletePuntoVentaControllerM _billetePuntoVentaController = Get.find();
  DataSearch({this.lista});

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
            .where((p) => p.puntoVenta.razonSocial
                .toLowerCase()
                .contains(query.toLowerCase()))
            .toList();

    return myList.isEmpty
        ? EmptyState()
        : ListView.builder(
            itemCount: myList.length,
            itemBuilder: (context, index) {
              final BilletePuntoVenta billetePuntoVenta = myList[index];

              return ItemCard(
                billetePuntoVenta: billetePuntoVenta,
                onTapActualizar: () {
                  _billetePuntoVentaController.goToActualizar(
                      billetePuntoVenta: billetePuntoVenta);
                  close(context, null);
                },
              );
            },
          );
  }
}
