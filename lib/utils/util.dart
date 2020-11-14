import 'package:proyect_nortenio_app/data/models/notificacion.dart';

class Util {
  static String checkString(dynamic value) {
    String cadena = "";
    if (value == null || value == "") {
      return "";
    }
    if (value is double) {
      cadena = "$value";
    } else if (value is int) {
      cadena = "$value";
    } else if (value is String) {
      cadena = "$value";
    }
    return cadena;
  }

  static int checkInteger(dynamic value) {
    int cadena = 0;
    if (value == null || value == "") {
      return 0;
    }
    if (value is int) {
      cadena = value;
    } else if (value is String) {
      cadena = int.parse(value);
    }
    return cadena;
  }

  static double checkDouble(dynamic value) {
    double cadena = 0;
    if (value == null || value == "") {
      return 0.0;
    }
    if (value is double) {
      cadena = value;
    } else if (value is String) {
      cadena = double.parse(value);
    }
    return cadena;
  }

  static String getMes() {
    DateTime tm = DateTime.now();

    String month;
    switch (tm.month) {
      case 1:
        month = "Enero";
        break;
      case 2:
        month = "febrero";
        break;
      case 3:
        month = "Marzo";
        break;
      case 4:
        month = "Abril";
        break;
      case 5:
        month = "Mayo";
        break;
      case 6:
        month = "Junio";
        break;
      case 7:
        month = "Julio";
        break;
      case 8:
        month = "Agosto";
        break;
      case 9:
        month = "Septiembre";
        break;
      case 10:
        month = "Octubre";
        break;
      case 11:
        month = "Noviembre";
        break;
      case 12:
        month = "Dicembre";
        break;
    }

    return month;
  }

  static String getDia() {
    DateTime tm = DateTime.now();

    switch (tm.weekday) {
      case 1:
        return "Lunes";
      case 2:
        return "Martes";
      case 3:
        return "Miércoles";
      case 4:
        return "Jueves";
      case 5:
        return "Viernes";
      case 6:
        return "Sábado";
      case 7:
        return "Domomingo";
    }
    return "";
  }

  static String getAnio() {
    DateTime tm = DateTime.now();

    return tm.year.toString();
  }
}
