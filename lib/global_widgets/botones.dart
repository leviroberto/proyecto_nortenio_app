import 'package:flutter/material.dart';

class Botones extends StatelessWidget {
  final Text label;
  final Icon icon;
  final double width, height;
  final Color backgroundColor, textColor;
  final VoidCallback onPressed;
  const Botones(
      {Key key,
      this.icon,
      @required this.label,
      @required this.backgroundColor,
      this.textColor,
      this.onPressed,
      this.width,
      this.height})
      : assert(label != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: this.width,
      height: this.height,
      child: FlatButton.icon(
        color: textColor,
        textColor: textColor,
        onPressed: this.onPressed,
        icon: this.icon,
        label: this.label,
      ),
      decoration: BoxDecoration(
        color: this.backgroundColor ?? Color(0xffFDCB0A),
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 5),
        ],
      ),
    );
  }
}
