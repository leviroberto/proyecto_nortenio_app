import 'package:flutter/material.dart';
import 'package:proyect_nortenio_app/utils/util.dart';

class Texto extends StatelessWidget {
  final String title;

  const Texto({@required this.title});
  @override
  Widget build(BuildContext context) {
    return Text(
      Util.checkString(title),
      overflow: TextOverflow.ellipsis,
    );
  }
}
