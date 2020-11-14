import 'package:proyect_nortenio_app/utils/util.dart';

class Geolocalizacion {
  int id, puntoVentasId;
  String direccion, departamento, provincia, pais, distrito;
  double latitud, longitud;

  Geolocalizacion(
      {this.id = 0,
      this.puntoVentasId = 0,
      this.direccion = "",
      this.departamento = "",
      this.provincia = "",
      this.pais = "",
      this.latitud = 0,
      this.longitud = 0,
      this.distrito = ""});

  factory Geolocalizacion.fromJson(Map jsonData) {
    return Geolocalizacion(
      id: Util.checkInteger(jsonData['id']),
      direccion: Util.checkString(jsonData['direccion']),
      departamento: Util.checkString(jsonData['departamento']),
      provincia: Util.checkString(jsonData['provincia']),
      pais: Util.checkString(jsonData['pais'] ?? ""),
      puntoVentasId: Util.checkInteger(jsonData['punto_ventas_id']),
      latitud: Util.checkDouble(jsonData['latitud']),
      longitud: Util.checkDouble(jsonData['longitud']),
      distrito: Util.checkString(jsonData['distrito']),
    );
  }

  // method
  Map toJson() {
    return {
      'id': id,
      'direccion': direccion,
      'departamento': departamento,
      'provincia': provincia,
      'pais': pais,
      'latitud': latitud,
      'longitud': longitud,
      'punto_ventas_id': puntoVentasId,
      'distrito': distrito
    };
  }
}
