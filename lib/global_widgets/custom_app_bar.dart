import 'package:flutter/material.dart';
import 'package:proyect_nortenio_app/utils/colores.dart';
import 'package:proyect_nortenio_app/utils/util.dart';

class CustomAppBar extends StatefulWidget with PreferredSizeWidget {
  final String title;
  final bool haveSearch;
  final bool haveAtras;
  final void Function() onTapAtras, onTapSearch;

  const CustomAppBar(
      {@required this.title,
      this.haveSearch = false,
      this.onTapAtras,
      this.onTapSearch,
      this.haveAtras = true});
  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colores.colorBody,
      elevation: 0,
      leading: widget.haveAtras
          ? IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colores.bodyColor,
              ),
              onPressed: () {
                widget.onTapAtras();
              })
          : Container(),
      title: Center(
        child: Text(
          Util.checkString(widget.title),
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colores.bodyColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      actions: <Widget>[
        widget.haveSearch
            ? IconButton(
                icon: const Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                onPressed: () {
                  widget.onTapSearch();
                },
              )
            : Container()
      ],
    );
  }
}
