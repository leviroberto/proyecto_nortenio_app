import 'package:flutter/material.dart';
import 'package:proyect_nortenio_app/data/models/edicion.dart';
import 'package:proyect_nortenio_app/data/models/punto_venta.dart';
import 'package:proyect_nortenio_app/data/models/usuario.dart';
import 'package:proyect_nortenio_app/data/models/zonaMotorizado.dart';
import 'package:proyect_nortenio_app/utils/colores.dart';
import 'package:proyect_nortenio_app/utils/util.dart';

class BilletePuntoVenta {
  final int id, estado;
  final PuntoVenta puntoVenta;
  final ZonaMotorizado zonaMotorizado;
  final Edicion edicion;
  final Usuario usuario;
  final String fechaInicioEntrega,
      fechaInicioRecojo,
      fechaIFinRecojo,
      fechaFinEntrega,
      reciboInicial,
      reciboFinal,
      precioBilleteExtraviado,
      cantidadVendida,
      cantidadDevuelto,
      cantidadExtraviada,
      porcentajeDescuento,
      precioBillete;

  final List<BilletePuntoVenta> listaBilletePuntoVenta;

  BilletePuntoVenta({
    this.id,
    this.estado = 1,
    this.puntoVenta,
    this.zonaMotorizado,
    this.cantidadDevuelto,
    this.edicion,
    this.reciboInicial = "",
    this.fechaIFinRecojo = "",
    this.fechaInicioRecojo = "",
    this.fechaInicioEntrega = "",
    this.fechaFinEntrega = "",
    this.precioBilleteExtraviado = "",
    this.reciboFinal = "",
    this.precioBillete = "",
    this.usuario,
    this.listaBilletePuntoVenta,
    this.cantidadVendida = "",
    this.cantidadExtraviada = "",
    this.porcentajeDescuento = "",
  });

  BilletePuntoVenta copyWith({
    int id,
    int estado,
    PuntoVenta puntoVenta,
    Edicion edicion,
    cantidadDevuelto,
    String fechaFin,
    String fechaFinEntrega,
    String fechaInicioEntrega,
    String reciboInicial,
    String reciboFinal,
    String cantidadVendida,
    String cantidadExtraviada,
    String porcentajeDescuento,
    String montoVendido,
    String montoPagado,
    String montoBillete,
    String precioBillete,
    String fechaEntrega,
    String fechaRecojo,
    String fechaIFinRecojo,
    String fechaInicioRecojo,
    ZonaMotorizado zonaMotorizado,
    String precioBilleteExtraviado,
    List<BilletePuntoVenta> listaBilletePuntoVenta,
    Usuario usuario,
  }) {
    return BilletePuntoVenta(
      id: id ?? this.id,
      estado: estado ?? this.estado,
      cantidadDevuelto: cantidadDevuelto ?? this.cantidadDevuelto,
      zonaMotorizado: zonaMotorizado ?? this.zonaMotorizado,
      fechaFinEntrega: fechaFinEntrega ?? this.fechaFinEntrega,
      fechaInicioRecojo: fechaInicioRecojo ?? this.fechaInicioRecojo,
      fechaIFinRecojo: fechaIFinRecojo ?? this.fechaIFinRecojo,
      fechaInicioEntrega: fechaInicioEntrega ?? this.fechaInicioEntrega,
      usuario: usuario ?? this.usuario,
      precioBillete: precioBillete ?? this.precioBillete,
      listaBilletePuntoVenta:
          listaBilletePuntoVenta ?? this.listaBilletePuntoVenta,
      precioBilleteExtraviado:
          precioBilleteExtraviado ?? this.precioBilleteExtraviado,
      reciboFinal: reciboFinal ?? this.reciboFinal,
      reciboInicial: reciboInicial ?? this.reciboInicial,
      puntoVenta: puntoVenta ?? this.puntoVenta,
      edicion: edicion ?? this.edicion,
      cantidadVendida: cantidadVendida ?? this.cantidadVendida,
      cantidadExtraviada: cantidadExtraviada ?? this.cantidadExtraviada,
      porcentajeDescuento: porcentajeDescuento ?? this.porcentajeDescuento,
    );
  }

  factory BilletePuntoVenta.fromJson(Map jsonData) {
    return BilletePuntoVenta(
      id: jsonData['id'] ?? "",
      puntoVenta: PuntoVenta.fromJson(jsonData['puntoVenta']),
      zonaMotorizado: ZonaMotorizado.fromJson(jsonData['zonaMotorizado']),
      edicion: Edicion.fromJson(jsonData['edicion']),
      fechaFinEntrega: Util.checkString(jsonData['fecha_fin_entrega']),
      fechaInicioEntrega: Util.checkString(jsonData['fecha_inicio_entrega']),
      fechaInicioRecojo: Util.checkString(jsonData['fecha_inicio_recojo']),
      fechaIFinRecojo: Util.checkString(jsonData['fecha_fin_recojo']),
      precioBilleteExtraviado:
          Util.checkString(jsonData['precio_billete_extraviado']),
      precioBillete: Util.checkString(jsonData['precio_billete']),
      cantidadVendida: Util.checkString(jsonData['cantidad_vendida']),
      cantidadDevuelto: Util.checkString(jsonData['cantidad_devuelto']),
      cantidadExtraviada: Util.checkString(jsonData['cantidad_extraviada']),
      porcentajeDescuento: Util.checkString(jsonData['porcentaje_descuento']),
      reciboFinal: Util.checkString(jsonData['recibo_final']),
      reciboInicial: Util.checkString(jsonData['recibo_inicial']),
      estado: Util.checkInteger(jsonData['estado']),
    );
  }

