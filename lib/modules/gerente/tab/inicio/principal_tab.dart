import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:proyect_nortenio_app/global_widgets/edicion_item.dart';
import 'package:proyect_nortenio_app/global_widgets/loading_widget.dart';
import 'package:proyect_nortenio_app/modules/gerente/tab/inicio/principal_controller.dart';
import 'package:proyect_nortenio_app/modules/gerente/tab/inicio/widgets/notification_billete_gerente.dart';
import 'package:proyect_nortenio_app/utils/colores.dart';
import 'package:proyect_nortenio_app/utils/responsive.dart';
import 'package:proyect_nortenio_app/utils/util.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrincipalTab extends StatefulWidget {
  @override
  _PrincipalTabState createState() => _PrincipalTabState();
}

class _PrincipalTabState extends State<PrincipalTab> with AfterLayoutMixin {
  RefreshController _refreshController;
  PrincipalGerenteControllerG _principalController = Get.find();
  @override
  void initState() {
    _refreshController = RefreshController(initialRefresh: false);
    super.initState();
  }

  void _onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));
    if (await _principalController.cargarDatosPrincipal()) {
      _refreshController.refreshCompleted();
    } else {
      _refreshController.refreshCompleted();
    }
  }

  void _onLoading() async {
    await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colores.colorBody,
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/pages/login/logo.svg',
            height: responsive.heightPercent(6),
          ),
          onPressed: () {},
        ),
        elevation: 0,
        title: Center(
          child: Text(
            "SMG Lottery",
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colores.bodyColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Stack(
              children: [
                Positioned(
                    child: Icon(
                  Icons.notifications,
                  color: Colors.white,
                )),
                Positioned(
                    right: 3,
                    child: Obx(() {
                      int cantidad = _principalController
                          .getNotificacionesActivasCantidad();
                      return Text(
                        cantidad.toString(),
                        style: TextStyle(color: Colors.red, fontSize: 12),
                      );
                    }))
              ],
            ),
            onPressed: () {
              _principalController.ponerNotificacionesVisto();
              Get.to(NotificacionGerente());
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: responsive.height * 0.48,
              decoration: BoxDecoration(
                color: Colores.colorBody,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
              ),
              padding: EdgeInsets.only(top: 25),
            ),
            Container(
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
                      body = Text("¡Error de carga! Haga clic en reintentar.");
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
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          left: responsive.widthPercent(1),
                          right: responsive.widthPercent(1),
                          top: responsive.heightPercent(1),
                        ),
                        child: Obx(
                          () => EdicionItem(
                            edicion: _principalController.edicionAciva.value,
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "ESTADÍSCTICAS",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 26,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: responsive.heightPercent(1.5)),
                      Padding(
                        padding: EdgeInsets.all(5),
                        child: Row(
                          children: <Widget>[
                            Obx(() {
                              return Expanded(
                                  child: _cargarDatos(
                                icon: Icons.ac_unit,
                                color: Colors.green,
                                title: "DISTRIBUIDORES",
                                value: Util.checkString(_principalController
                                    .totalDistribuidores.value),
                                subTitle: "TOTAL DE \nDISTRIBUIDORES",
                              ));
                            }),
                            SizedBox(width: 3),
                            Obx(() {
                              return Expanded(
                                  child: _cargarDatos(
                                icon: Icons.account_balance_wallet_outlined,
                                color: Colors.red,
                                title: "ZONAS",
                                value: Util.checkString(_principalController
                                    .totalDistribuidores.value),
                                subTitle: "TOTAL DE \nZONAS",
                              ));
                            }),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(5),
                        child: Row(
                          children: <Widget>[
                            Obx(() {
                              return Expanded(
                                  child: _cargarDatos(
                                icon: Icons.account_balance_wallet_outlined,
                                color: Colors.red,
                                title: "BILLETES",
                                value: Util.checkString(
                                    _principalController.totalBilletes.value),
                                subTitle: "TOTAL DE \nBILLETES",
                              ));
                            }),
                            SizedBox(width: 3),
                            Obx(() {
                              return Expanded(
                                  child: _cargarDatos(
                                icon: Icons.account_balance_wallet_outlined,
                                color: Colors.red,
                                title: "EDICIONES",
                                value: Util.checkString(
                                    _principalController.totalEdiciones.value),
                                subTitle: "TOTAL DE \nEDICIONES",
                              ));
                            }),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(5),
                        child: Expanded(
                          child: _puntosDeVenta(),
                        ),
                      ),
                      /*Obx(() {
                        return EdicionCard(
                          height: _height,
                          lista: _principalController.ediciones.value,
                        );
                      }),*/
                    ],
                  ),
                ),
              ),
            ),
            Obx(() => _principalController.cargando.value == true
                ? loading()
                : Container())
          ],
        ),
      ),
    );
  }

  Widget _puntosDeVenta() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
        border: Border.all(color: Colors.white),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(1, 1),
            spreadRadius: 1,
            blurRadius: 1,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.store,
                  color: Colores.colorBody,
                ),
                SizedBox(width: 10.0),
                Text(
                  "PUNTOS DE VENTA",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            SizedBox(height: 10.0),
            Text(
              "TOTAL PUNTOS DE VENTA",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Colors.black38,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            Obx(
              () => Text(
                _principalController.totalPuntoVenta.value,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colores.colorBody,
                  letterSpacing: 2,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cargarDatos(
      {IconData icon,
      Color color,
      String title = "",
      String value = "",
      String subTitle = ""}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
        border: Border.all(color: Colors.white),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(1, 1),
            spreadRadius: 1,
            blurRadius: 1,
          ),
        ],
      ),
      child: ListTile(
        title: Row(
          children: [
            Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                fontSize: 14,
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              subTitle,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.black38,
              ),
            ),
            SizedBox(
              height: 3,
            ),
            Center(
              child: Text(
                value,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    SharedPreferences _shared = await SharedPreferences.getInstance();
    await _principalController.setSharedPreferencia(_shared);
    await _principalController.cargarDatosPrincipal();
    await _principalController.getNotificacionesLocal();

    /*  if (await _principalController.cargarListaEdiciones()) {
      if (await _principalController.cargarListaZonas()) {}
    } else {} */
  }
}
