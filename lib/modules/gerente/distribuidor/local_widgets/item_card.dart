import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:proyect_nortenio_app/data/models/usuario.dart';
import 'package:proyect_nortenio_app/utils/colores.dart';
import 'package:proyect_nortenio_app/utils/utilidades.dart';

class ItemCard extends StatefulWidget {
  final Usuario distribuidor;

  final void Function() onTapActualizar, onTapEliminar;

  const ItemCard({this.distribuidor, this.onTapActualizar, this.onTapEliminar});
  @override
  _ItemCardState createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
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
                      letra1: widget.distribuidor.apellidos,
                      letra2: widget.distribuidor.nombre),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colores.bodyColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            title: Text(
              widget.distribuidor.nombreCompleto,
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
              widget.distribuidor.correoElectronico,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colores.colorSubTitulos,
                fontSize: 14,
                fontFamily: 'poppins',
                fontWeight: FontWeight.normal,
              ),
            ),
            trailing: Text(
              widget.distribuidor.generarEstado(),
              style: TextStyle(
                color: widget.distribuidor.generarEstadoColor(),
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
