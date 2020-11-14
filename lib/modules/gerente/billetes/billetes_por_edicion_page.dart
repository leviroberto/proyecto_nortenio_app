import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:proyect_nortenio_app/data/models/billete_distribuidor_.dart';
import 'package:proyect_nortenio_app/data/models/edicion.dart';
import 'package:proyect_nortenio_app/global_widgets/empty_state.dart';
import 'package:proyect_nortenio_app/global_widgets/loading_widget.dart';
import 'package:proyect_nortenio_app/global_widgets/titulo_appBar.dart';
import 'package:proyect_nortenio_app/utils/colores.dart';
import 'package:proyect_nortenio_app/utils/dialogs.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'billetes_controller.dart';
import 'local_widgets/item_card.dart';

class BilletePorEdicionPage extends StatefulWidget {
  final Edicion edicion;

  const BilletePorEdicionPage({Key key, this.edicion}) : super(key: key);
  @override
  _BilletePorEdicionPageState createState() => _BilletePorEdicionPageState();
}

class _BilletePorEdicionPageState extends State<BilletePorEdicionPage>
    with AfterLayoutMixin {
  RefreshController _refreshController;
  BilletesControllerG _billetesController;

  @override
  void initState() {
    _refreshController = RefreshController(initialRefresh: false);
    super.initState();
  }

  void _onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));

    bool response = await _billetesController.cargarLista();
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
          child: TituloAppBar(
            title: "Edición N° " + widget.edicion.numero,
            isBold: true,
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
                    if (_billetesController.listaBilletes.length > 0) {
                      return SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Column(
                            children:
                                recorrerDistribuidores(_billetesController),
                          ),
                        ),
                      );
                    }
                    return EmptyState();
                  })),
            ),
            Obx(() => _billetesController.cargando.value == true
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
        backgroundColor: widget.edicion.estado == 1
            ? Colores.colorButton
            : Colores.textosColorGris,
        foregroundColor: Colores.bodyColor,
        onPressed: () {
          if (widget.edicion.estado == 1) {
            _billetesController.goToAgregar();
          }
        },
      ),
    );
  }

  List<Widget> recorrerDistribuidores(BilletesControllerG state) {
    List<Widget> listaWidget = new List<Widget>();

    for (int i = 0; i < state.listaBilletes.length; i++) {
      BilleteDistribuidor billete = state.listaBilletes[i];
      listaWidget.add(ItemCard(
        billeteDistribuidor: billete,
        onTapActualizar: () {
          _billetesController.goToActualizar(billete: billete);
        },
        onTapEliminar: () {
          _confirmarEliminar(context: context, id: billete.id);
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
      _billetesController.eliminar(id: id);
    }
  }

  @override
  void afterFirstLayout(BuildContext context) {
    _billetesController.setEdicion(edicion: widget.edicion);

    _billetesController.cargarLista();
  }

  void openSearch(BuildContext context) async {
    final lista = _billetesController.listaBilletes.toList();
    await showSearch(context: context, delegate: DataSearch(lista: lista));
  }
}

class DataSearch extends SearchDelegate<BilleteDistribuidor> {
  final List<BilleteDistribuidor> lista;

  BilletesControllerG _billetesController = Get.put(BilletesControllerG());
  DataSearch({this.lista});

  _confirmarEliminar({BuildContext context, int id}) async {
    final isOk = await Dialogs.confirm(context,
        title: "ACCIÓN REQUERIDA", body: "Esta seguro de que desea eliminar?");
    print("isOk $isOk");
    if (isOk) {
      _billetesController.eliminar(id: id);
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
            .where(
                (p) => p.zona.zona.toLowerCase().contains(query.toLowerCase()))
            .toList();

    return myList.isEmpty
        ? EmptyState()
        : ListView.builder(
            itemCount: myList.length,
            itemBuilder: (context, index) {
              final BilleteDistribuidor billeteDistribuidor = myList[index];

              return ItemCard(
                billeteDistribuidor: billeteDistribuidor,
                onTapActualizar: () {
                  _billetesController.goToActualizar(
                      billete: billeteDistribuidor);
                  close(context, null);
                },
                onTapEliminar: () {
                  _confirmarEliminar(
                      context: context, id: billeteDistribuidor.id);
                },
              );
            },
          );
  }
}
