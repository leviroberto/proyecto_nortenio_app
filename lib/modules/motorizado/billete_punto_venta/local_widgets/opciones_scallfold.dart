import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:proyect_nortenio_app/data/models/billete_punto_venta.dart';
import 'package:proyect_nortenio_app/global_widgets/loading_widget.dart';
import 'package:proyect_nortenio_app/utils/colores.dart';

import '../billete_punto_venta_controller.dart';
import 'item_opciones_card.dart';

class OpcionesScallfold extends StatefulWidget {
  final BilletePuntoVenta billetePuntoVenta;

  const OpcionesScallfold({Key key, this.billetePuntoVenta}) : super(key: key);
  @override
  _OpcionesScallfoldState createState() => _OpcionesScallfoldState();
}

class _OpcionesScallfoldState extends State<OpcionesScallfold> {
  BilletePuntoVentaControllerM _billetePuntoVentaController = Get.find();
  @override
  void initState() {
    _billetePuntoVentaController.cargando.value = false;
    _billetePuntoVentaController.setBilletePuntoVenta(
        billetePuntoVenta: widget.billetePuntoVenta);
    super.initState();
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
        elevation: 2,
        backgroundColor: Colores.colorBody,
        title: Center(
          child: Text(
            "Ediciones",
            style: TextStyle(
              color: Colores.bodyColor,
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
              child: Column(
                children: [
                  ItemOpcionesCard(
                    title: "Entregar billete",
                    subTitle: "Opción para entrega de billete",
                    billetePuntoVenta: _billetePuntoVentaController
                        .billetePuntoVentaEditar.value,
                    onTapActualizar: () {
                      _billetePuntoVentaController.goToEntregarBillete(
                          billetePuntoVenta: _billetePuntoVentaController
                              .billetePuntoVentaEditar.value);
                    },
                  ),
                  Obx(() {
                    if (_billetePuntoVentaController
                        .billetePuntoVentaEditar.value
                        .estaBilleteEntregado()) {
                      return ItemOpcionesCard(
                        title: "Recoger billete",
                        subTitle: "Opción para recoger billete",
                        billetePuntoVenta: _billetePuntoVentaController
                            .billetePuntoVentaEditar.value,
                        onTapActualizar: () {
                          _billetePuntoVentaController.goToRecogerBillete(
                              billetePuntoVenta: _billetePuntoVentaController
                                  .billetePuntoVentaEditar.value);
                        },
                      );
                    } else {
                      return Container();
                    }
                  })
                ],
              ),
            ),
            Obx(() => _billetePuntoVentaController.cargando.value == true
                ? loading()
                : Container())
          ],
        ),
      ),
    );
  }
}
