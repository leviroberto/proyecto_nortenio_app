import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Prueba extends StatefulWidget {
  @override
  _PruebaState createState() => _PruebaState();
}

class _PruebaState extends State<Prueba> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebView(
        initialUrl: "http://goldsilver.brindiscampos.com/",
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
