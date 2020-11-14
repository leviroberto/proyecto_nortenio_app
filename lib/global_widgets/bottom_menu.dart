import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/colores.dart';

class BottomMenuItem {
  final String label;
  final IconData icon;
  final Widget content;

  BottomMenuItem(
      {@required this.icon, @required this.label, @required this.content});
}

class BottomMenu extends StatelessWidget {
  final List<BottomMenuItem> items;
  final int currentPage;
  final void Function(int) onChanged;

  BottomMenu({@required this.items, @required this.currentPage, this.onChanged})
      : assert(items != null && items.length > 0),
        assert(currentPage != null && currentPage >= 0);
  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      index: 0,
      height: 55.0,
      items: _buildBottonNavigation(),
      color: Colores.colorBody,
      buttonBackgroundColor: Colores.colorBody,
      backgroundColor: Colors.white,
      animationCurve: Curves.easeInOut,
      animationDuration: Duration(milliseconds: 600),
      onTap: (int newCurrentPage) {
        onChanged(newCurrentPage);
      },
    );
  }

  List<Widget> _buildBottonNavigation() {
    List<Widget> listWidget = new List<Widget>();
    for (int i = 0; i < items.length; i++) {
      listWidget.add(Icon(
        items[i].icon,
        size: 32,
        color: Colors.white,
      ));
    }
    return listWidget;
  }
}
