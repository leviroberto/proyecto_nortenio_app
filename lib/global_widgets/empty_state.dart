import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:proyect_nortenio_app/utils/responsive.dart';

class EmptyState extends StatefulWidget {
  @override
  _EmptyStateState createState() => _EmptyStateState();
}

class _EmptyStateState extends State<EmptyState> {
  @override
  Widget build(BuildContext context) {
    Responsive responsive = Responsive.of(context);
    return Container(
      width: responsive.width,
      height: responsive.height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/pages/images/vacio.svg',
            height: responsive.height * 0.25,
            width: responsive.width * 0.30,
          ),
          Text(
            "No hay resultados",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            "Aun no has agregado ningun elemento",
            style: TextStyle(fontWeight: FontWeight.normal, fontSize: 12.0),
          ),
        ],
      ),
    );
  }
}
