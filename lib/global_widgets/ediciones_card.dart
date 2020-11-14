import 'package:flutter/material.dart';
import 'package:proyect_nortenio_app/data/models/edicion.dart';
import 'package:proyect_nortenio_app/global_widgets/edicion_item.dart';

class EdicionCard extends StatefulWidget {
  final double height;

  final List<Edicion> lista;

  const EdicionCard({this.height, @required this.lista});
  @override
  _EdicionCardState createState() => _EdicionCardState();
}

class _EdicionCardState extends State<EdicionCard> {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Positioned(
      top: 0,
      child: AnimatedContainer(
        duration: Duration(seconds: 1),
        curve: Curves.fastOutSlowIn,
        width: mediaQuery.size.width * .94,
        height: mediaQuery.size.height * widget.height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
          border: Border.all(color: Colors.white),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(1, 1),
              spreadRadius: 1,
              blurRadius: 1,
            ),
          ],
        ),
        child: ListView.builder(
          itemCount: widget.lista.length,
          itemBuilder: (context, i) {
            Edicion edicion = widget.lista[i];
            return EdicionItem(edicion: edicion);
          },
        ),
      ),
    );
  }
}
