class Configuracion {
  int id, estado;
  final String precioBillete, porcentajeDescuento, precioBilleteExtraviado;

  Configuracion({
    this.id,
    this.precioBillete,
    this.estado,
    this.porcentajeDescuento,
    this.precioBilleteExtraviado,
  });

  static Configuracion initialState() => Configuracion(
        id: 1,
        precioBillete: "10",
        porcentajeDescuento: "10",
        precioBilleteExtraviado: "10",
      );
  Configuracion copyWith({
    int id,
    String estado,
    String precioBoleta,
    String porcentajeDescuento,
    String montoBilleteExtraviado,
  }) {
    return Configuracion(
      id: id ?? this.id,
      precioBillete: precioBoleta ?? this.precioBillete,
      precioBilleteExtraviado:
          montoBilleteExtraviado ?? this.precioBilleteExtraviado,
      estado: estado ?? this.estado,
      porcentajeDescuento: porcentajeDescuento ?? this.porcentajeDescuento,
    );
  }

  factory Configuracion.fromJson(Map jsonData) {
    return Configuracion(
      id: jsonData['id'] ?? "",
      precioBillete: jsonData['precio_billete'],
      precioBilleteExtraviado: jsonData['precio_billete_extraviado'],
      estado: jsonData['estado'],
      porcentajeDescuento: jsonData['porcentaje_descuento'],
    );
  }
}
