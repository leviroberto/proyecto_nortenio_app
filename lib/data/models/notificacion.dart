import 'package:proyect_nortenio_app/utils/util.dart';

class Notificacion {
  final String title;
  final String subTitle;
  final String otro;
  final String date;
  final int estado;

  static const int TIPO_ERROR = 0;
  static const int TIPO_CORRECTO = 1;
  static const int TIPO_ADVERTENCIA = 2;

  Notificacion(
      {this.title, this.subTitle, this.date, this.estado = 0, this.otro});
  static Notificacion initialState() => Notificacion(
        title: "",
        otro: "",
        subTitle: "",
        date: "",
        estado: 0,
      );

  Notificacion copyWith({
    String subTitle,
    String title,
    String date,
    int estado,
    String otro,
  }) {
    return Notificacion(
      subTitle: subTitle ?? this.subTitle,
      title: title ?? this.title,
      date: date ?? this.date,
      estado: estado ?? this.estado,
      otro: otro ?? this.otro,
    );
  }

  factory Notificacion.fromJson(Map jsonData) {
    return Notificacion(
      title: jsonData['title'] ?? "",
      subTitle: jsonData['subTitle'] ?? "",
      date: jsonData['date'] ?? "",
      otro: jsonData['otro'] ?? "",
      estado: Util.checkInteger(jsonData['estado']),
    );
  }

  Map toJson() {
    return {
      'title': title,
      'subTitle': subTitle,
      'date': date,
      'otro': otro,
      'estado': estado,
    };
  }
}
