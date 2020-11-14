import 'package:flutter/material.dart';
import 'package:proyect_nortenio_app/utils/colores.dart';

import 'menu_superior.dart';

class DetalleIngresosMes extends StatefulWidget {
  DetalleIngresosMes({Key key}) : super(key: key);

  @override
  _DetalleIngresosMesState createState() => _DetalleIngresosMesState();
}

class _DetalleIngresosMesState extends State<DetalleIngresosMes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[MenuSuperiorMeses()],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: DefaultTabController(
                    length: 2,
                    child: Column(
                      children: [
                        Container(
                          constraints: BoxConstraints.expand(height: 50),
                          child: TabBar(tabs: [
                            Tab(text: "Ingresos"),
                            Tab(text: "Estadísticas"),
                          ]),
                        ),
                        Expanded(
                          child: Container(
                            child: TabBarView(
                              children: [
                                Container(
                                  child: Text("Ingresos"),
                                ),
                                Container(
                                  child: Text("Estadísticas"),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
