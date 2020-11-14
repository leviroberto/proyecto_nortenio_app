import 'dart:async';
import 'package:after_layout/after_layout.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:proyect_nortenio_app/global_widgets/custom_app_bar.dart';
import 'package:proyect_nortenio_app/global_widgets/empty_state.dart';
import 'package:proyect_nortenio_app/global_widgets/loading_widget.dart';
import 'package:proyect_nortenio_app/modules/gerente/distribuidor/local_widgets/item_card.dart';
import 'package:proyect_nortenio_app/utils/dialogs.dart';
import 'package:proyect_nortenio_app/utils/utilidades.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/models/usuario.dart';
import '../../../utils/colores.dart';
import 'distribuidor_controller.dart';

class DistribuidorPage extends StatefulWidget {
  @override
  _DistribuidorPageState createState() => _DistribuidorPageState();
}

class _DistribuidorPageState extends State<DistribuidorPage>
    with AfterLayoutMixin {
  RefreshController _refreshController;
  DistribuidorControllerG _distribuidorController = Get.find();

  StreamSubscription<ConnectivityResult> subscription;
  @override
  void initState() {
    _refreshController = RefreshController(initialRefresh: false);
    super.initState();
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  void _onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));

    bool response = await _distribuidorController.getDistribuidoresApi();
    if (response) {
      _refreshController.refreshCompleted();
    } else {
      await _distribuidorController.getDistribuidoresLocal();
      _refreshController.refreshCompleted();
    }
  }

  void _onLoading() async {
    await Future.delayed(Duration(milliseconds: 1000));

    bool response = await _distribuidorController.getDistribuidoresApi();
    if (response) {
      _refreshController.refreshCompleted();
    } else {
      await _distribuidorController.getDistribuidoresLocal();
      _refreshController.refreshCompleted();
    }

    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colores.bodyColor,
      appBar: CustomAppBar(
        title: "Distribuidores",
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
                    if (_distribuidorController.listaDistribuidores.length >
                        0) {
                      return SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Column(
                            children:
                                recorrerDistribuidores(_distribuidorController),
                          ),
                        ),
                      );
                    }
                    return EmptyState();
                  })),
            ),
            Obx(() => _distribuidorController.cargando.value == true
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
          _distribuidorController.goToAgregar();
        },
      ),
    );
  }

  List<Widget> recorrerDistribuidores(DistribuidorControllerG state) {
    List<Widget> listaWidget = new List<Widget>();

    for (int i = 0; i < state.listaDistribuidores.length; i++) {
      Usuario distribuidor = state.listaDistribuidores[i];
      listaWidget.add(ItemCard(
        distribuidor: distribuidor,
        onTapActualizar: () {
          _distribuidorController.goToActualizar(
            distribuidor: distribuidor,
          );
        },
        onTapEliminar: () {
          _confirmarEliminar(context: context, id: distribuidor.id);
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
      _distribuidorController.eliminar(id: id);
    }
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    SharedPreferences _shared = await SharedPreferences.getInstance();
    await _distribuidorController.setSharedPreferencia(_shared);
    verificarConexion();
  }

  verificarConexion() async {
    dynamic response = await Utilidades.verificarConexionInternet();
    if (response) {
      await _distribuidorController.getDistribuidoresApi();
    } else {
      await _distribuidorController.getDistribuidoresLocal();
    }
  }

  void openSearch(BuildContext context) async {
    final lista = _distribuidorController.listaDistribuidores.toList();
    Usuario _distribuidor = await showSearch(
        context: context, delegate: DataSearch(listaUsuario: lista));
    if (_distribuidor != null) {
      _distribuidorController.goToActualizar(
        distribuidor: _distribuidor,
      );
    } else {
      print("hola1");
    }
  }
}

class DataSearch extends SearchDelegate<Usuario> {
  final List<Usuario> listaUsuario;

  DistribuidorControllerG _distribuidorController =
      Get.put(DistribuidorControllerG());
  DataSearch({this.listaUsuario});

  _confirmarEliminar({BuildContext context, int id}) async {
    final isOk = await Dialogs.confirm(context,
        title: "ACCIÓN REQUERIDA", body: "Esta seguro de que desea eliminar?");
    print("isOk $isOk");
    if (isOk) {
      _distribuidorController.eliminar(id: id);
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
            .where((p) =>
                p.nombreCompleto.toLowerCase().contains(query.toLowerCase()))
            .toList();

    return myList.isEmpty
        ? EmptyState()
        : ListView.builder(
            itemCount: myList.length,
            itemBuilder: (context, index) {
              final Usuario distribuidor = myList[index];

              return ItemCard(
                distribuidor: distribuidor,
                onTapActualizar: () {
                  _distribuidorController.goToActualizar(
                    distribuidor: distribuidor,
                  );
                  close(context, null);
                },
                onTapEliminar: () {
                  _confirmarEliminar(context: context, id: distribuidor.id);
                },
              );
            },
          );
  }
}
