import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:proyect_nortenio_app/utils/colores.dart';
import 'package:proyect_nortenio_app/utils/responsive.dart';

class LogoBienvenido extends StatelessWidget {
  const LogoBienvenido({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    return AspectRatio(
      aspectRatio: 16 / 11,
      child: LayoutBuilder(
        builder: (_, constraints) {
          return Container(
            child: Stack(
              children: <Widget>[
                Positioned(
                  top: constraints.maxHeight * 0.7,
                  child: Column(
                    children: [
                      Container(
                        height: 3,
                        width: constraints.maxWidth,
                        color: Colors.white,
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Bienvenido a SMG",
                        style: TextStyle(
                          fontSize: responsive.diagonalPercent(2.5),
                          fontWeight: FontWeight.bold,
                          fontFamily: 'poppins',
                          color: Colores.colorTitulos,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  left: 0,
                  child: SvgPicture.asset(
                    'assets/pages/login/fondo.svg',
                    height: constraints.maxHeight * 0.75,
                  ),
                ),
                Positioned(
                  left: constraints.maxWidth * 0.01,
                  top: constraints.maxHeight * 0.17,
                  child: SvgPicture.asset(
                    'assets/pages/login/direccion.svg',
                    width: constraints.maxWidth * 0.35,
                  ),
                ),
                Positioned(
                  top: constraints.maxHeight * 0.18,
                  right: constraints.maxHeight * 0.01,
                  child: SvgPicture.asset(
                    'assets/pages/login/estadistica.svg',
                    width: constraints.maxWidth * 0.40,
                  ),
                ),
                Positioned(
                  left: constraints.maxWidth * 0.4,
                  top: constraints.maxHeight * 0.43,
                  child: SvgPicture.asset(
                    'assets/pages/login/logo.svg',
                    height: constraints.maxHeight * 0.20,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
