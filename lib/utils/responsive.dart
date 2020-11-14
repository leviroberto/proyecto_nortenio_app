import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'dart:math' as math;

class Responsive {
  final double width, height, diagonal;

  Responsive({
    @required this.width,
    @required this.height,
    @required this.diagonal,
  });

  factory Responsive.of(BuildContext context) {
    final MediaQueryData data = MediaQuery.of(context);
    final size = data.size;
    //a^{2}+b^{2}=c^{2},
    final diagonal =
        math.sqrt(math.pow(size.width, 2) + math.pow(size.height, 2));
    return Responsive(
        width: size.width, height: size.height, diagonal: diagonal);
  }
  double widthPercent(double percent) {
    return this.width * percent / 100;
  }

  double heightPercent(double percent) {
    return this.height * percent / 100;
  }

  double diagonalPercent(double percent) {
    return this.diagonal * percent / 100;
  }
}
