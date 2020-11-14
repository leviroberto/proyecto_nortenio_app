import 'package:flutter/material.dart';
import 'package:proyect_nortenio_app/global_widgets/texto_item.dart';
import 'package:proyect_nortenio_app/utils/colores.dart';
import 'package:proyect_nortenio_app/utils/utilidades.dart';

class ItemDepartamentoCard extends StatefulWidget {
  final String title, subTitle;
  final bool isSelected;

  final void Function() onTapActualizar;

  const ItemDepartamentoCard({
    this.onTapActualizar,
    this.title,
    this.subTitle,
    this.isSelected,
  });
  @override
  _ItemDepartamentoCardState createState() => _ItemDepartamentoCardState();
}

class _ItemDepartamentoCardState extends State<ItemDepartamentoCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
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
                  letra1: widget.title, letra2: widget.subTitle),
              style: TextStyle(
                fontSize: 14,
                color: Colores.bodyColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        title: TextoItem(
          title: widget.title,
          isTitulo: true,
          isSelected: widget.isSelected,
        ),
        subtitle: TextoItem(
          title: widget.subTitle,
          isSelected: widget.isSelected,
        ),
        dense: true,
      ),
    );
  }
}
