import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:proyect_nortenio_app/modules/motorizado/tab/tab_principal_motorizado_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/models/notificacion.dart';
import 'modules/distribuidor/billete_distribuidor/billete_distribuidor_page.dart';
import 'modules/distribuidor/billete_distribuidor/local_widgets/editar_scallfold.dart';
import 'modules/distribuidor/tab/tab_principal_distribuidor_controller.dart';
import 'modules/gerente/tab/inicio/principal_controller.dart';
import 'modules/gerente/tab/maps/maps_notificacion_G.dart';
import 'modules/iniciar_sesion/iniciar_sesion_page.dart';
import 'modules/motorizado/billete_punto_venta/billete_punto_venta_page.dart';
import 'modules/principal/principal_page.dart';
import 'modules/reportes/detalle_ingresos_mes.dart';
import 'modules/reportes/reportes.dart';
import 'modules/splash/splash_binding.dart';
import 'modules/splash/splash_page.dart';
import 'routes/app_pages.dart';
import 'utils/colores.dart';
import 'utils/dependence_injection.dart';

import 'package:get/get.dart';

void main() {
  DependencyInjection.init();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();

  final FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  PrincipalDistribuidorControllerD _principalDistribuidorController =
      Get.find();
  PrincipalMotorizadoController _principalMotorizadoController = Get.find();
  PrincipalGerenteControllerG _principalGerenteControllerG = Get.find();
  // This widget is the root of your application.

  @override
  void initState() {
    _firebaseMessaging.requestNotificationPermissions();

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("On launch $message");

        dynamic data = message['data'];

        dynamic tipo = data['tipo'];

        dynamic tipoDecode = jsonDecode(tipo);
        Notificacion notificacion = new Notificacion(
            title: data['title'], subTitle: data['body'], date: data['fecha']);

        if (tipoDecode['opcion'] == "BILLETE_DISTRIBUIDOR") {
          _principalDistribuidorController.agregarNotificacion(notificacion);
          navigatorKey.currentState.pushNamed(BilleteDistribuidor.routeName);
        } else if (tipoDecode['opcion'] == "BILLETE_PUNTO_VENTA_MOTORIZADO") {
          _principalMotorizadoController.agregarNotificacion(notificacion);
          navigatorKey.currentState.pushNamed(BilletePuntoVentaPage.routeName);
        } else if (tipoDecode['opcion'] ==
            "BILLETE_PUNTO_VENTA_MOTORIZADO_GERENTE_ENTEGADO") {
          dynamic edicion = tipoDecode['edicion'];
          dynamic zona = tipoDecode['zona'];
          _principalGerenteControllerG.agregarNotificacion(notificacion);
          navigatorKey.currentState
              .pushNamed(MapsNotificacionG.routeName, arguments: tipoDecode);
        }
      },
      onResume: (Map<String, dynamic> message) async {
        print("On launch $message");

        dynamic data = message['data'];

        dynamic tipo = data['tipo'];

        dynamic tipoDecode = jsonDecode(tipo);
        Notificacion notificacion = new Notificacion(
            title: data['title'], subTitle: data['body'], date: data['fecha']);

        if (tipoDecode['opcion'] == "BILLETE_DISTRIBUIDOR") {
          _principalDistribuidorController.agregarNotificacion(notificacion);
          navigatorKey.currentState.pushNamed(BilleteDistribuidor.routeName);
        } else if (tipoDecode['opcion'] == "BILLETE_PUNTO_VENTA_MOTORIZADO") {
          _principalMotorizadoController.agregarNotificacion(notificacion);
          navigatorKey.currentState.pushNamed(BilletePuntoVentaPage.routeName);
        } else if (tipoDecode['opcion'] ==
            "BILLETE_PUNTO_VENTA_MOTORIZADO_GERENTE_ENTEGADO") {
          dynamic edicion = tipoDecode['edicion'];
          dynamic zona = tipoDecode['zona'];
          _principalGerenteControllerG.agregarNotificacion(notificacion);
          navigatorKey.currentState
              .pushNamed(MapsNotificacionG.routeName, arguments: tipoDecode);
        }
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("On launch $message");

        dynamic data = message['data'];

        dynamic tipo = data['tipo'];

        dynamic tipoDecode = jsonDecode(tipo);
        Notificacion notificacion = new Notificacion(
            title: data['title'], subTitle: data['body'], date: data['fecha']);

        if (tipoDecode['opcion'] == "BILLETE_DISTRIBUIDOR") {
          _principalDistribuidorController.agregarNotificacion(notificacion);
          navigatorKey.currentState.pushNamed(BilleteDistribuidor.routeName);
        } else if (tipoDecode['opcion'] == "BILLETE_PUNTO_VENTA_MOTORIZADO") {
          _principalMotorizadoController.agregarNotificacion(notificacion);
          navigatorKey.currentState.pushNamed(BilletePuntoVentaPage.routeName);
        } else if (tipoDecode['opcion'] ==
            "BILLETE_PUNTO_VENTA_MOTORIZADO_GERENTE_ENTEGADO") {
          dynamic edicion = tipoDecode['edicion'];
          dynamic zona = tipoDecode['zona'];
          _principalGerenteControllerG.agregarNotificacion(notificacion);
          navigatorKey.currentState
              .pushNamed(MapsNotificacionG.routeName, arguments: tipoDecode);
        }
      },
    );

    _firebaseMessaging.getToken().then((token) {
      print("Token");
      print(token);
      _agregarTokenCliente(token);
    });
    super.initState();
  }

  _agregarTokenCliente(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("token_usuario", token);
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SMG Lottery',
      navigatorKey: navigatorKey,
      theme: ThemeData(
        primaryColor: Colores.colorButton,
        fontFamily: 'sans',
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: DetalleIngresosMes(),
      initialBinding: SplashBinding(),
      getPages: AppPages.pages,
      routes: {
        EditarScallfold.routeName: (_) => EditarScallfold(),
        PrincipalPage.routeName: (_) => PrincipalPage(),
        IniciarSesionPage.routeName: (_) => IniciarSesionPage(),
        BilleteDistribuidor.routeName: (_) => BilleteDistribuidor(),
        BilletePuntoVentaPage.routeName: (_) => BilletePuntoVentaPage(),
        MapsNotificacionG.routeName: (_) => MapsNotificacionG(),
      },
    );
  }
}
