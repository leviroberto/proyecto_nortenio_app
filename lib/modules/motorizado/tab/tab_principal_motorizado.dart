import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:proyect_nortenio_app/modules/motorizado/tab/stats_grid.dart';
import 'package:proyect_nortenio_app/utils/colores.dart';
import 'package:proyect_nortenio_app/utils/mensaje.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'tab_principal_motorizado_controller.dart';
import 'widgets/notification_billete_motorizado.dart';

class TabPrincipalMotorizado extends StatefulWidget {
  @override
  _TabPrincipalMotorizadoState createState() => _TabPrincipalMotorizadoState();
}

class _TabPrincipalMotorizadoState extends State<TabPrincipalMotorizado>
    with AfterLayoutMixin {
  PrincipalMotorizadoController _principalMotorizadoController =
      Get.put(PrincipalMotorizadoController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colores.bodyColor,
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
                      int cantidad = _principalMotorizadoController
                          .getNotificacionesActivasCantidad();
                      return Text(
                        cantidad.toString(),
                        style: TextStyle(color: Colors.red, fontSize: 12),
                      );
                    }))
              ],
            ),
            onPressed: () {
              _principalMotorizadoController.ponerNotificacionesVisto();
              Get.to(NotificacionMotorizado());
            },
          ),
        ],
      ),
      body: CustomScrollView(
        physics: ClampingScrollPhysics(),
        slivers: <Widget>[
          _buildHeader(),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            sliver: SliverToBoxAdapter(
              child: StatsGrid(),
            ),
          ),
        ],
      ),
    );
  }

  SliverPadding _buildHeader() {
    return SliverPadding(
      padding: const EdgeInsets.all(20.0),
      sliver: SliverToBoxAdapter(
        child: Text(
          'Estadísticas',
          style: const TextStyle(
            color: Colores.colorNegro,
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    SharedPreferences _shared = await SharedPreferences.getInstance();
    await _principalMotorizadoController.setSharedPreferencia(_shared);
    await _principalMotorizadoController.getUser();
    await _principalMotorizadoController.getContadorPuntoVenta();
    await _principalMotorizadoController.getNotificacionesLocal();
  }
}
