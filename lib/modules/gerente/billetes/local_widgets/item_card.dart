import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:proyect_nortenio_app/data/models/billete_distribuidor_.dart';
import 'package:proyect_nortenio_app/global_widgets/texto_item.dart';
import 'package:proyect_nortenio_app/utils/colores.dart';
import 'package:proyect_nortenio_app/utils/utilidades.dart';

class ItemCard extends StatefulWidget {
  final BilleteDistribuidor billeteDistribuidor;

  final void Function() onTapActualizar, onTapEliminar;

  const ItemCard(
      {this.billeteDistribuidor, this.onTapActualizar, this.onTapEliminar});
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
                      letra1: widget.billeteDistribuidor.zona.zona,
                      letra2: widget.billeteDistribuidor.edicion.descripcion),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colores.bodyColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            title: TextoItem(
                title: widget.billeteDistribuidor.zona.zona, isTitulo: true),
            subtitle: TextoItem(
                title: widget.billeteDistribuidor.generarTitutloBilletes()),
            trailing: Text(widget.billeteDistribuidor.generarEstado(),
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: widget.billeteDistribuidor.generarEstadoColor(),
                  fontWeight: FontWeight.normal,
                )),
            isThreeLine: true,
            dense: true,
          ),
        ),
      ),
    );
  }
}
