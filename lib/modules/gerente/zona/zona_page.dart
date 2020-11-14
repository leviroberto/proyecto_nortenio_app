import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:proyect_nortenio_app/data/models/zona.dart';
import 'package:proyect_nortenio_app/global_widgets/custom_app_bar.dart';
import 'package:proyect_nortenio_app/global_widgets/empty_state.dart';
import 'package:proyect_nortenio_app/global_widgets/loading_widget.dart';
import 'package:proyect_nortenio_app/utils/colores.dart';
import 'package:proyect_nortenio_app/utils/dialogs.dart';
import 'package:proyect_nortenio_app/utils/utilidades.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'local_widgets/item_card.dart';
import 'zona_controller.dart';

class ZonaPage extends StatefulWidget {
  @override
  _ZonaPageState createState() => _ZonaPageState();
}

class _ZonaPageState extends State<ZonaPage> with AfterLayoutMixin {
  RefreshController _refreshController;
  ZonaControllerG _zonaController;

  @override
  void initState() {
    _refreshController = RefreshController(initialRefresh: false);
    super.initState();
  }

  void _onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));
    bool response = await _zonaController.getZonaApi();
    if (response) {
      _refreshController.refreshCompleted();
    } else {
      _zonaController.getZonaLocal();
      _refreshController.refreshCompleted();
    }
  }

  void _onLoading() async {
    await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    _zonaController = Get.put(ZonaControllerG());
    return Scaffold(
      backgroundColor: Colores.bodyColor,
      appBar: CustomAppBar(
        title: "Zonas",
        haveSearch: true,
        onTapAtras: () {
          Navigator.pop(context);
        },
        onTapSearch: () {
          openSearch(context);
        },
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
                    if (_zonaController.listaZonas.length > 0) {
                      return SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Column(
                            children: recorrerDistribuidores(_zonaController),
                          ),
                        ),
                      );
                    }
                    return EmptyState();
                  })),
            ),
            Obx(() => _zonaController.cargando.value == true
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
          _zonaController.goToAgregar();
        },
      ),
    );
  }

  List<Widget> recorrerDistribuidores(ZonaControllerG state) {
    List<Widget> listaWidget = new List<Widget>();

    for (int i = 0; i < state.listaZonas.length; i++) {
      Zona zona = state.listaZonas[i];
      listaWidget.add(ItemCard(
        zona: zona,
        onTapActualizar: () {
          _zonaController.goToActualizar(
            zona: zona,
          );
        },
        onTapEliminar: () {
          _confirmarEliminar(context: context, id: zona.id);
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
      _zonaController.eliminar(id: id);
    }
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    SharedPreferences _shared = await SharedPreferences.getInstance();
    await _zonaController.setSharedPreferencia(_shared);
    verificarConexion();
  }

  verificarConexion() async {
    dynamic response = await Utilidades.verificarConexionInternet();
    if (response) {
      await _zonaController.getZonaApi();
    } else {
      await _zonaController.getZonaLocal();
    }
  }

  void openSearch(BuildContext context) async {
    final lista = _zonaController.listaZonas.toList();
    await showSearch(context: context, delegate: DataSearch(lista: lista));
  }
}

class DataSearch extends SearchDelegate<Zona> {
  final List<Zona> lista;

  ZonaControllerG _zonaController = Get.put(ZonaControllerG());
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
            .where((p) => p.zona.toLowerCase().contains(query.toLowerCase()))
            .toList();

    return myList.isEmpty
        ? EmptyState()
        : ListView.builder(
            itemCount: myList.length,
            itemBuilder: (context, index) {
              final Zona zona = myList[index];

              return ItemCard(
                zona: zona,
                onTapActualizar: () {
                  _zonaController.goToActualizar(
                    zona: zona,
                  );
                  close(context, null);
                },
                onTapEliminar: () {
                  _confirmarEliminar(context: context, id: zona.id);
                },
              );
            },
          );
  }
}
