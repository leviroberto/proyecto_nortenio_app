import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:proyect_nortenio_app/modules/motorizado/tab/tab_principal_motorizado_controller.dart';
import 'package:proyect_nortenio_app/utils/util.dart';

class StatsGrid extends StatefulWidget {
  @override
  _StatsGridState createState() => _StatsGridState();
}

class _StatsGridState extends State<StatsGrid> {
  PrincipalMotorizadoController _principalMotorizadoController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.25,
      child: Column(
        children: <Widget>[
          Flexible(
            child: Row(
              children: <Widget>[
                Obx(() => _buildStatCard(
                    Util.checkString(_principalMotorizadoController
                        .usuario.value.nombreCompleto),
                    'Motorizado',
                    Colors.red)),
              ],
            ),
          ),
          Flexible(
            child: Row(
              children: <Widget>[
                Obx(() => _buildStatCard(
                    'Puntos venta',
                    Util.checkString(_principalMotorizadoController
                        .contadorPuntoVentas.value),
                    Colors.red)),
                Obx(() => _buildStatCard(
                    'Zona',
                    Util.checkString(
                        _principalMotorizadoController.zona.value.zona),
                    Colors.lightBlue)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Expanded _buildStatCard(String title, String count, MaterialColor color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              count,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
