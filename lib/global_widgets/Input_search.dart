import 'package:flutter/material.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

class InputSearch extends StatelessWidget {
  final List<dynamic> lista;
  final String title;
  final void Function(String text) onChange;
  final Function validator;
  const InputSearch(
      {Key key, this.title, this.lista, this.onChange, this.validator})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: SearchableDropdown.single(
        displayClearIcon: false,
        validator: this.validator,
        label: this.title,
        icon: null,
        items: this.lista,
        hint: this.title,
        searchHint: this.title,
        onChanged: this.onChange,
        isExpanded: true,
        closeButton: "Cerrar",
      ),
    );
  }
}
