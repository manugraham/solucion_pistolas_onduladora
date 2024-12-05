import 'package:flutter/cupertino.dart';
import 'dart:math' as math;

class Responsive {
  double? _width, _height, _diagonal;

  double? get width => _width;
  double? get height => _height;
  double? get diagonal => _diagonal;

  static Responsive of(BuildContext context) => Responsive(context);

  Responsive(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    _width = size.width;
    _height = size.height;
    _diagonal = math.sqrt(math.pow(_width!, 2) + math.pow(_height!, 2));

    //c2 + a2 + b2 => c=srt(a2+b2)
  }

  double anchoPorc(double porcentaje) => _width! * porcentaje / 100;
  double altoPorc(double porcentaje) => _height! * porcentaje / 100;
  double diagonalPorc(double porcentaje) => _diagonal! * porcentaje / 100;
}
