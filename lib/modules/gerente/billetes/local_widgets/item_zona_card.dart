import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:proyect_nortenio_app/data/models/zona.dart';
import 'package:proyect_nortenio_app/global_widgets/texto_item.dart';
import 'package:proyect_nortenio_app/utils/colores.dart';
import 'package:proyect_nortenio_app/utils/utilidades.dart';

class ItemZonaCard extends StatefulWidget {
  final Zona zona;
  final bool isSelected;

  final void Function() onTapActualizar;

  const ItemZonaCard({this.zona, this.onTapActualizar, this.isSelected});
  @override
  _ItemZonaCardState createState() => _ItemZonaCardState();
}

class _ItemZonaCardState extends State<ItemZonaCard> {
  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: SlidableScrollActionPane(),
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
                      letra1: widget.zona.zona,
                      letra2: widget.zona.descripcion),
                  style: TextStyle(
                    fontSize: 14,
                    color: widget.isSelected ? Colors.black38 : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            title: TextoItem(
              title: widget.zona.zona,
              isTitulo: true,
              isSelected: widget.isSelected,
            ),
            subtitle: TextoItem(
              title: widget.zona.descripcion,
              isSelected: widget.isSelected,
            ),
            trailing: Text(widget.zona.generarEstado(),
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: widget.zona.generarEstadoColor(),
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
