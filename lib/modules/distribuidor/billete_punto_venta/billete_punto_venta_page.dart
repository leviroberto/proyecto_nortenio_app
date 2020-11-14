import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:proyect_nortenio_app/data/models/edicion.dart';
import 'package:proyect_nortenio_app/global_widgets/empty_state.dart';
import 'package:proyect_nortenio_app/global_widgets/loading_widget.dart';
import 'package:proyect_nortenio_app/utils/colores.dart';
import 'package:proyect_nortenio_app/utils/utilidades.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'billete_punto_venta_controller.dart';
import 'local_widgets/item_edicion_card.dart';

class BilletePuntoVentaPage extends StatefulWidget {
  @override
  _BilletePuntoVentaPageState createState() => _BilletePuntoVentaPageState();
}

class _BilletePuntoVentaPageState extends State<BilletePuntoVentaPage>
    with AfterLayoutMixin {
  RefreshController _refreshController;
  BilletePuntoVentaControllerD _billetePuntoVentaController = Get.find();

  @override
  void initState() {
    _refreshController = RefreshController(initialRefresh: false);
    super.initState();
  }

  void _onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));

    bool response = await _billetePuntoVentaController.getEdicionesApi();
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
            "Ediciones",
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
                    if (_billetePuntoVentaController.listaEdiciones.length >
                        0) {
                      return SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(5),
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

  List<Widget> recorrerDistribuidores(BilletePuntoVentaControllerD state) {
    List<Widget> listaWidget = new List<Widget>();

    for (int i = 0; i < state.listaEdiciones.length; i++) {
      Edicion edicion = state.listaEdiciones[i];
      listaWidget.add(ItemEdicionCard(
        edicion: edicion,
        onTapActualizar: () {
          _billetePuntoVentaController.goToBilletesPorPuntoVenta(
              edicion: edicion);
        },
      ));
    }

    return listaWidget;
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    SharedPreferences _shared = await SharedPreferences.getInstance();
    await _billetePuntoVentaController.setSharedPreferencia(_shared);
    verificarConexion();
  }

  verificarConexion() async {
    dynamic response = await Utilidades.verificarConexionInternet();
    if (response) {
      await _billetePuntoVentaController.getEdicionesApi();
    } else {
      await _billetePuntoVentaController.getEdicionesLocal();
    }
  }

  void openSearch(BuildContext context) async {
    final lista = _billetePuntoVentaController.listaEdiciones.toList();
    await showSearch(
        context: context, delegate: DataSearch(listaUsuario: lista));
  }
}

class DataSearch extends SearchDelegate<Edicion> {
  final List<Edicion> listaUsuario;

  BilletePuntoVentaControllerD _billetePuntoVentaController =
      Get.put(BilletePuntoVentaControllerD());
  DataSearch({this.listaUsuario});

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
        ? listaUsuario
        : listaUsuario
            .where((p) => p.numero.toLowerCase().contains(query.toLowerCase()))
            .toList();

    return myList.isEmpty
        ? EmptyState()
        : ListView.builder(
            itemCount: myList.length,
            itemBuilder: (context, index) {
              final Edicion edicion = myList[index];

              return ItemEdicionCard(
                edicion: edicion,
                onTapActualizar: () {
                  _billetePuntoVentaController.goToBilletesPorPuntoVenta(
                      edicion: edicion);
                  close(context, null);
                },
              );
            },
          );
  }
}
