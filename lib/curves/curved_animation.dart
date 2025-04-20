import 'package:animations/animations.dart';
import 'package:flutter/animation.dart';

class CustomBezierCurve extends Curve {
  final Cubic cubic;
  
  CustomBezierCurve(double x1, double y1, double x2, double y2)
    : cubic = Cubic(x1, y1, x2, y2);
  
  @override
  double transform(double t) => cubic.transform(t);
}

abstract final class CustomCurves {
  static const Curve bounceOut = Cubic(0.14, 1.22, 0.89, 1.13);
  static const Curve bounceIn = Cubic(0.45, -0.24, 1, 0.51);
}