  Map toJson() {
    return {
      'id': id,
      'puntoVenta': puntoVenta.toJson(),
      'zonaMotorizado': zonaMotorizado.toJson(),
      'edicion': edicion.toJson(),
      'fecha_fin_entrega': fechaFinEntrega,
      'fecha_inicio_entrega': fechaInicioEntrega,
      'fecha_inicio_recojo': fechaInicioRecojo,
      'fecha_fin_recojo': fechaIFinRecojo,
      'precio_billete_extraviado': precioBilleteExtraviado,
      'precio_billete': precioBillete,
      'cantidad_vendida': cantidadVendida,
      'cantidad_devuelto': cantidadDevuelto,
      'cantidad_extraviada': cantidadExtraviada,
      'porcentaje_descuento': porcentajeDescuento,
      'recibo_final': reciboFinal,
      'recibo_inicial': reciboInicial,
      'estado': estado,
    };
  }

  String calcularTotalBoletos() {
    int rinicial = int.parse(reciboInicial);
    int rfinal = int.parse(reciboFinal);
    int suma = rfinal - rinicial;

    return suma.toString();
  }

  String calcularMontoVendido() {
    int uno = cantidadVendida == "" ? 0 : int.parse(cantidadVendida);
    int dos = precioBillete == "" ? 0 : int.parse(precioBillete);
    String texto = "0";
    if (uno > 0 && dos > 0) {
      int monto = dos * uno;
      if (monto > 0) {
        texto = monto.toString();
      } else {
        texto = "0";
      }
    } else {
      texto = "0";
    }
    return texto;
  }

  String calcularTotalExtraviado() {
    String cantidadEntregada = calcularTotalBoletos();
    String cantidadDevueltoa = cantidadDevuelto;
    String cantidadVendidaa = cantidadVendida;

    int reciboIniciala =
        cantidadEntregada == "" ? 0 : int.parse(cantidadEntregada);
    int reciboDevuelto =
        cantidadDevueltoa == "" ? 0 : int.parse(cantidadDevueltoa);
    int reciboFinal = cantidadVendidaa == "" ? 0 : int.parse(cantidadVendidaa);
    String texto = "0";
    if (reciboIniciala > 0 && reciboFinal > 0) {
      int cantidad = reciboIniciala - (reciboFinal + reciboDevuelto);
      if (cantidad > 0) {
        texto = cantidad.toString();
      } else {
        texto = "0";
      }
    } else {
      texto = "0";
    }

    return texto;
  }

  String calcularMontoPorcentaje() {
    String montoVendido = calcularMontoVendido();
    String porcentaje = porcentajeDescuento;

    int reciboInicial = montoVendido == "" ? 0 : int.parse(montoVendido);
    int reciboFinal = porcentaje == "" ? 0 : int.parse(porcentaje);
    String texto = "0";
    if (reciboInicial > 0 && reciboFinal > 0) {
      double monto = (reciboFinal * reciboInicial) / 100;
      if (monto > 0) {
        texto = monto.toString();
      } else {
        texto = "0";
      }
    } else {
      texto = "0";
    }

    return texto;
  }

  String calcularMontoExtraviado() {
    String cantidadExtraviado = calcularTotalExtraviado();
    String montoBilleteExtraviado = precioBilleteExtraviado;

    int reciboInicial =
        cantidadExtraviado == "" ? 0 : int.parse(cantidadExtraviado);
    int reciboFinal =
        montoBilleteExtraviado == "" ? 0 : int.parse(montoBilleteExtraviado);

    String texto = "0";
    if (reciboInicial > 0 && reciboFinal > 0) {
      int cantidad = reciboInicial * reciboFinal;
      if (cantidad > 0) {
        texto = cantidad.toString();
      } else {
        texto = "0";
      }
    } else {
      texto = "0";
    }

    return texto;
  }

  String calcularMontoPagado() {
    String extraviado = calcularMontoExtraviado();
    String porcentaje = calcularMontoPorcentaje();

    double aExtraviado = extraviado == "" ? 0 : double.parse(extraviado);
    double aPorcentaje = porcentaje == "" ? 0 : double.parse(porcentaje);

    double suma = aPorcentaje - aExtraviado;

    return suma.toString();
  }

  bool estaBilleteEntregado() {
    return estado >= 2;
  }

  bool estaBilleteRecogio() {
    return estado == 3;
  }

  String generarEstado() {
    return estado == 1
        ? 'Activo'
        : estado == 2
            ? 'Entregado'
            : 'Recogido';
  }

  Color generarEstadoColor() {
    return estado == 1
        ? Colores.colorPlomo
        : estado == 2
            ? Colores.colorError
            : Colores.colorVerde;
  }

  String generarTitulo() {
    return reciboInicial + " - " + reciboFinal;
  }
}
