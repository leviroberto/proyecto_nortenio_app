import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:proyect_nortenio_app/global_widgets/bottom_menu.dart';
import 'package:proyect_nortenio_app/global_widgets/my_page_view.dart';
import 'package:proyect_nortenio_app/modules/principal/principal_controller.dart';
import 'package:proyect_nortenio_app/utils/colores.dart';

class PrincipalPage extends StatefulWidget {
  static const routeName = 'principal_page';
  @override
  _PrincipalPageState createState() => _PrincipalPageState();
}

class _PrincipalPageState extends State<PrincipalPage> with AfterLayoutMixin {
  PrincipalController _principalController = Get.find();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PrincipalController>(
      builder: (state) => Scaffold(
        backgroundColor: Colores.bodyColor,
        bottomNavigationBar: Obx(() => BottomMenu(
              currentPage: state.currentTab.value,
              onChanged: (int newCurrentPage) {
                state.setCurrectTab(newCurrentPage);
              },
              items: state.menu,
            )),
        body: SafeArea(
          top: true,
          bottom: true,
          child: Container(
            width: double.infinity,
            color: Colors.white,
            child: Column(
              children: <Widget>[
                // appbar
                Expanded(
                  child: Obx(() => MyPageView(
                        children: state.menu
                            .map<Widget>((item) => item.content)
                            .toList(),
                        currentPage: state.currentTab.value,
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    await _principalController.obtenerUsuario();
    _principalController.cargando.value = false;
    /*   verificarConexion(); */
  }

/*   verificarConexion() async {
    dynamic response = await Utilidades.verificarConexionInternet();
    if (response) {
      if (_principalController.usuario.value.esGerente()) {
        _principalController.cargando.value = false;
      }
      if (_principalController.usuario.value.esDistribuidor()) {
        if (!await _principalController.cargarZonaPorDistritbuidor()) {
          _principalController.cerrarSesion();
        }
      } else if (_principalController.usuario.value.esMotorizado()) {
        if (!await _principalController.cargarZonaPorMotorizado()) {
          _principalController.cerrarSesion();
        }
      }
    }
  } */
}
