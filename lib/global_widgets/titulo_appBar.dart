import 'package:flutter/material.dart';
import 'package:proyect_nortenio_app/utils/colores.dart';

class TituloAppBar extends StatelessWidget {
  final String title;
  final bool isBold;

  const TituloAppBar({this.title, this.isBold = false});
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: Colores.bodyColor,
        fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}
