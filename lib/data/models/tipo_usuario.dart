import 'package:proyect_nortenio_app/utils/util.dart';

class TipoUsuario {
  final int id, estado;
  final String descripcion;

  TipoUsuario({this.id, this.descripcion, this.estado});

  factory TipoUsuario.fromJson(Map jsonData) {
    return TipoUsuario(
      id: Util.checkInteger(jsonData['id']),
      descripcion: Util.checkString(jsonData['descripcion']),
      estado: Util.checkInteger(jsonData['estado']),
    );
  }

  Map toJson() {
    return {
      'id': id,
      'descripcion': descripcion,
      'estado': estado,
    };
  }
}
