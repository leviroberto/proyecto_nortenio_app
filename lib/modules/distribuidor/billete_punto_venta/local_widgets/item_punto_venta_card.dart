import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:proyect_nortenio_app/data/models/punto_venta.dart';
import 'package:proyect_nortenio_app/global_widgets/texto_item.dart';
import 'package:proyect_nortenio_app/utils/colores.dart';
import 'package:proyect_nortenio_app/utils/utilidades.dart';

class ItemPuntoVentaCard extends StatefulWidget {
  final PuntoVenta puntoVenta;
  final bool isSelected;

  final void Function() onTapActualizar, onTapEliminar;

  const ItemPuntoVentaCard(
      {this.puntoVenta,
      this.onTapActualizar,
      this.onTapEliminar,
      this.isSelected});
  @override
  _ItemPuntoVentaCardState createState() => _ItemPuntoVentaCardState();
}

class _ItemPuntoVentaCardState extends State<ItemPuntoVentaCard> {
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
                      letra1: widget.puntoVenta.razonSocial,
                      letra2: widget.puntoVenta.ruc),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colores.bodyColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            title: TextoItem(
              title: widget.puntoVenta.razonSocial,
              isTitulo: true,
              isSelected: widget.isSelected,
            ),
            subtitle: TextoItem(
              isSelected: widget.isSelected,
              title: widget.puntoVenta.propietario,
            ),
            trailing: Text(
              widget.puntoVenta.generarEstado(),
              style: TextStyle(
                color: widget.puntoVenta.generarEstadoColor(),
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
