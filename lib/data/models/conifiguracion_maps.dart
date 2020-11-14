import 'package:proyect_nortenio_app/utils/util.dart';

class ConfiguracionMap {
  String zona, anio, mes, edicion;

  ConfiguracionMap(
      {this.zona = "", this.anio = "", this.mes = "", this.edicion = ""});

  factory ConfiguracionMap.fromJson(Map jsonData) {
    return ConfiguracionMap(
      zona: Util.checkString(jsonData['zona']),
      anio: Util.checkString(jsonData['anio']),
      mes: Util.checkString(jsonData['mes']),
      edicion: Util.checkString(jsonData['edicion']),
    );
  }

  // method
  Map toJson() {
    return {
      'zona': zona,
      'anio': anio,
      'mes': mes,
      'edicion': edicion,
    };
  }
}
