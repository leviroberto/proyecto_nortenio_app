import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:proyect_nortenio_app/data/models/billete_punto_venta.dart';
import 'package:proyect_nortenio_app/global_widgets/detalle_item.dart';
import 'package:proyect_nortenio_app/global_widgets/texto_item.dart';
import 'package:proyect_nortenio_app/utils/colores.dart';
import 'package:proyect_nortenio_app/utils/utilidades.dart';

class ItemDetalleCard extends StatefulWidget {
  final BilletePuntoVenta billetePuntoVenta;

  final void Function() onTapActualizar, onTapEliminar;

  const ItemDetalleCard(
      {@required this.billetePuntoVenta,
      this.onTapActualizar,
      this.onTapEliminar});
  @override
  _ItemDetalleCardState createState() => _ItemDetalleCardState();
}

class _ItemDetalleCardState extends State<ItemDetalleCard> {
  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: SlidableScrollActionPane(),
      actions: <Widget>[
        IconSlideAction(
          color: Colores.bodyColor,
          icon: Icons.settings_backup_restore,
          foregroundColor: Colores.colorBody,
          onTap: () {
            widget.onTapActualizar();
          },
        ),
      ],
      secondaryActions: <Widget>[
        IconSlideAction(
          color: Colores.bodyColor,
          icon: Icons.delete,
          foregroundColor: Colores.colorRojo,
          onTap: () {
            widget.onTapEliminar();
          },
        ),
      ],
      child: GestureDetector(
        onTap: () {},
        child: Card(
          margin: EdgeInsets.only(bottom: 6.0),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: ListTile(
            onTap: () {
              widget.onTapActualizar();
            },
            leading: Container(
              height: 30.0,
              width: 30.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colores.colorBody,
              ),
              child: Center(
                child: Text(
                  Utilidades.generarIcono(
                      letra1: widget.billetePuntoVenta.puntoVenta.razonSocial,
                      letra2: widget.billetePuntoVenta.puntoVenta.ruc),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colores.bodyColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            title: TextoItem(
              title: widget.billetePuntoVenta.puntoVenta.razonSocial,
              isTitulo: true,
            ),
            subtitle: Column(
              children: [
                DetalleItem(
                  textoDerecha:
                      "U/. ${widget.billetePuntoVenta.cantidadVendida}",
                  textoIzquierda: "Cantidad vendido",
                ),
                DetalleItem(
                  textoDerecha:
                      "U/. ${widget.billetePuntoVenta.cantidadDevuelto}",
                  textoIzquierda: "Cantidad devuelto",
                ),
                DetalleItem(
                  textoDerecha:
                      "%. ${widget.billetePuntoVenta.porcentajeDescuento}",
                  textoIzquierda: "Porcentaje descuento",
                ),
                DetalleItem(
                  textoDerecha: "S/. ${widget.billetePuntoVenta.precioBillete}",
                  textoIzquierda: "Precio por billete",
                ),
                DetalleItem(
                  textoDerecha:
                      "U/. ${widget.billetePuntoVenta.calcularTotalExtraviado()}",
                  textoIzquierda: "Cantidad extraviada",
                ),
                DetalleItem(
                  textoDerecha:
                      "S/. ${widget.billetePuntoVenta.calcularMontoVendido()}",
                  textoIzquierda: "Monto vendido",
                ),
                DetalleItem(
                  textoDerecha:
                      "S/. ${widget.billetePuntoVenta.calcularMontoExtraviado()}",
                  textoIzquierda: "Monto extraviado",
                ),
                DetalleItem(
                  textoDerecha:
                      "S/. ${widget.billetePuntoVenta.calcularMontoPorcentaje()}",
                  textoIzquierda: "Monto Porcentaje",
                ),
                DetalleItem(
                  textoDerecha:
                      "S/. ${widget.billetePuntoVenta.calcularMontoPagado()}",
                  textoIzquierda: "Monto Pagado",
                ),
              ],
            ),
            trailing: Text(
              widget.billetePuntoVenta.generarEstado(),
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: widget.billetePuntoVenta.generarEstadoColor(),
                fontSize: 12,
                fontFamily: 'poppins',
                fontWeight: FontWeight.normal,
              ),
            ),
            isThreeLine: true,
            dense: true,
          ),
        ),
      ),
    );
  }
}
