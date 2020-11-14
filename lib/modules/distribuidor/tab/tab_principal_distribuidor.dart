import 'dart:ui';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:proyect_nortenio_app/data/models/edicion.dart';
import 'package:proyect_nortenio_app/global_widgets/loading_widget.dart';
import 'package:proyect_nortenio_app/modules/distribuidor/billete_punto_venta/billete_punto_venta_controller.dart';
import 'package:proyect_nortenio_app/modules/distribuidor/motirizado/motirizado_page.dart';
import 'package:proyect_nortenio_app/modules/distribuidor/punto_venta/punto_venta_page.dart';
import 'package:proyect_nortenio_app/utils/colores.dart';
import 'package:proyect_nortenio_app/utils/mensaje.dart';
import 'package:proyect_nortenio_app/utils/responsive.dart';
import 'package:proyect_nortenio_app/utils/util.dart';
import 'package:proyect_nortenio_app/utils/utilidades.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shape_of_view/shape_of_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'tab_principal_distribuidor_controller.dart';
import 'widgets/notification_billete_distribuidor.dart';

class PrincipalDistribuidorTab extends StatefulWidget {
  PrincipalDistribuidorTab({Key key}) : super(key: key);

  @override
  _PrincipalDistribuidorTabState createState() =>
      _PrincipalDistribuidorTabState();
}

