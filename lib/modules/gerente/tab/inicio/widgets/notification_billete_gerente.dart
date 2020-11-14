import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:proyect_nortenio_app/data/models/notificacion.dart';
import 'package:proyect_nortenio_app/global_widgets/empty_state.dart';
import 'package:proyect_nortenio_app/global_widgets/item_notificacion_card.dart';
import 'package:proyect_nortenio_app/global_widgets/loading_widget.dart';
import 'package:proyect_nortenio_app/utils/colores.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../principal_controller.dart';

class NotificacionGerente extends StatefulWidget {
  @override
  _NotificacionGerenteState createState() => _NotificacionGerenteState();
}

class _NotificacionGerenteState extends State<NotificacionGerente> {
  RefreshController _refreshController;
  PrincipalGerenteControllerG _principalGerenteControllerG = Get.find();
  @override
  void initState() {
    _refreshController = RefreshController(initialRefresh: false);
    super.initState();
  }

  void _onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));

    /* bool response = await _billetesController.getEdicionesApi();
    if (response) {
      _refreshController.refreshCompleted();
    } else {
      _billetesController.getEdicionesLocal();
      _refreshController.refreshCompleted();
    } */
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
              color: Colores.bodyColor,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        elevation: 1,
        backgroundColor: Colores.colorBody,
        title: Text(
          "Notificaciones",
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colores.bodyColor,
            fontWeight: FontWeight.bold,
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
                    if (_principalGerenteControllerG
                            .listaNotificaciones.length >
                        0) {
                      return SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Column(
                            children: recorrerDistribuidores(),
                          ),
                        ),
                      );
                    }
                    return EmptyState();
                  })),
            ),
            Obx(() => _principalGerenteControllerG.cargando.value == true
                ? loading()
                : Container())
          ],
        ),
      ),
    );
  }

  List<Widget> recorrerDistribuidores() {
    List<Widget> listaWidget = new List<Widget>();

    for (int i = 0;
        i < _principalGerenteControllerG.listaNotificaciones.value.length;
        i++) {
      Notificacion notificacion =
          _principalGerenteControllerG.listaNotificaciones[i];
      listaWidget.add(NotificacionCard(
        notificacion: notificacion,
        onTapActualizar: () {},
      ));
    }

    return listaWidget;
  }
}
