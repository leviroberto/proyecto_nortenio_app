import 'package:flutter/material.dart';
import 'package:proyect_nortenio_app/utils/colores.dart';

class TabPrincipal extends StatefulWidget {
  @override
  _TabPrincipalState createState() => _TabPrincipalState();
}

class _TabPrincipalState extends State<TabPrincipal> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colores.colorRojo),
      body: Container(),
    );
  }
}
