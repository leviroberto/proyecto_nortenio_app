import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:proyect_nortenio_app/data/models/punto_venta.dart';
import 'package:proyect_nortenio_app/global_widgets/loading_widget.dart';
import 'package:proyect_nortenio_app/utils/colores.dart';
import 'package:proyect_nortenio_app/utils/dialogs.dart';
import 'package:proyect_nortenio_app/utils/letra.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'punto_venta_controller.dart';

class PuntoVentaPage extends StatefulWidget {
  @override
  _PuntoVentaPageState createState() => _PuntoVentaPageState();
}

class _PuntoVentaPageState extends State<PuntoVentaPage> with AfterLayoutMixin {
  RefreshController _refreshController;
  PuntoVentaControllerM _puntoVentaController = Get.find();

  @override
  void initState() {
    _refreshController = RefreshController(initialRefresh: false);
    super.initState();
  }

  void _onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));

    bool response = await _puntoVentaController.cargarLista();
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
              color: Colores.textosColorGris,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        elevation: 1,
        backgroundColor: Colores.bodyColor,
        title: Center(
          child: Text(
            "Puntos de ventas",
            style: TextStyle(
              color: Colores.colorTitulos,
              fontFamily: 'poppins',
              fontSize: 18,
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
                    if (_puntoVentaController.listaPuntoVentas.length > 0) {
                      return SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Column(
                            children:
                                recorrerDistribuidores(_puntoVentaController),
                          ),
                        ),
                      );
                    }
                    return Center(
                      child: Text("No hay puntos de ventas"),
                    );
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

  List<Widget> recorrerDistribuidores(PuntoVentaControllerM state) {
    List<Widget> listaWidget = new List<Widget>();

    for (int i = 0; i < state.listaPuntoVentas.length; i++) {
      PuntoVenta zona = state.listaPuntoVentas[i];
      listaWidget.add(listaItem(zona));
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

  Widget listaItem(PuntoVenta puntoVenta) {
    return Slidable(
      actionPane: SlidableScrollActionPane(),
      actions: <Widget>[
        IconSlideAction(
            caption: 'Actualizar',
            color: Colores.colorButton,
            icon: Icons.settings_backup_restore,
            onTap: () =>
                _puntoVentaController.goToActualizar(puntoVenta: puntoVenta)),
      ],
      secondaryActions: <Widget>[
        IconSlideAction(
          color: Colors.redAccent,
          icon: Icons.delete,
          onTap: () {
            _confirmarEliminar(context: context, id: puntoVenta.id);
          },
        ),
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
              _puntoVentaController.goToActualizar(puntoVenta: puntoVenta);
            },
            leading: Icon(Icons.location_city),
            title: Text(
              puntoVenta.propietario,
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
                    text: puntoVenta.celular,
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
  void afterFirstLayout(BuildContext context) async {
    if (await _puntoVentaController.obtenerZonaPorDistribuidor()) {
      _puntoVentaController.cargarLista();
    }
  }
}
