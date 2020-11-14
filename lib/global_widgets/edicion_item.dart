import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:proyect_nortenio_app/data/models/color.dart';
import 'package:proyect_nortenio_app/data/models/edicion.dart';
import 'package:proyect_nortenio_app/utils/colores.dart';
import 'package:proyect_nortenio_app/utils/responsive.dart';
import 'package:proyect_nortenio_app/utils/utilidades.dart';

class EdicionItem extends StatelessWidget {
  final Edicion edicion;

  const EdicionItem({@required this.edicion});
  @override
  Widget build(BuildContext context) {
    ColorHome colorHome = Utilidades.obtenerColorRandom();
    final Responsive responsive = Responsive.of(context);

    /*return Container(
      height: 70,
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
              color: colorHome.color1.withOpacity(.8),
              borderRadius: BorderRadius.circular(12)),
          alignment: Alignment.center,
          child: Icon(
            Icons.blur_linear,
            size: 20,
            color: Colors.white,
          ),
        ),
        title: Text(
          "ED" + edicion.numero,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          edicion.formarFecha(),
          style: TextStyle(fontSize: 12),
        ),
        trailing: Text(
          edicion.formarEstado(),
          style: TextStyle(
              fontSize: 12,
              color: edicion.formarColor(),
              fontWeight: FontWeight.bold),
        ),
      ),
    );*/

    return Material(
      color: colorHome.color1.withOpacity(.8),
      elevation: 8.0,
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
      child: InkWell(
        onTap: () {},
        child: Container(
          margin: EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(
                      children: [
                        Text(
                          "ED" + edicion.numero,
                          style: TextStyle(
                            color: Colores.colorNegro,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                        SvgPicture.asset(
                          'assets/pages/login/logo.svg',
                          height: responsive.heightPercent(6),
                        ),
                        Spacer(),
                        Text(
                          edicion.formarEstado(),
                          style: TextStyle(
                            color: Colores.colorNegro,
                            fontSize: 18.0,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.0),
                    Container(
                      height: 0.5,
                      color: Colors.white,
                    ),
                    SizedBox(height: 16.0),
                    Row(
                      children: [
                        Text(
                          "Inicio",
                          style: TextStyle(
                            color: Colores.colorNegro,
                            fontSize: 20.0,
                          ),
                        ),
                        Spacer(),
                        Text(
                          edicion.formarFechaInicio(),
                          style: TextStyle(
                            color: Colores.colorNegro,
                            fontSize: 18.0,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      children: [
                        Text(
                          "Fin",
                          style: TextStyle(
                            color: Colores.colorNegro,
                            fontSize: 20.0,
                          ),
                        ),
                        Spacer(),
                        Text(
                          edicion.formarFechaFin(),
                          style: TextStyle(
                            color: Colores.colorNegro,
                            fontSize: 18.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
