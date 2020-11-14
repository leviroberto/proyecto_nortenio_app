import 'package:flutter/material.dart';

class DetalleItem extends StatelessWidget {
  final String textoDerecha, textoIzquierda;

  const DetalleItem({Key key, this.textoDerecha, this.textoIzquierda})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          textoIzquierda,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          textoDerecha,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
