import 'package:flutter/material.dart';
import 'package:proyect_nortenio_app/utils/colores.dart';

class ListDropdown extends StatelessWidget {
  final List<String> listas;
  final String title;
  final Function(String) onChanged;

  const ListDropdown(
      {@required this.listas, @required this.title, @required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.0),
      height: 40.0,
      decoration: BoxDecoration(
        color: Colores.bodyColor,
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: title,
          items: listas
              .map((e) => DropdownMenuItem(
                    child: Row(
                      children: [
                        Text(
                          e,
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                    value: e,
                  ))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
