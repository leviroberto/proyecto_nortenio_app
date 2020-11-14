import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:proyect_nortenio_app/data/models/edicion.dart';
import 'package:proyect_nortenio_app/global_widgets/empty_state.dart';
import 'package:proyect_nortenio_app/global_widgets/loading_widget.dart';
import 'package:proyect_nortenio_app/global_widgets/tiktok_loading.dart';
import 'package:proyect_nortenio_app/utils/colores.dart';
import 'package:proyect_nortenio_app/utils/utilidades.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'billetes_controller.dart';
import 'local_widgets/item_edicion_card.dart';

class BilletePage extends StatefulWidget {
  @override
  _BilletePageState createState() => _BilletePageState();
}

class _BilletePageState extends State<BilletePage> with AfterLayoutMixin {
  RefreshController _refreshController;
  BilletesControllerG _billetesController;

  @override
  void initState() {
    _refreshController = RefreshController(initialRefresh: false);
    super.initState();
  }

  void _onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));

    bool response = await _billetesController.getEdicionesApi();
    if (response) {
      _refreshController.refreshCompleted();
    } else {
      _billetesController.getEdicionesLocal();
      _refreshController.refreshCompleted();
    }
  }

  void _onLoading() async {
    await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    _billetesController = Get.put(BilletesControllerG());
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
            "Billetes por ediciones",
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colores.bodyColor,
              fontFamily: 'poppins',
              fontSize: 18,
              letterSpacing: 1,
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
                        body = Text("No hay más datos");
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
                    if (_billetesController.listaEdiciones.length > 0) {
                      return SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Column(
                            children: recorrerEdiciones(_billetesController),
                          ),
                        ),
                      );
                    } else {
                      return EmptyState();
                    }
                  })),
            ),
            Obx(() => _billetesController.cargando.value == true
                ? TikTokLoadingAnimation()
                : Container())
          ],
        ),
      ),
    );
  }

  List<Widget> recorrerEdiciones(BilletesControllerG state) {
    List<Widget> listaWidget = new List<Widget>();

    for (int i = 0; i < state.listaEdiciones.length; i++) {
      Edicion edicion = state.listaEdiciones[i];
      listaWidget.add(ItemEdicionCard(
        edicion: edicion,
        onTapActualizar: () {
          _billetesController.goToEdicion(edicion: edicion);
        },
      ));
    }

    return listaWidget;
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    SharedPreferences _shared = await SharedPreferences.getInstance();
    await _billetesController.setSharedPreferencia(_shared);
    verificarConexion();
  }

  verificarConexion() async {
    dynamic response = await Utilidades.verificarConexionInternet();
    if (response) {
      await _billetesController.getEdicionesApi();
    } else {
      await _billetesController.getEdicionesLocal();
    }
  }

  void openSearch(BuildContext context) async {
    final lista = _billetesController.listaEdiciones.toList();
    await showSearch(
        context: context, delegate: DataSearch(listaUsuario: lista));
  }
}

class DataSearch extends SearchDelegate<Edicion> {
  final List<Edicion> listaUsuario;

  BilletesControllerG _billetesController = Get.put(BilletesControllerG());
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
                  _billetesController.goToEdicion(edicion: edicion);
                  close(context, null);
                },
              );
            },
          );
  }
}
