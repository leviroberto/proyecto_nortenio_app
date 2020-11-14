import 'package:flutter/material.dart';
import 'package:proyect_nortenio_app/utils/colores.dart';

class TextoItem extends StatelessWidget {
  final String title;
  final bool isTitulo;
  final bool isSelected;

  const TextoItem({this.title, this.isTitulo = false, this.isSelected = false});
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: isSelected
            ? Colors.black38
            : isTitulo
                ? Colores.colorTitulos
                : Colores.colorSubTitulos,
        fontWeight: isTitulo ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}
