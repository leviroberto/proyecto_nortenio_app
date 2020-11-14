import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:proyect_nortenio_app/data/models/usuario.dart';
import 'package:proyect_nortenio_app/utils/colores.dart';
import 'package:proyect_nortenio_app/utils/utilidades.dart';

class ItemDistribuidorCard extends StatefulWidget {
  final Usuario distribuidor;
  final bool isSelected;

  final void Function() onTapActualizar;

  const ItemDistribuidorCard(
      {this.distribuidor, this.onTapActualizar, this.isSelected});
  @override
  _ItemDistribuidorCardState createState() => _ItemDistribuidorCardState();
}

class _ItemDistribuidorCardState extends State<ItemDistribuidorCard> {
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
                  Utilidades.generarLetras(
                      letra1: widget.distribuidor.apellidos,
                      letra2: widget.distribuidor.nombre),
                  style: TextStyle(
                      fontFamily: 'poppins',
                      color: widget.isSelected ? Colors.black38 : Colors.black),
                ),
              ),
            ),
            title: Text(
              widget.distribuidor.nombreCompleto,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14,
                color: widget.isSelected ? Colors.black38 : Colors.black,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            subtitle: Text(
              widget.distribuidor.correoElectronico,
              style: TextStyle(
                color: widget.isSelected ? Colors.black38 : Colors.black,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Text(
              widget.distribuidor.generarEstado(),
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: widget.distribuidor.generarEstadoColor(),
                fontSize: 12,
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
