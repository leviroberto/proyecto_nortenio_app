import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:proyect_nortenio_app/data/models/notificacion.dart';
import 'package:proyect_nortenio_app/global_widgets/texto_item.dart';
import 'package:proyect_nortenio_app/utils/colores.dart';
import 'package:proyect_nortenio_app/utils/utilidades.dart';

class NotificacionCard extends StatefulWidget {
  final Notificacion notificacion;

  final void Function() onTapActualizar;

  const NotificacionCard({this.notificacion, this.onTapActualizar});
  @override
  _NotificacionCardState createState() => _NotificacionCardState();
}

class _NotificacionCardState extends State<NotificacionCard> {
  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: SlidableScrollActionPane(),
      actions: <Widget>[
        IconSlideAction(
          color: Colores.bodyColor,
          icon: Icons.next_plan,
          foregroundColor: Colores.colorBody,
          onTap: () {
            widget.onTapActualizar();
          },
        ),
      ],
      child: GestureDetector(
        onTap: () {},
        child: Card(
          margin: EdgeInsets.only(bottom: 6.0),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: ListTile(
            onTap: () {
              widget.onTapActualizar();
            },
            title: TextoItem(
              title: widget.notificacion.title,
              isTitulo: true,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextoItem(title: widget.notificacion.subTitle),
                Text(Utilidades.formatFecha(
                    dateTime: Utilidades.formatDateTime(
                        fecha: widget.notificacion.date.toString())))
              ],
            ),
            isThreeLine: true,
            dense: true,
          ),
        ),
      ),
    );
  }
}
