import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:proyect_nortenio_app/utils/letra.dart';

class InputForm extends StatelessWidget {
  final String label, hint;
  final TextInputType keyboardType;
  final bool obscureText, borderEnabled;
  final double fontSize, width;
  final Icon icon;
  final ValueChanged<String> onChanged;
  final void Function(String) onFieldSubmitted;
  final void Function() onTap;
  final void Function() onPressedIconPassword;
  final String Function(String text) validator;

  final FocusNode focusNone;

  final bool isPassword, enabled;
  final bool passwordVisible;
  final String errorText;

  final int maxLength;
  final TextStyle style;

  final TextEditingController controller;

  const InputForm(
      {Key key,
      this.label,
      this.maxLength = 100,
      this.errorText,
      this.style = const TextStyle(
          fontFamily: 'sans', color: Colors.black, fontSize: Letra.letrChica),
      this.enabled = true,
      this.keyboardType = TextInputType.text,
      this.obscureText = false,
      this.borderEnabled = true,
      this.isPassword = false,
      this.onPressedIconPassword,
      this.fontSize = 15,
      this.icon,
      this.controller,
      this.passwordVisible = false,
      this.onChanged,
      this.validator,
      this.hint = "",
      this.width = 300,
      this.onTap,
      this.focusNone,
      this.onFieldSubmitted})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (this.isPassword) {
      return Container(
        child: TextFormField(
            style: this.style,
            enabled: this.enabled,
            validator: validator,
            controller: this.controller,
            decoration: InputDecoration(
                errorText: errorText ?? null,
                hintText: "***********",
                labelText: this.label,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                prefixIcon: Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(
                    // Based on passwordVisible state choose the icon
                    passwordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Theme.of(context).primaryColorDark,
                  ),
                  onPressed: onPressedIconPassword,
                )),
            keyboardType: TextInputType.text, //para poner teclado de correo
            keyboardAppearance: Brightness.light, //poner color al teclado
            textInputAction:
                TextInputAction.next, // pone siguiente en el teclado

            obscureText: !passwordVisible,
            focusNode: focusNone,
            onFieldSubmitted: onFieldSubmitted,
            onChanged: this.onChanged,
            maxLength: this.maxLength),
      );
    }
    return Container(
      child: TextFormField(
          enabled: this.enabled,
          controller: this.controller,
          style: this.style,
          decoration: InputDecoration(
            errorText: errorText ?? null,
            hintText: this.hint,
            labelText: this.label,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(40)),
            prefixIcon: this.icon,
          ),
          keyboardType: this.keyboardType, //para poner teclado de correo
          keyboardAppearance: Brightness.light, //poner color al teclado
          textInputAction: TextInputAction.next, // pone siguiente en el teclado
          validator: this.validator,
          onTap: this.onTap,
          focusNode: this.focusNone,
          onFieldSubmitted: onFieldSubmitted,
          onChanged: this.onChanged,
          maxLength: this.maxLength),
    );
  }
}
