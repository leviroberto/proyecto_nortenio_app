import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:proyect_nortenio_app/data/models/color.dart';
import 'package:proyect_nortenio_app/data/models/edicion.dart';
import 'package:proyect_nortenio_app/data/models/notificacion.dart';
import 'package:proyect_nortenio_app/global_widgets/bottom_menu.dart';
import 'package:proyect_nortenio_app/modules/distribuidor/motirizado/motirizado_page.dart';
import 'package:proyect_nortenio_app/modules/distribuidor/perfil/perfil_distribuidor_tab.dart';
import 'package:proyect_nortenio_app/modules/distribuidor/punto_venta/punto_venta_page.dart';
import 'package:proyect_nortenio_app/modules/distribuidor/tab/tab_principal_distribuidor.dart';
import 'package:proyect_nortenio_app/modules/gerente/perfil/perfil_gerente_tab.dart';
import 'package:proyect_nortenio_app/modules/gerente/tab/inicio/principal_tab.dart';
import 'package:proyect_nortenio_app/modules/gerente/tab/maps/maps_tab.dart';
import 'package:proyect_nortenio_app/modules/gerente/tab/reporte/reporte_tab.dart';
import 'package:proyect_nortenio_app/modules/motorizado/perfil/perfil_motorizado_tab.dart';
import 'package:diacritic/diacritic.dart';
import 'package:proyect_nortenio_app/modules/motorizado/tab/mapa/maps_tab.dart';
import 'package:proyect_nortenio_app/modules/motorizado/tab/tab_principal_motorizado.dart';
import 'util.dart';

class Utilidades {
  static String generarUsuaerio({String apellidos, String nombre}) {
    String uno = nombre.substring(0, 1);
    String dos = apellidos;
    String tres = apellidos.substring(0, 1);
    String generad = uno + "" + dos + "" + tres;
    return removeDiacritics(generad).toLowerCase();
  }

  static String generarPrimeraMayuscula({String palabra}) {
    List<String> lista = palabra.split(" ");
    String convertido = "";
    lista.forEach((element) {
      convertido = convertido + " " + ucFirst(element.toLowerCase());
    });
    return convertido;
  }

  static String ucFirst(String s) {
    if (s.isEmpty) {
      return s;
    } else {
      return s[0].toUpperCase() + "" + s.substring(1);
    }
  }

  static String generarContrasenia({String usuario}) {
    String password = "";
    if (usuario.length < 5) {
      password = usuario + "1**";
    } else {
      password = usuario;
    }
    return password;
  }

