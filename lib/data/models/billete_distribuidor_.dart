import 'package:flutter/material.dart';
import 'package:proyect_nortenio_app/data/models/edicion.dart';
import 'package:proyect_nortenio_app/data/models/usuario.dart';
import 'package:proyect_nortenio_app/data/models/zona.dart';
import 'package:proyect_nortenio_app/utils/colores.dart';
import 'package:proyect_nortenio_app/utils/util.dart';

import 'billete_punto_venta.dart';

class BilleteDistribuidor {
  final int id, estado;
  final Zona zona;
  final Edicion edicion;
  final Usuario usuario;
  final String precioBilleteExtraviado,
      reciboInicial,
      reciboFinal,
      fechaFin,
      cantidadVendida,
      cantidadDevuelto,
      porcentajeDescuento,
      precioBillete;
  List<BilletePuntoVenta> listaBilletePuntoVenta;

  BilleteDistribuidor({
    this.id,
    this.estado = 1,
    this.zona,
    this.cantidadDevuelto,
    this.edicion,
    this.reciboInicial = "",
    this.reciboFinal = "",
    this.precioBillete = "",
    this.precioBilleteExtraviado = "",
    this.usuario,
    this.listaBilletePuntoVenta,
    this.fechaFin = "",
    this.cantidadVendida = "",
    this.porcentajeDescuento = "",
  });

  BilleteDistribuidor copyWith(
      {int id,
      Zona zona,
      Edicion edicion,
      String fechaFin,
      String reciboInicial,
      String cantidadDevuelto,
      String reciboFinal,
      String cantidadVendida,
      String cantidadExtraviada,
      String porcentajeDescuento,
      String montoVendido,
      String montoPagado,
      String precioBilleteExtraviado,
      String precioBillete,
      Usuario usuario,
      List<BilletePuntoVenta> listaBilletePuntoVenta}) {
    return BilleteDistribuidor(
      id: id ?? this.id,
      usuario: usuario ?? this.usuario,
      cantidadDevuelto: cantidadDevuelto ?? this.cantidadDevuelto,
      listaBilletePuntoVenta:
          listaBilletePuntoVenta ?? this.listaBilletePuntoVenta,
      precioBilleteExtraviado:
          precioBilleteExtraviado ?? this.precioBilleteExtraviado,
      reciboFinal: reciboFinal ?? this.reciboFinal,
      precioBillete: precioBillete ?? this.precioBillete,
      reciboInicial: reciboInicial ?? this.reciboInicial,
      zona: zona ?? this.zona,
      edicion: edicion ?? this.edicion,
      fechaFin: fechaFin ?? this.fechaFin,
      cantidadVendida: cantidadVendida ?? this.cantidadVendida,
      porcentajeDescuento: porcentajeDescuento ?? this.porcentajeDescuento,
    );
  }

  factory BilleteDistribuidor.fromJson(Map jsonData) {
    return BilleteDistribuidor(
      id: jsonData['id'] ?? "",
      zona: Zona.fromJson(jsonData['zona']),
      edicion: Edicion.fromJson(jsonData['edicion']),
      precioBillete: Util.checkString(jsonData['precio_billete']),
      precioBilleteExtraviado:
          Util.checkString(jsonData['precio_billete_extraviado']),
      fechaFin: Util.checkString(jsonData['fecha_fin']),
      cantidadVendida: Util.checkString(jsonData['cantidad_vendida']),
      cantidadDevuelto: Util.checkString(jsonData['cantidad_devuelto']),
      porcentajeDescuento: Util.checkString(jsonData['porcentaje_descuento']),
      reciboFinal: Util.checkString(jsonData['recibo_final']),
      reciboInicial: Util.checkString(jsonData['recibo_inicial']),
    );
  }

  void setListaBilletePuntoVenta(List<BilletePuntoVenta> lista) {
    this.listaBilletePuntoVenta = lista;
  }

  String generarTitutloBilletes() {
    return reciboInicial + " Hasta " + reciboFinal;
  }

  String calcularTotalBoletos() {
    int rinicial = Util.checkInteger(reciboInicial);
    int rfinal = Util.checkInteger(reciboFinal);
    int suma = rfinal - rinicial;

    return suma.toString();
  }

  String calcularCantidadDevuelto() {
    int suma = 0;
    for (int i = 0; i < listaBilletePuntoVenta.length; i++) {
      BilletePuntoVenta billetePuntoVenta = listaBilletePuntoVenta[i];
      suma += Util.checkInteger(billetePuntoVenta.cantidadDevuelto);
    }

    return suma.toString();
  }

  String calcularCantidadVendido() {
    int suma = 0;
    for (int i = 0; i < listaBilletePuntoVenta.length; i++) {
      BilletePuntoVenta billetePuntoVenta = listaBilletePuntoVenta[i];
      suma += Util.checkInteger(billetePuntoVenta.cantidadVendida);
    }

    return suma.toString();
  }

  String calcularMontoVendido() {
    String cantidadVendida = calcularCantidadVendido();

    int reciboInicial = Util.checkInteger(cantidadVendida);
    int reciboFinal = Util.checkInteger(precioBillete);

    String texto = "0";
    if (reciboInicial > 0 && reciboFinal > 0) {
      int monto = reciboFinal * reciboInicial;
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

  String calcularCantidadExtraviado() {
    String cantidadEntregada = calcularTotalBoletos();
    String cantidadDevuelto = calcularCantidadDevuelto();
    String cantidadVendida = calcularCantidadVendido();

    int reciboInicial = Util.checkInteger(cantidadEntregada);

    int reciboDevuelto = Util.checkInteger(cantidadDevuelto);

    int reciboFinal = Util.checkInteger(cantidadVendida);
    String texto = "0";
    if (reciboInicial > 0 && reciboFinal > 0) {
      int cantidad = reciboInicial - (reciboFinal + reciboDevuelto);
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

    int reciboInicial = Util.checkInteger(montoVendido);
    int reciboFinal = Util.checkInteger(porcentaje);
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

  String calcularEstado() {
    return estado == 1 ? "Activo" : "Pagado";
  }

  String calcularMontoExtraviado() {
    String cantidadExtraviado = calcularCantidadExtraviado();
    String montoBilleteExtraviado = this.precioBilleteExtraviado;

    int reciboInicial = Util.checkInteger(cantidadExtraviado);

    int reciboFinal = Util.checkInteger(montoBilleteExtraviado);

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

    double aExtraviado = Util.checkDouble(extraviado);
    double aPorcentaje = Util.checkDouble(porcentaje);

    double suma = aPorcentaje - aExtraviado;

    return suma.toString();
  }

  String generarEstado() {
    return estado == 1 ? "Entregado" : "Ninguno";
  }

  Color generarEstadoColor() {
    return estado == 1 ? Colores.colorBody : Colores.colorRojo;
  }
}
