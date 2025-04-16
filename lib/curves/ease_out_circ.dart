import 'dart:math';

import 'package:flutter/animation.dart';

class CustomEaseOutCircCurve extends Curve {
  final double scale;
  const CustomEaseOutCircCurve({required this.scale});

  @override
  double transformInternal(double t) {
    return ((1 - scale) * (1 - sqrt(1 - pow(t, 2))) + scale);
  }
}