import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:proyect_nortenio_app/utils/colores.dart';

class CircleButton extends StatelessWidget {
  final double size;
  final Color backGroundColor;
  final String iconPath;
  final VoidCallback onPressed;
  const CircleButton(
      {Key key,
      this.size = 50,
      this.backGroundColor,
      @required this.iconPath,
      @required this.onPressed})
      : assert(iconPath != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: this.onPressed,
      child: Container(
        width: this.size,
        height: this.size,
        padding: EdgeInsets.all(12.0),
        child: SvgPicture.asset(
          iconPath,
          color: Colores.bodyColor,
        ),
        decoration: BoxDecoration(
          color: this.backGroundColor ?? Colors.blue,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
