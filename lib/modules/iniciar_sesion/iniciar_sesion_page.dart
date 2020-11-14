import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../modules/iniciar_sesion/iniciar_sesion_controller.dart';
import '../../utils/colores.dart';
import '../../utils/responsive.dart';
import 'local_widgets/formulario_iniciar_sesion.dart';
import 'local_widgets/logo_bienvenido.dart';

class IniciarSesionPage extends StatefulWidget {
  static const routeName = 'iniciar_sesion_page';
  @override
  _IniciarSesionPageState createState() => _IniciarSesionPageState();
}

class _IniciarSesionPageState extends State<IniciarSesionPage>
    with AfterLayoutMixin {
  Responsive responsive;

  @override
  Widget build(BuildContext context) {
    responsive = Responsive.of(context);
    return GetBuilder<IniciarSesionController>(
      builder: (state) => Scaffold(
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Container(
            height: double.infinity,
            width: double.infinity,
            color: Colores.bodyColor,
            //OrientationBuilder para que en la tablet se pueda realizar la rotacion de pantalla comparamos si esta en
            //if (orientation == Orientation.portrait) { que nos devuelba la vista normal
            //de lo contrario realizamos loque esta en el else con un row
            child: OrientationBuilder(
              builder: (_, Orientation orientation) {
                if (orientation == Orientation.portrait) {
                  return SingleChildScrollView(
                    child: Container(
                      height: responsive.height,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          generarLogo(),
                          FormularioInciarSesion(
                            contextPadre: context,
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Row(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          physics:
                              NeverScrollableScrollPhysics(), // para bloquear el scrol
                          child: Container(
                            padding: EdgeInsets.only(left: 20),
                            height: responsive.height,
                            child: Center(
                              child: LogoBienvenido(),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Container(
                            height: responsive.height,
                            child: Center(
                              child: FormularioInciarSesion(
                                contextPadre: context,
                              ),
                            ),
                          ),
                        ),
                      ),
                      //SizedBox(height: responsive.diagonalPercent(5)),
                    ],
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget generarLogo() {
    return AspectRatio(
      aspectRatio: 16 / 15,
      child: LayoutBuilder(
        builder: (_, constraints) {
          return Container(
            child: Stack(
              children: <Widget>[
                Positioned(
                  top: constraints.maxHeight * 0.61,
                  child: Column(
                    children: [
                      Container(
                        height: 3,
                        width: constraints.maxWidth,
                        color: Colors.white,
                      ),
                      Text(
                        "Bienvenido a SMG Lottery",
                        style: TextStyle(
                          fontSize: responsive.diagonalPercent(2.5),
                          fontWeight: FontWeight.bold,
                          fontFamily: 'poppins',
                          color: Colores.colorTitulos,
                        ),
                      ),
                      SizedBox(height: 10),
                      SvgPicture.asset(
                        'assets/pages/login/logo.svg',
                        height: constraints.maxHeight * 0.25,
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
                /* Positioned(
                  left: constraints.maxWidth * 0.4,
                  top: constraints.maxHeight * 0.43,
                  child: SvgPicture.asset(
                    'assets/pages/login/logo.svg',
                    height: constraints.maxHeight * 0.20,
                  ),
                ),*/
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
  }

  @override
  void afterFirstLayout(BuildContext context) {
    final bool isTablet = MediaQuery.of(context).size.shortestSide >
        600; //para ver si estamos en una tablet
    if (!isTablet) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp
      ]); //anulamos la rotacion en dispositivo celular
    }
  }
}