class _PrincipalDistribuidorTabState extends State<PrincipalDistribuidorTab>
    with AfterLayoutMixin {
  PrincipalDistribuidorControllerD _principalDistribuidorController =
      Get.find();

  BilletePuntoVentaControllerD _billetePuntoVentaController = Get.find();

  RefreshController _refreshController;
  @override
  void initState() {
    _refreshController = RefreshController(initialRefresh: false);
    super.initState();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  void _onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));

    if (await _principalDistribuidorController.getDatosPrincipalApi()) {
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
    Responsive responsive = Responsive.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colores.colorBody,
        elevation: 0,
        leading: Container(),
        title: Center(
          child: Text(
            Mensaje.nomre_empresa,
            style: TextStyle(
              fontSize: 20,
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
                      int cantidad = _principalDistribuidorController
                          .getNotificacionesActivasCantidad();
                      return Text(
                        cantidad.toString(),
                        style: TextStyle(color: Colors.red, fontSize: 12),
                      );
                    }))
              ],
            ),
            onPressed: () {
              _principalDistribuidorController.ponerNotificacionesVisto();
              Get.to(NotificacionDistribuidor());
            },
          ),
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
                    child: Stack(
                      children: [
                        ShapeOfView(
                          shape: ArcShape(
                            direction: ArcDirection.Outside,
                            height: 20,
                            position: ArcPosition.Bottom,
                          ),
                          child: Container(
                            height: 300,
                            width: double.infinity,
                            color: Colores.bodyColor,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 0, left: 10, right: 10),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              children: [
                                Wrap(
                                  runSpacing: responsive.widthPercent(4),
                                  spacing: responsive.widthPercent(4),
                                  children: [
                                    Text(
                                      "Estadísticas",
                                      style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1,
                                        color: Colores.colorTitulos,
                                      ),
                                    ),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(25),
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(
                                            sigmaX: 12, sigmaY: 12),
                                        child: GestureDetector(
                                          onTap: () {
                                            Get.to(MotirizadoPage());
                                          },
                                          child: Container(
                                            height: 160,
                                            width: 160,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                              color: Colores.colorDashboard
                                                  .withOpacity(0.7),
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Icon(
                                                  FontAwesomeIcons.motorcycle,
                                                  size: 50,
                                                  color: Colores.bodyColor,
                                                ),
                                                SizedBox(
                                                  height: responsive
                                                      .heightPercent(3),
                                                ),
                                                Obx(() => Text(
                                                      Util.checkString(
                                                          _principalDistribuidorController
                                                              .totalMotorizados
                                                              .value),
                                                      style: TextStyle(
                                                        fontSize: 30,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Colores.bodyColor,
                                                      ),
                                                    )),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(25),
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(
                                            sigmaX: 12, sigmaY: 12),
                                        child: GestureDetector(
                                          onTap: () {
                                            Get.to(PuntoVentaPage());
                                          },
                                          child: Container(
                                            height: 160,
                                            width: 160,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                              color: Colores.colorRojo
                                                  .withOpacity(0.7),
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Icon(
                                                  Icons.store,
                                                  size: 50,
                                                  color: Colores.bodyColor,
                                                ),
                                                SizedBox(
                                                  height: responsive
                                                      .heightPercent(3),
                                                ),
                                                Obx(() => Text(
                                                      Util.checkString(
                                                          _principalDistribuidorController
                                                              .totalPuntoVenta
                                                              .value),
                                                      style: TextStyle(
                                                        fontSize: 30,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Colores.bodyColor,
                                                      ),
                                                    ))
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    ListTile(
                                      leading: Column(
                                        children: [
                                          Text("Día"),
                                          Text(
                                            Util.getDia(),
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.normal,
                                              color: Colores.colorNegro,
                                            ),
                                          ),
                                        ],
                                      ),
                                      title: Column(
                                        children: [
                                          Text("Mes"),
                                          Text(
                                            Util.getMes(),
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.normal,
                                              color: Colores.colorNegro,
                                            ),
                                          ),
                                        ],
                                      ),
                                      trailing: Column(
                                        children: [
                                          Text("Año"),
                                          Text(
                                            Util.getAnio(),
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.normal,
                                              color: Colores.colorNegro,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      child: Text(
                                        "Ediciones",
                                        style: TextStyle(
                                          color: Colores.colorTitulos,
                                          letterSpacing: 1,
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(0.0),
                                      child: Container(
                                        width: double.infinity,
                                        height: 250,
                                        child: Obx(() => ListView.builder(
                                              itemCount:
                                                  _principalDistribuidorController
                                                      .listaEdiciones.length,
                                              scrollDirection: Axis.horizontal,
                                              physics: BouncingScrollPhysics(),
                                              itemBuilder: (context, index) {
                                                Color color = Utilidades
                                                    .obtenerColorRandomSolo();
                                                Edicion edicion =
                                                    _principalDistribuidorController
                                                        .listaEdiciones[index];
                                                return GestureDetector(
                                                  onTap: () {
                                                    _billetePuntoVentaController
                                                        .goToBilletesPorPuntoVenta(
                                                            edicion: edicion);
                                                  },
                                                  child: Container(
                                                    width: 160,
                                                    margin: EdgeInsets.only(
                                                        right: 16.0),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: edicion
                                                                .estaActivador()
                                                            ? Colores.colorBody
                                                            : Colores
                                                                .colorTitulos,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                          Radius.circular(20),
                                                        ),
                                                      ),
                                                      child: Stack(
                                                        alignment:
                                                            Alignment.topCenter,
                                                        children: [
                                                          Positioned(
                                                            top: 8,
                                                            child: Container(
                                                              width: 80,
                                                              height: 80,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colores
                                                                    .colorCircleIcon
                                                                    .withOpacity(
                                                                        0.4),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          100),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          100),
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          100),
                                                                  bottomRight: Radius
                                                                      .circular(
                                                                          100),
                                                                ),
                                                              ),
                                                              child: Center(
                                                                  child: Text(
                                                                "ED${edicion.numero}",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 24,
                                                                  color: Colores
                                                                      .bodyColor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              )),
                                                            ),
                                                          ),
                                                          Center(
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  "Fecha Inicio",
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colores
                                                                        .textBottonColor,
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    letterSpacing:
                                                                        1,
                                                                  ),
                                                                ),
                                                                Container(
                                                                  child: Text(
                                                                    edicion
                                                                        .fechaInicio,
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colores
                                                                          .textBottonColor,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      letterSpacing:
                                                                          1,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Positioned(
                                                            bottom: 34,
                                                            child: Container(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(2),
                                                              height: responsive
                                                                  .heightPercent(
                                                                      6),
                                                              width: responsive
                                                                  .widthPercent(
                                                                      36),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colores
                                                                    .colorAdvertencia,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .all(
                                                                  Radius
                                                                      .circular(
                                                                          80),
                                                                ),
                                                              ),
                                                              child: Column(
                                                                children: [
                                                                  Text(
                                                                    "Fecha Fin",
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colores
                                                                          .textBottonColor,
                                                                      fontSize:
                                                                          10,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    edicion
                                                                        .fechaFin,
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colores
                                                                          .textBottonColor,
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            )),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ))),
            Obx(() => _principalDistribuidorController.cargando.value == true
                ? loading()
                : Container()),
          ],
        ),
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    SharedPreferences _shared = await SharedPreferences.getInstance();
    await _principalDistribuidorController.setSharedPreferencia(_shared);
    await _principalDistribuidorController.getDatosPrincipalApi();
    await _principalDistribuidorController.getNotificacionesLocal();
  }
}
