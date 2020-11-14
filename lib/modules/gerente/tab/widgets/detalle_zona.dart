import 'package:flutter/material.dart';
import 'package:proyect_nortenio_app/data/models/billete_distribuidor_.dart';
import 'package:proyect_nortenio_app/data/models/billete_punto_venta.dart';
import 'package:proyect_nortenio_app/global_widgets/custom_app_bar.dart';
import 'package:proyect_nortenio_app/global_widgets/texto.dart';
import 'package:proyect_nortenio_app/utils/util.dart';

import 'item_detalle_card.dart';

class DetalleZona extends StatefulWidget {
  final BilleteDistribuidor billeteDistribuidor;

  const DetalleZona({Key key, this.billeteDistribuidor}) : super(key: key);
  @override
  _DetalleZonaState createState() => _DetalleZonaState();
}

class _DetalleZonaState extends State<DetalleZona> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Util.checkString(widget.billeteDistribuidor.zona.zona),
        haveSearch: false,
        onTapAtras: () {
          Navigator.pop(context);
        },
        onTapSearch: () {
          /*      openSearch(context); */
        },
      ),
      body: SafeArea(
          child: Stack(
        children: [
          Container(
              width: double.infinity,
              height: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ListTile(
                        title: Texto(title: "Cantidad vendida"),
                        trailing: Texto(
                            title: widget.billeteDistribuidor
                                .calcularCantidadVendido())),
                    ListTile(
                        title: Texto(title: "Cantidad devuelto"),
                        trailing: Texto(
                            title: widget.billeteDistribuidor
                                .calcularCantidadDevuelto())),
                    ListTile(
                        title: Texto(title: "Porcentaje descuento"),
                        trailing: Texto(
                            title: widget
                                .billeteDistribuidor.porcentajeDescuento)),
                    ListTile(
                        title: Texto(title: "Precio billete"),
                        trailing: Texto(
                            title: widget.billeteDistribuidor.precioBillete)),
                    ListTile(
                        title: Texto(title: "Cantidad extraviada"),
                        trailing: Texto(
                            title: widget.billeteDistribuidor
                                .calcularCantidadExtraviado())),
                    ListTile(
                        title: Texto(title: "Monto vendido"),
                        trailing: Texto(
                            title: "S/. " +
                                widget.billeteDistribuidor
                                    .calcularMontoVendido())),
                    ListTile(
                        title: Texto(title: "Monto extraviado"),
                        trailing: Texto(
                            title: "S/. " +
                                widget.billeteDistribuidor
                                    .calcularMontoExtraviado())),
                    ListTile(
                        title: Texto(title: "Monto pagado porcentaje"),
                        trailing: Texto(
                            title: "S/. " +
                                widget.billeteDistribuidor
                                    .calcularMontoPorcentaje())),
                    ListTile(
                        title: Texto(title: "Monto pagado"),
                        trailing: Texto(
                            title: "S/. " +
                                widget.billeteDistribuidor
                                    .calcularMontoPagado())),
                    ListTile(
                      title: Text("Puntos de ventas"),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.green,
                          size: 40,
                        ),
                        onPressed: () {
                          mostrarCarritoPromocion(
                            context: context,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              )),
        ],
      )),
    );
  }

  Future mostrarCarritoPromocion({BuildContext context}) async {
    dynamic lista = widget.billeteDistribuidor.listaBilletePuntoVenta;
    bool estado =
        await showModalBilletePuntoVenta(context: context, lista: lista);

    if (estado != null && estado == true) {}
  }

  Future<bool> showModalBilletePuntoVenta(
      {BuildContext context, List<BilletePuntoVenta> lista}) async {
    bool estado = false;
    bool respnse = await showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Container(
            color: Colors.white,
            child: ListView.builder(
              itemCount: lista.length,
              itemBuilder: (context, index) {
                BilletePuntoVenta billetePuntoVenta = lista[index];
                return ItemDetalleCard(billetePuntoVenta: billetePuntoVenta);
              },
            ),
          );
        });

    if (respnse != null) {
      print("hola");
    }
    return estado;
  }
}
