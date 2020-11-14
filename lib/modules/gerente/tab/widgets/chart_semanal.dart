import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:proyect_nortenio_app/data/models/billete_distribuidor_.dart';
import 'package:proyect_nortenio_app/utils/colores.dart';
import 'package:proyect_nortenio_app/utils/utilidades.dart';

import 'detalle_zona.dart';

class ChartSemanal extends StatefulWidget {
  final BilleteDistribuidor billeteDistribuidor;
  const ChartSemanal({@required this.billeteDistribuidor});

  @override
  _ChartSemanalState createState() => _ChartSemanalState();
}

class _ChartSemanalState extends State<ChartSemanal> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(0),
            child: ListTile(
              onTap: () {
                Get.to(DetalleZona(
                    billeteDistribuidor: widget.billeteDistribuidor));
              },
              title: Text(
                "Zona " + widget.billeteDistribuidor.zona.zona,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'poppins',
                  fontSize: 16,
                  letterSpacing: 0,
                  color: Colores.colorNegro,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                widget.billeteDistribuidor.zona.distribuidor.nombreCompleto,
                overflow: TextOverflow.ellipsis,
              ),
              leading: Container(
                padding: EdgeInsets.all(0),
                height: 50.0,
                width: 50.0,
                decoration: BoxDecoration(
                  color: Utilidades.obtenerColorRandomSolo(),
                  borderRadius: BorderRadius.circular(100.0),
                ),
                child: Center(
                    child: Text(
                  Utilidades.generarLetras(
                      letra1: widget
                          .billeteDistribuidor.zona.distribuidor.apellidos,
                      letra2:
                          widget.billeteDistribuidor.zona.distribuidor.nombre),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                )),
              ),
              trailing: Text(
                widget.billeteDistribuidor.edicion.estado == 1
                    ? "Activo"
                    : "Terminado",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'poppins',
                  fontSize: 14,
                  letterSpacing: 1,
                  color: widget.billeteDistribuidor.edicion.estado == 1
                      ? Colors.green
                      : Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Text(
                      widget.billeteDistribuidor
                          .calcularTotalBoletos()
                          .toString(),
                      style: TextStyle(
                        fontFamily: 'poppins',
                        fontSize: 20,
                        color: Colores.colorTitulos,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Entregados",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'poppins',
                        fontSize: 12,
                        color: Colores.colorTitulos,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Text(
                      widget.billeteDistribuidor
                          .calcularCantidadExtraviado()
                          .toString(),
                      style: TextStyle(
                        fontFamily: 'poppins',
                        fontSize: 20,
                        color: Colores.colorTitulos,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Perdidos",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'poppins',
                        fontSize: 12,
                        color: Colores.colorTitulos,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Text(
                      widget.billeteDistribuidor
                          .calcularCantidadDevuelto()
                          .toString(),
                      style: TextStyle(
                        fontFamily: 'poppins',
                        fontSize: 20,
                        color: Colores.colorTitulos,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Devueltos",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'poppins',
                        fontSize: 12,
                        color: Colores.colorTitulos,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Text(
                      widget.billeteDistribuidor
                          .calcularCantidadVendido()
                          .toString(),
                      style: TextStyle(
                        fontFamily: 'poppins',
                        fontSize: 20,
                        color: Colores.colorTitulos,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Vendidos",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'poppins',
                        fontSize: 12,
                        color: Colores.colorTitulos,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
         
            ],
          )
        ],
      ),
    );
  }
}

List<FlSpot> getSports() {
  return [
    FlSpot(0, 0),
    FlSpot(1, 2),
    FlSpot(2, .5),
    FlSpot(3, .8),
    FlSpot(4, .2),
    FlSpot(5, 1.5),
  ];
}
