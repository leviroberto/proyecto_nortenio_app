import 'package:flutter/material.dart';
import 'package:proyect_nortenio_app/utils/colores.dart';

class Reporte extends StatefulWidget {
  Reporte({Key key}) : super(key: key);

  @override
  _ReporteState createState() => _ReporteState();
}

class _ReporteState extends State<Reporte> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {},
              child: Column(
                children: [
                  Container(
                    height: 80,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colores.bodyColor,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 3,
                          blurRadius: 7,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colores.colorVerde),
                                child: Icon(
                                  Icons.arrow_upward,
                                  color: Colores.bodyColor,
                                ),
                              ),
                              Column(
                                children: [
                                  Text(
                                    "Ingresos",
                                    style: TextStyle(
                                      color: Colors.white,
                                      letterSpacing: 1,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "Semanales",
                                    style: TextStyle(),
                                  )
                                ],
                              ),
                              Text("S/ 50.00"),
                              Icon(
                                Icons.keyboard_arrow_right,
                                size: 40,
                                color: Colores.colorButton,
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: 80,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colores.bodyColor,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colores.colorVerde),
                                child: Icon(
                                  Icons.arrow_upward,
                                  color: Colores.bodyColor,
                                ),
                              ),
                              Column(
                                children: [
                                  Text(
                                    "Ingresos",
                                    /*style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'sans',
                                  letterSpacing: 1,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),*/
                                  ),
                                  Text("Mensuales")
                                ],
                              ),
                              Text("S/ 50.00"),
                              Icon(
                                Icons.keyboard_arrow_right,
                                size: 40,
                                color: Colores.colorButton,
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
