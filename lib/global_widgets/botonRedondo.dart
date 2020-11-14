import 'package:flutter/material.dart';
import 'package:proyect_nortenio_app/utils/colores.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class BotonRedondo extends StatelessWidget {
  final Color background, colorText;
  final double width;
  final String titulo;
  final VoidCallback onPressed;
  final bool isEnabled;
  final Icon icon;
  final RoundedLoadingButtonController btnController;
  const BotonRedondo(
      {Key key,
      this.background,
      this.colorText,
      this.icon,
      this.isEnabled = true,
      this.onPressed,
      this.width,
      this.titulo,
      @required this.btnController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RoundedLoadingButton(
      color: this.background ?? Colores.colorButton,
      animateOnTap: isEnabled,
      height: 55,
      width: this.width ?? 30,
      child: Container(
        width: this.width ?? 80,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon ?? Container(),
            Text(
              titulo,
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'sans',
                letterSpacing: 1,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      controller: btnController,
      onPressed: () {
        FocusScope.of(context).unfocus();
        this.onPressed();
      },
    );
  }
}
