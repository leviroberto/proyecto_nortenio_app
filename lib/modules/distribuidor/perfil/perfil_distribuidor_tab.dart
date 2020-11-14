import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:proyect_nortenio_app/global_widgets/left_right_menu_button.dart';
import 'package:proyect_nortenio_app/modules/distribuidor/billete_distribuidor/billete_distribuidor_page.dart';
import 'package:proyect_nortenio_app/modules/distribuidor/billete_punto_venta/billete_punto_venta_page.dart';
import 'package:proyect_nortenio_app/utils/dialogs.dart';
import 'package:proyect_nortenio_app/utils/mensaje.dart';
import 'package:proyect_nortenio_app/utils/utilidades.dart';
import 'package:shape_of_view/shape_of_view.dart';

import '../../../utils/colores.dart';
import '../../../utils/responsive.dart';
import '../../principal/principal_controller.dart';

class TabPerfilDistribuidor extends StatefulWidget {
  @override
  _TabPerfilDistribuidorState createState() => _TabPerfilDistribuidorState();
}

class _TabPerfilDistribuidorState extends State<TabPerfilDistribuidor> {
  PrincipalController _principalController = Get.find();
  _confirm(BuildContext context) async {
    final isOk = await Dialogs.confirm(context,
        title: Mensaje.nomre_empresa,
        body: "Esta seguro de que desea salir de su cuenta?");
    print("isOk $isOk");
    if (isOk) {
      _principalController.cerrarSesion();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Responsive rosponsive = Responsive.of(context);

    return GetBuilder<PrincipalController>(
      builder: (state) => Scaffold(
        backgroundColor: Colores.bodyColor,
        appBar: AppBar(
          leading: Container(),
          elevation: 0,
          backgroundColor: Colores.colorBody,
          title: Center(
            child: Text(
              "Perfil Distribuidor",
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colores.bodyColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        body: Stack(
          children: [
            Positioned(
              top: -6,
              right: 0,
              left: 0,
              child: ShapeOfView(
                height: 165,
                shape: BubbleShape(
                  position: BubblePosition.Bottom,
                  arrowPositionPercent: 0.5,
                  borderRadius: 20,
                  arrowHeight: 20,
                  arrowWidth: 20,
                ),
                child: Container(
                  decoration: BoxDecoration(color: Colores.colorBody),
                ),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, top: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: 60.0,
                              width: 60.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colores.textosColorMorado,
                              ),
                              child: Center(
                                child: Text(
                                  Utilidades.generarIcono(
                                      letra1: _principalController
                                          .usuario.value.apellidos,
                                      letra2: _principalController
                                          .usuario.value.nombre),
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 25,
                                    color: Colores.bodyColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Obx(() => Text(
                                  _principalController
                                      .usuario.value.nombreCompleto,
                                  style: TextStyle(
                                    color: Colores.bodyColor,
                                    fontFamily: 'poppins',
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                )),
                            SizedBox(height: rosponsive.heightPercent(1)),
                            Obx(() => Text(
                                  _principalController
                                      .usuario.value.correoElectronico,
                                  style: TextStyle(
                                    color: Colores.colorNegro,
                                    fontFamily: 'poppins',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 25.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        /*LeftRightMenuButton(
                                color: Color(0xff707070),
                                leftIcon:
                                    'assets/pages/images/distribuidor.svg',
                                rightIcon: 'assets/pages/images/next.svg',
                                label: 'Gestionar Motorizados',
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                onPressed: () {
                                  Get.to(MotirizadoPage());
                                },
                              ),
                              LeftRightMenuButton(
                                color: Color(0xff707070),
                                leftIcon: 'assets/pages/images/zona.svg',
                                rightIcon: 'assets/pages/images/next.svg',
                                label: 'Gestionar Punto Venta',
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                onPressed: () {
                                  Get.to(PuntoVentaPage());
                                },
                              ),*/
                        LeftRightMenuButton(
                          color: Color(0xff707070),
                          leftIcon: 'assets/pages/images/sucursal.svg',
                          rightIcon: 'assets/pages/images/next.svg',
                          label: 'Gestionar Billetes',
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          onPressed: () {
                            Get.to(BilleteDistribuidor());
                          },
                        ),
                        LeftRightMenuButton(
                          color: Color(0xff707070),
                          leftIcon: 'assets/pages/images/empresa.svg',
                          rightIcon: 'assets/pages/images/next.svg',
                          label: 'Gestionar Billetes Punto de venta',
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          onPressed: () {
                            Get.to(BilletePuntoVentaPage());
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 3.0, top: 20.0),
                    child: Column(
                      children: [
                        /*  LeftRightMenuButton(
                                color: Color(0xff707070),
                                leftIcon: 'assets/pages/images/faq.svg',
                                rightIcon: 'assets/pages/images/next.svg',
                                label: 'Ayuda',
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                onPressed: () {
                                  //Navigator.pushNamed(context, "notificaciones");
                                },
                              ), */
                        LeftRightMenuButton(
                          color: Color(0xff707070),
                          leftIcon: 'assets/pages/images/power.svg',
                          rightIcon: 'assets/pages/images/next.svg',
                          label: 'Cerrar Sesión',
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          onPressed: () {
                            _confirm(context);
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
