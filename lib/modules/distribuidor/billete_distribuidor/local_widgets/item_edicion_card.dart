import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:proyect_nortenio_app/data/models/edicion.dart';
import 'package:proyect_nortenio_app/global_widgets/texto_item.dart';
import 'package:proyect_nortenio_app/utils/colores.dart';
import 'package:proyect_nortenio_app/utils/utilidades.dart';

class ItemEdicionCard extends StatefulWidget {
  final Edicion edicion;

  final void Function() onTapActualizar;

  const ItemEdicionCard({this.edicion, this.onTapActualizar});
  @override
  _ItemEdicionCardState createState() => _ItemEdicionCardState();
}

class _ItemEdicionCardState extends State<ItemEdicionCard> {
  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: SlidableScrollActionPane(),
      actions: <Widget>[
        IconSlideAction(
          color: Colores.bodyColor,
          icon: Icons.next_plan,
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
                      letra1: widget.edicion.numero,
                      letra2: widget.edicion.descripcion),
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colores.bodyColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            title: TextoItem(
              title: "ED" + widget.edicion.numero,
              isTitulo: true,
            ),
            subtitle: TextoItem(title: widget.edicion.formarFecha()),
            trailing: Text(widget.edicion.formarEstado(),
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: widget.edicion.formarColor(),
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
