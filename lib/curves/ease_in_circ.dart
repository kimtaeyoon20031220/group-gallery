import 'dart:math';

import 'package:flutter/animation.dart';
import 'package:logger/logger.dart';

class CustomEaseInCircCurve extends Curve {
  final double scale;
  const CustomEaseInCircCurve({required this.scale});

  @override
  double transformInternal(double t) {
    double result = ((1 - scale) * sqrt(1 - pow(t - 1, 2)) * scale);
    var logger = Logger(printer: PrettyPrinter(methodCount: 0));
    logger.d(result);
    return result;
  }
}