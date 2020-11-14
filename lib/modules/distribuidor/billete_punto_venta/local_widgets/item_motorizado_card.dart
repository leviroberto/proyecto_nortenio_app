import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:proyect_nortenio_app/data/models/zonaMotorizado.dart';
import 'package:proyect_nortenio_app/global_widgets/texto_item.dart';
import 'package:proyect_nortenio_app/utils/colores.dart';
import 'package:proyect_nortenio_app/utils/utilidades.dart';

class ItemMotorizadoCard extends StatefulWidget {
  final ZonaMotorizado zonaMotorizado;
  final bool isSelected;

  final void Function() onTapActualizar, onTapEliminar;

  const ItemMotorizadoCard(
      {this.zonaMotorizado,
      this.onTapActualizar,
      this.onTapEliminar,
      this.isSelected});
  @override
  _ItemMotorizadoCardState createState() => _ItemMotorizadoCardState();
}

class _ItemMotorizadoCardState extends State<ItemMotorizadoCard> {
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
                      letra1: widget.zonaMotorizado.motorizado.apellidos,
                      letra2: widget.zonaMotorizado.motorizado.nombre),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colores.bodyColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            title: TextoItem(
              title: widget.zonaMotorizado.motorizado.nombreCompleto,
              isTitulo: true,
              isSelected: widget.isSelected,
            ),
            subtitle: TextoItem(
              isSelected: widget.isSelected,
              title: widget.zonaMotorizado.motorizado.correoElectronico,
            ),
            trailing: Text(
              widget.zonaMotorizado.generarEstado(),
              style: TextStyle(
                color: widget.zonaMotorizado.generarEstadoColor(),
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
