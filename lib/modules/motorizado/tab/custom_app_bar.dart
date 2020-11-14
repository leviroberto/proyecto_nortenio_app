import 'package:flutter/material.dart';
import 'package:proyect_nortenio_app/utils/colores.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colores.colorBody,
      elevation: 0.0,
      leading: Container(),
      title: Center(
        child: Text(
          "SMG Lottery",
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colores.bodyColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
