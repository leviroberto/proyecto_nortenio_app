import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:proyect_nortenio_app/data/models/usuario.dart';
import 'package:proyect_nortenio_app/data/models/zonaMotorizado.dart';
import 'package:proyect_nortenio_app/global_widgets/empty_state.dart';
import 'package:proyect_nortenio_app/global_widgets/loading_widget.dart';
import 'package:proyect_nortenio_app/utils/colores.dart';
import 'package:proyect_nortenio_app/utils/dialogs.dart';
import 'package:proyect_nortenio_app/utils/utilidades.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'local_widgets/item_card.dart';
import 'motirizado_controller.dart';

class MotirizadoPage extends StatefulWidget {
  final bool isBack;

  const MotirizadoPage({this.isBack = true});
  @override
  _MotirizadoPageState createState() => _MotirizadoPageState();
}

class _MotirizadoPageState extends State<MotirizadoPage> with AfterLayoutMixin {
  RefreshController _refreshController;
  MotorizadoControllerD _motirizadoController = Get.find();

  @override
  void initState() {
    _refreshController = RefreshController(initialRefresh: false);
    super.initState();
  }

  @override
  void dispose() {
    _motirizadoController.onClose();
    _refreshController.dispose();
    super.dispose();
  }

  void _onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));

    bool response = await _motirizadoController.getZonaMotorizadosApi();
    if (response) {
      _refreshController.refreshCompleted();
    } else {
      _motirizadoController.getZonaMotorizadosLocal();
      _refreshController.refreshCompleted();
    }
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()

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
            "Motorizados",
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
                    if (_motirizadoController.listaZonaMotorizado.length > 0) {
                      return SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Column(
                            children:
                                recorrerDistribuidores(_motirizadoController),
                          ),
                        ),
                      );
                    }
                    return EmptyState();
                  })),
            ),
            Obx(() => _motirizadoController.cargando.value == true
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
          _motirizadoController.goToAgregar();
        },
      ),
    );
  }

  List<Widget> recorrerDistribuidores(MotorizadoControllerD state) {
    List<Widget> listaWidget = new List<Widget>();

    for (int i = 0; i < state.listaZonaMotorizado.length; i++) {
      ZonaMotorizado zonaMotorizado = state.listaZonaMotorizado[i];
      listaWidget.add(ItemCard(
        zonaMotorizado: zonaMotorizado,
        onTapActualizar: () {
          _motirizadoController.goToActualizar(
            zonaMotorizado: zonaMotorizado,
          );
        },
        onTapEliminar: () {
          _confirmarEliminar(context: context, id: zonaMotorizado.id);
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
      _motirizadoController.eliminar(id: id);
    }
  }

  void openSearch(BuildContext context) async {
    final lista = _motirizadoController.listaZonaMotorizado.toList();
    await showSearch(context: context, delegate: DataSearch(lista: lista));
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    SharedPreferences _shared = await SharedPreferences.getInstance();
    await _motirizadoController.setSharedPreferencia(_shared);
    verificarConexion();
  }

  verificarConexion() async {
    dynamic response = await Utilidades.verificarConexionInternet();
    if (response) {
      await _motirizadoController.getZonaMotorizadosApi();
    } else {
      await _motirizadoController.getZonaMotorizadosLocal();
    }
  }
}

class DataSearch extends SearchDelegate<Usuario> {
  final List<ZonaMotorizado> lista;

  MotorizadoControllerD _motorizadoController =
      Get.put(MotorizadoControllerD());
  DataSearch({this.lista});

  _confirmarEliminar({BuildContext context, int id}) async {
    final isOk = await Dialogs.confirm(context,
        title: "ACCIÓN REQUERIDA", body: "Esta seguro de que desea eliminar?");
    print("isOk $isOk");
    if (isOk) {
      _motorizadoController.eliminar(id: id);
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
            .where((p) => p.motorizado.nombreCompleto
                .toLowerCase()
                .contains(query.toLowerCase()))
            .toList();

    return myList.isEmpty
        ? EmptyState()
        : ListView.builder(
            itemCount: myList.length,
            itemBuilder: (context, index) {
              final ZonaMotorizado zonaMotorizado = myList[index];

              return ItemCard(
                zonaMotorizado: zonaMotorizado,
                onTapActualizar: () {
                  _motorizadoController.goToActualizar(
                    zonaMotorizado: zonaMotorizado,
                  );
                  close(context, null);
                },
                onTapEliminar: () {
                  _confirmarEliminar(context: context, id: zonaMotorizado.id);
                },
              );
            },
          );
  }
}