  static void mostrarMensajeSnackBar(
      {Notificacion notificacion, BuildContext context}) {
    switch (notificacion.estado) {
      case Notificacion.TIPO_ADVERTENCIA:
        Scaffold.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.deepOrangeAccent,
            content: Text(
              '${notificacion.title}',
              style: TextStyle(
                color: Colors.black87,
              ),
            ),
            duration: Duration(seconds: 6),
          ),
        );
        break;
      case Notificacion.TIPO_CORRECTO:
        Scaffold.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              '${notificacion.title}',
              style: TextStyle(
                color: Colors.black87,
              ),
            ),
            duration: Duration(seconds: 3),
          ),
        );
        Future.delayed(Duration(seconds: 3)).then((_) {
          Navigator.pop(context);
        });

        break;
      case Notificacion.TIPO_ERROR:
        Scaffold.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text(
              '${notificacion.title}',
              style: TextStyle(
                color: Colors.black87,
              ),
            ),
            duration: Duration(seconds: 6),
          ),
        );
        break;
    }
  }

  List<BottomMenuItem> obtenerMenu(int tipo) {
    List<BottomMenuItem> _menu = [];
    switch (tipo) {
      case 2: //gerente
        _menu = [
          BottomMenuItem(
              icon: Icons.home, label: 'Inicio', content: PrincipalTab()),
          /*  BottomMenuItem(
              icon: Icons.motorcycle,
              label: 'Motorizado',
              content: TabPrincipal()), */
          BottomMenuItem(icon: Icons.place, label: 'Mapa', content: MapsTabG()),
          BottomMenuItem(
              icon: Icons.trending_up, label: 'Reporte', content: ReporteTab()),
          BottomMenuItem(
              icon: Icons.person, label: 'Perfil', content: PerfilGerenteTab()),
        ];
        break;
      case 3: //motorizado
        _menu = [
          BottomMenuItem(
              icon: Icons.home,
              label: 'Inicio',
              content: TabPrincipalMotorizado()),
          BottomMenuItem(icon: Icons.place, label: 'Mapa', content: MapsTabM()),
          BottomMenuItem(
              icon: Icons.person,
              label: 'Perfil',
              content: TabPerfilMotorizado()),
        ];
        break;
      case 4: //Distribuidor
        _menu = [
          BottomMenuItem(
              icon: Icons.home,
              label: 'Inicio',
              content: PrincipalDistribuidorTab()),
          BottomMenuItem(
              icon: Icons.motorcycle,
              label: 'Motorizado',
              content: MotirizadoPage(
                isBack: false,
              )),
          BottomMenuItem(
              icon: Icons.store,
              label: 'Punto Venta',
              content: PuntoVentaPage(
                isBack: false,
              )),
          BottomMenuItem(
              icon: Icons.person,
              label: 'Perfil',
              content: TabPerfilDistribuidor()),
        ];
        break;
    }

    return _menu;
  }

  static String getAnio(String fecha) {
    if (fecha == null || fecha == "") {
      return "";
    }
    DateTime tm = DateTime.parse(fecha);

    return '${tm.year}';
  }

  static String getMes(String fecha) {
    if (fecha == null || fecha == "") {
      return "";
    }
    DateTime tm = DateTime.parse(fecha);

    return '${tm.month}';
  }

  static String getMesPalabra(String mes) {
    String mesEscrito = "";

    switch (mes) {
      case "1":
        mesEscrito = "Enero";
        break;
      case "2":
        mesEscrito = "Febrero";
        break;
      case "3":
        mesEscrito = "Marzo";
        break;
      case "4":
        mesEscrito = "Abril";
        break;
      case "5":
        mesEscrito = "Mayo";
        break;
      case "6":
        mesEscrito = "Junio";
        break;
      case "7":
        mesEscrito = "Julio";
        break;
      case "8":
        mesEscrito = "Agosto";
        break;
      case "9":
        mesEscrito = "Septiembre";
        break;
      case "10":
        mesEscrito = "Octubre";
        break;
      case "11":
        mesEscrito = "Noviembre";
        break;
      case "12":
        mesEscrito = "Diciembre";
        break;
    }

    return mesEscrito;
  }

  static List<String> generarListaEdicion(List<Edicion> value) {
    List<String> lista = new List<String>();

    for (int i = 0; i < value.length; i++) {
      lista.add("ED" + value[i].numero);
    }
    return lista;
  }

  static List<String> generaListaAnios(List<Edicion> listaEdicion) {
    List<String> lista = new List<String>();
    for (int i = 0; i < listaEdicion.length; i++) {
      Edicion edicion = listaEdicion[i];
      String anio = Utilidades.getAnio(edicion.fechaFin);
      if (anio != "") {
        if (lista.length > 0) {
          for (int j = 0; j < lista.length; j++) {
            if (Util.checkInteger(anio) == Util.checkInteger(lista[j])) {
              break;
            } else if (Util.checkInteger(anio) != Util.checkInteger(lista[j])) {
              lista.add(anio);
              break;
            }
          }
        } else {
          lista.add(anio);
        }
      }
    }
    return lista;
  }

  static String generarLetras(
      {@required String letra1, @required String letra2}) {
    String letra = "";
    if (letra1 != null) {
      if (letra1.length > 0) {
        letra = letra1.substring(0, 1);
      } else {
        letra = "E";
      }
    } else {
      letra = "E";
    }
    if (letra2 != null) {
      if (letra2.length > 0) {
        letra += letra2.substring(0, 1);
      } else {
        letra += "E";
      }
    } else {
      letra += "E";
    }
    return letra.toUpperCase();
  }

  static String generarIcono(
      {@required String letra1, @required String letra2}) {
    String letra = "";
    if (letra1 != null) {
      if (letra1.length > 0) {
        letra = letra1.substring(0, 1);
      } else {
        letra = letra + "" + "E";
      }
    } else {
      letra = letra + "" + "E";
    }
    if (letra2 != null) {
      if (letra2.length > 0) {
        letra = letra + "" + letra2.substring(0, 1);
      } else {
        letra = letra + "" + "E";
      }
    } else {
      letra = letra + "" + "E";
    }
    return letra.toUpperCase();
  }

  static DateTime formatDateTime({String fecha}) {
    if (fecha == null || fecha == "") {
      return DateTime.now();
    }
    DateTime tm = DateTime.parse(fecha);

    return tm;
  }

  static String formatFecha({DateTime dateTime}) {
    if (dateTime == null) {
      return "";
    }

    String mes, anio, dia, hora, minuto = "";
    mes = dateTime.month.toString();
    dia = dateTime.day.toString();
    hora = dateTime.hour.toString();
    minuto = dateTime.minute.toString();
    anio = dateTime.year.toString();

    if (Util.checkInteger(mes) < 10) {
      mes = "0" + mes;
    }
    if (Util.checkInteger(dia) < 10) {
      dia = "0" + dia;
    }
    if (Util.checkInteger(hora) < 10) {
      hora = "0" + hora;
    }
    if (Util.checkInteger(minuto) < 10) {
      minuto = "0" + minuto;
    }
    String fecha = anio + "-" + mes + "-" + dia + " " + hora + ":" + minuto;

    return fecha;
  }

  static String obtenerPalabras(
      {@required String letra, @required int cantidad}) {
    String convertidor = "";
    if (letra.length > cantidad) {
      convertidor = letra.substring(0, cantidad - 2);
      convertidor = convertidor + "..";
    } else {
      convertidor = letra;
    }
    return convertidor;
  }

  static ColorHome obtenerColorRandom() {
    List<ColorHome> lista = new List<ColorHome>();
    ColorHome colorHome = ColorHome(Color(0xfFFF0000), Color(0xFFFB7883));
    lista.add(colorHome);

    ColorHome colorHome1 = ColorHome(Color(0xff0072ff), Color(0xFFDFDAD9));
    lista.add(colorHome1);

    ColorHome colorHome2 = ColorHome(Color(0xfF03C3CC), Color(0xFFE6EBE1));
    lista.add(colorHome2);

    ColorHome colorHome3 = ColorHome(Color(0xfF7A2BFF), Color(0xFFD7D3DA));
    lista.add(colorHome3);

    ColorHome colorHome4 = ColorHome(Color(0xfF515C6F), Color(0xFFD1CFD8));
    lista.add(colorHome4);

    ColorHome colorHome5 = ColorHome(Color(0xFFFB7883), Color(0xFFD1CFD8));
    lista.add(colorHome5);

    ColorHome colorHome6 = ColorHome(Color(0xFFFC466B), Color(0xFF3F5EFB));
    lista.add(colorHome6);

    int random = Random().nextInt(lista.length);
    return lista[random];
  }

  static Color obtenerColorRandomSolo() {
    List<ColorHome> lista = new List<ColorHome>();
    ColorHome colorHome = ColorHome(Color(0xFF3D82AE), Color(0xFFFB7883));
    lista.add(colorHome);

    ColorHome colorHome1 = ColorHome(Color(0xFFD3A984), Color(0xFFDFDAD9));
    lista.add(colorHome1);

    ColorHome colorHome2 = ColorHome(Color(0xFFC96071), Color(0xFFE6EBE1));
    lista.add(colorHome2);

    ColorHome colorHome3 = ColorHome(Color(0xFFE6B398), Color(0xFFD7D3DA));
    lista.add(colorHome3);

    ColorHome colorHome4 = ColorHome(Color(0xFF00FF0C), Color(0xFFD1CFD8));
    lista.add(colorHome4);

    int random = Random().nextInt(lista.length);
    return lista[random].color1;
  }

  static Future<bool> verificarConexionInternet() async {
    try {
      final result = await InternetAddress.lookup("google.com");
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } on SocketException catch (_) {
      return false;
    }
  }

  static dynamic formarIcono({@required Color color}) async {
    final iconData = Icons.place;
    final pictureRecorder = PictureRecorder();
    final canvas = Canvas(pictureRecorder);
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    final iconStr = String.fromCharCode(iconData.codePoint);
    textPainter.text = TextSpan(
        text: iconStr,
        style: TextStyle(
          letterSpacing: 0.0,
          fontSize: 48.0,
          fontFamily: iconData.fontFamily,
          color: color,
        ));
    textPainter.layout();
    textPainter.paint(canvas, Offset(0.0, 0.0));

    final picture = pictureRecorder.endRecording();
    final image = await picture.toImage(48, 48);
    final bytes = await image.toByteData(format: ImageByteFormat.png);

    final bitmapDescriptor =
        BitmapDescriptor.fromBytes(bytes.buffer.asUint8List());
    return bitmapDescriptor;
  }
}
