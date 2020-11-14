import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:proyect_nortenio_app/data/models/billete_distribuidor_.dart';
import 'package:proyect_nortenio_app/data/models/edicion.dart';
import 'package:proyect_nortenio_app/global_widgets/loading_widget.dart';
import 'package:proyect_nortenio_app/utils/colores.dart';
import 'package:proyect_nortenio_app/utils/letra.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'billete_distribuidor_controller.dart';

class BilleteDistribuidorEdicion extends StatefulWidget {
  final Edicion edicion;

  const BilleteDistribuidorEdicion({Key key, this.edicion}) : super(key: key);
  @override
  _BilleteDistribuidorEdicionState createState() =>
      _BilleteDistribuidorEdicionState();
}

class _BilleteDistribuidorEdicionState extends State<BilleteDistribuidorEdicion>
    with AfterLayoutMixin {
  RefreshController _refreshController;
  BilleteControllerD _billetesController;

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
    }
  }

  void _onLoading() async {
    await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    _billetesController = Get.put(BilleteControllerD());
    return Scaffold(
      backgroundColor: Colores.bodyColor,
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colores.textosColorGris,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        elevation: 1,
        backgroundColor: Colores.bodyColor,
        title: Center(
          child: Text(
            "Billetes por zonas",
            style: TextStyle(
              color: Colores.colorTitulos,
              fontFamily: 'poppins',
              fontSize: 16,
              letterSpacing: 1,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
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
                    if (_billetesController.listaEdiciones.length > 0) {
                      return SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Column(
                            children:
                                recorrerDistribuidores(_billetesController),
                          ),
                        ),
                      );
                    }
                    return Center(
                      child: Text("No hay billetes"),
                    );
                  })),
            ),
            Obx(() => _billetesController.cargando.value == true
                ? loading()
                : Container())
          ],
        ),
      ),
    );
  }

  List<Widget> recorrerDistribuidores(BilleteControllerD state) {
    List<Widget> listaWidget = new List<Widget>();

    for (int i = 0; i < state.listaBilleteDistribuidor.length; i++) {
      BilleteDistribuidor billeteDistribuidor =
          state.listaBilleteDistribuidor[i];
      listaWidget.add(listaItem(billeteDistribuidor));
    }

    return listaWidget;
  }

  Widget listaItem(BilleteDistribuidor billeteDistribuidor) {
    return Slidable(
      actionPane: SlidableScrollActionPane(),
      actions: <Widget>[
        IconSlideAction(
            caption: 'Billetes',
            color: Colores.colorButton,
            icon: Icons.settings_backup_restore,
            onTap: () {
              _billetesController.goToActualizar(
                  billeteDistribuidor: billeteDistribuidor);
            }),
      ],
      child: GestureDetector(
        onTap: () {},
        child: Card(
          margin: EdgeInsets.all(2.0),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          child: ListTile(
            onTap: () {
              _billetesController.goToActualizar(
                  billeteDistribuidor: billeteDistribuidor);
            },
            leading: Icon(Icons.location_city),
            title: Text(
              billeteDistribuidor.zona.zona,
              style: TextStyle(
                fontFamily: 'poppins',
                fontSize: Letra.letrChica,
                color: Colores.colorNegro,
                fontWeight: FontWeight.w500,
                letterSpacing: 1,
              ),
            ),
            subtitle: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: billeteDistribuidor.estado == 1
                        ? "Activo"
                        : "Terminado",
                    style: TextStyle(
                      color: Colores.colorNegro,
                      fontSize: Letra.letrChica,
                      fontFamily: 'poppins',
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            isThreeLine: true,
            dense: true,
          ),
        ),
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    _billetesController.cargarListaBilletesDistribuidorPorEdicion(
        edicion: widget.edicion);
  }
}
