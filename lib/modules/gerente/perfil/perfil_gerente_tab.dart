import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:proyect_nortenio_app/global_widgets/custom_app_bar.dart';
import 'package:proyect_nortenio_app/global_widgets/left_right_menu_button.dart';
import 'package:proyect_nortenio_app/modules/gerente/billetes/billetes_page.dart';
import 'package:proyect_nortenio_app/modules/gerente/distribuidor/distribuidor_page.dart';
import 'package:proyect_nortenio_app/modules/gerente/edicion/edicion_page.dart';
import 'package:proyect_nortenio_app/modules/gerente/zona/zona_page.dart';
import 'package:proyect_nortenio_app/utils/dialogs.dart';
import 'package:proyect_nortenio_app/utils/mensaje.dart';
import 'package:proyect_nortenio_app/utils/utilidades.dart';
import 'package:shape_of_view/shape_of_view.dart';

import '../../../utils/colores.dart';
import '../../principal/principal_controller.dart';

class PerfilGerenteTab extends StatefulWidget {
  @override
  _PerfilGerenteTabState createState() => _PerfilGerenteTabState();
}

class _PerfilGerenteTabState extends State<PerfilGerenteTab> {
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
    return GetBuilder<PrincipalController>(
        builder: (state) => Scaffold(
              backgroundColor: Colores.bodyColor,
              appBar: CustomAppBar(
                haveAtras: false,
                title: "Perfil gerencial",
                onTapAtras: () {
                  Navigator.pop(context);
                },
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 10.0, top: 20.0),
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
                                          color: Colores.colorTitulos,
                                          fontFamily: 'poppins',
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      )),
                                  Obx(() => Text(
                                        _principalController
                                            .usuario.value.correoElectronico,
                                        style: TextStyle(
                                          color: Colores.colorTitulos,
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
                              /*  LeftRightMenuButton(
                                color: Color(0xff707070),
                                leftIcon: 'assets/pages/images/empresa.svg',
                                rightIcon: 'assets/pages/images/next.svg',
                                label: 'Gestionar Empresa',
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                onPressed: () {},
                              ), */
                              LeftRightMenuButton(
                                color: Color(0xff707070),
                                leftIcon:
                                    'assets/pages/images/distribuidor.svg',
                                rightIcon: 'assets/pages/images/next.svg',
                                label: 'Gestionar Distribuidores',
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                onPressed: () {
                                  Get.to(DistribuidorPage());
                                },
                              ),
                              /*  LeftRightMenuButton(
                                color: Color(0xff707070),
                                leftIcon: 'assets/pages/images/bicicleta.svg',
                                rightIcon: 'assets/pages/images/next.svg',
                                label: 'Gestionar Motorizado',
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                onPressed: () {
                                  Get.to(MotirizadoPage());
                                },
                              ), */
                              LeftRightMenuButton(
                                color: Color(0xff707070),
                                leftIcon: 'assets/pages/images/zona.svg',
                                rightIcon: 'assets/pages/images/next.svg',
                                label: 'Gestionar Zonas',
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                onPressed: () {
                                  Get.to(ZonaPage());
                                },
                              ),
                              /* LeftRightMenuButton(
                                color: Color(0xff707070),
                                leftIcon: 'assets/pages/images/puntoventa.svg',
                                rightIcon: 'assets/pages/images/next.svg',
                                label: 'Gestionar Punto De Venta',
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                onPressed: () {
                                  Get.to(PuntoVentaPage());
                                },
                              ), */
                              LeftRightMenuButton(
                                color: Color(0xff707070),
                                leftIcon: 'assets/pages/images/calendario.svg',
                                rightIcon: 'assets/pages/images/next.svg',
                                label: 'Gestionar ediciones',
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                onPressed: () {
                                  Get.to(EdicionPage());
                                },
                              ),
                              LeftRightMenuButton(
                                color: Color(0xff707070),
                                leftIcon: 'assets/pages/images/sucursal.svg',
                                rightIcon: 'assets/pages/images/next.svg',
                                label: 'Billetes por distribuidor',
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                onPressed: () {
                                  Get.to(BilletePage());
                                },
                              ),
                              LeftRightMenuButton(
                                color: Color(0xff707070),
                                leftIcon: 'assets/pages/images/sucursal.svg',
                                rightIcon: 'assets/pages/images/next.svg',
                                label: 'Reporte semanales',
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                onPressed: () {
                                  Get.to(BilletePage());
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
            ));
  }
}
//quitar el icono en regstrar billete, DISTRIBUIDOR, ENTREGAR BILLETES QUITAL EL ICONO, CAMBIAR ICONO DE ESTADO
