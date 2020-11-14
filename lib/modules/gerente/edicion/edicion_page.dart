import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:proyect_nortenio_app/data/models/edicion.dart';
import 'package:proyect_nortenio_app/global_widgets/custom_app_bar.dart';
import 'package:proyect_nortenio_app/global_widgets/empty_state.dart';
import 'package:proyect_nortenio_app/global_widgets/loading_widget.dart';
import 'package:proyect_nortenio_app/utils/colores.dart';
import 'package:proyect_nortenio_app/utils/dialogs.dart';
import 'package:proyect_nortenio_app/utils/utilidades.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'edicion_controller.dart';
import 'local_widgets/item_card.dart';

class EdicionPage extends StatefulWidget {
  @override
  _EdicionPageState createState() => _EdicionPageState();
}

class _EdicionPageState extends State<EdicionPage> with AfterLayoutMixin {
  RefreshController _refreshController;
  EdicionControllerG _edicionController;

  @override
  void initState() {
    _refreshController = RefreshController(initialRefresh: false);
    super.initState();
  }

  void _onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));

    bool response = await _edicionController.getEdicionesApi();
    if (response) {
      _refreshController.refreshCompleted();
    } else {
      _edicionController.getEdicionesLocal();
      _refreshController.refreshCompleted();
    }
  }

  void _onLoading() async {
    await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    _edicionController = Get.put(EdicionControllerG());
    return Scaffold(
      backgroundColor: Colores.bodyColor,
      appBar: CustomAppBar(
        title: "Ediciones",
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
                    if (_edicionController.listaEdiciones.length > 0) {
                      return SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Column(
                            children: recorrerEdiciones(_edicionController),
                          ),
                        ),
                      );
                    }
                    return EmptyState();
                  })),
            ),
            Obx(() => _edicionController.cargando.value == true
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
          _edicionController.goToAgregar();
        },
      ),
    );
  }

  List<Widget> recorrerEdiciones(EdicionControllerG state) {
    List<Widget> listaWidget = new List<Widget>();

    for (int i = 0; i < state.listaEdiciones.length; i++) {
      Edicion edicion = state.listaEdiciones[i];
      listaWidget.add(ItemCard(
        edicion: edicion,
        onTapActualizar: () {
          _edicionController.goToActualizar(
            edicion: edicion,
          );
        },
        onTapEliminar: () {
          _confirmarEliminar(context: context, id: edicion.id);
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
      _edicionController.eliminar(id: id);
    }
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    SharedPreferences _shared = await SharedPreferences.getInstance();
    await _edicionController.setSharedPreferencia(_shared);
    verificarConexion();
  }

  verificarConexion() async {
    dynamic response = await Utilidades.verificarConexionInternet();
    if (response) {
      await _edicionController.getEdicionesApi();
    } else {
      await _edicionController.getEdicionesLocal();
    }
  }

  void openSearch(BuildContext context) async {
    final lista = _edicionController.listaEdiciones.toList();
    await showSearch(
        context: context, delegate: DataSearch(listaUsuario: lista));
  }
}

class DataSearch extends SearchDelegate<Edicion> {
  final List<Edicion> listaUsuario;

  EdicionControllerG _edicionController = Get.put(EdicionControllerG());
  DataSearch({this.listaUsuario});

  _confirmarEliminar({BuildContext context, int id}) async {
    final isOk = await Dialogs.confirm(context,
        title: "ACCIÓN REQUERIDA", body: "Esta seguro de que desea eliminar?");
    print("isOk $isOk");
    if (isOk) {
      _edicionController.eliminar(id: id);
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

              return ItemCard(
                edicion: edicion,
                onTapActualizar: () {
                  _edicionController.goToActualizar(
                    edicion: edicion,
                  );
                  close(context, null);
                },
                onTapEliminar: () {
                  _confirmarEliminar(context: context, id: edicion.id);
                },
              );
            },
          );
  }
}
