import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:proyect_nortenio_app/data/models/billete_punto_venta.dart';
import 'package:proyect_nortenio_app/utils/colores.dart';
import 'package:proyect_nortenio_app/utils/utilidades.dart';

class ItemOpcionesCard extends StatefulWidget {
  final BilletePuntoVenta billetePuntoVenta;
  final String title, subTitle;

  final void Function() onTapActualizar, onTapEliminar;

  const ItemOpcionesCard(
      {this.billetePuntoVenta,
      this.onTapActualizar,
      this.onTapEliminar,
      @required this.title,
      @required this.subTitle});
  @override
  _ItemOpcionesCardState createState() => _ItemOpcionesCardState();
}

class _ItemOpcionesCardState extends State<ItemOpcionesCard> {
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
                      letra1: widget.billetePuntoVenta.puntoVenta.razonSocial,
                      letra2: widget.billetePuntoVenta.puntoVenta.propietario),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colores.bodyColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            title: Text(
              widget.title,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'poppins',
                fontSize: 14,
                color: Colores.colorTitulos,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            subtitle: Text(
              widget.subTitle,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colores.colorSubTitulos,
                fontSize: 14,
                fontFamily: 'poppins',
                fontWeight: FontWeight.normal,
              ),
            ),
            trailing: Icon(Icons.motorcycle),
            isThreeLine: true,
            dense: true,
          ),
        ),
      ),
    );
  }
}
