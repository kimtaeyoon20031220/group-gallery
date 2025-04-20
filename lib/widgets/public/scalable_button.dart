import 'package:flutter/material.dart';

import '../../curves/curved_animation.dart';
import '../../curves/ease_in_circ.dart';
import '../../curves/ease_out_circ.dart';
import 'colors.dart';

class ScalableButton extends StatefulWidget {
  const ScalableButton({
    super.key,
    this.duration = const Duration(milliseconds: 100),
    this.reverseDuration = const Duration(milliseconds: 200),
    this.scale = 0.9,
    required this.button,
    required this.onTap,
    this.buttonColor = Colors.transparent,
    this.borderRadius = 13,
    this.highlightColor,
    this.splashColor,
    this.hoverColor,
    this.focusColor,
    this.curve = CustomCurves.bounceOut,
    this.reverseCurve = CustomCurves.bounceIn
  });
  final Duration duration;
  final Duration reverseDuration;
  final Widget Function(bool tapDown)? button;
  final double scale;
  final Function() onTap;
  final Color buttonColor;
  final double borderRadius;
  final Color? highlightColor;
  final Color? splashColor;
  final Color? hoverColor;
  final Color? focusColor;
  final Curve curve;
  final Curve reverseCurve;

  @override
  State<ScalableButton> createState() => _ScalableButtonState();
}

class _ScalableButtonState extends State<ScalableButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  bool tapDown = false;
  bool tapCancel = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
      reverseDuration: widget.reverseDuration
    );

    _animation = Tween<double>(
      begin: 1.0,
      end: widget.scale,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: widget.curve,
        reverseCurve: widget.reverseCurve
      )
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.forward().then((_) {
      if (!tapCancel) widget.onTap();
      _controller.reverse();
      setState(() {
        tapDown = false;
      });
    });
    tapCancel = false;
  }

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _controller.forward();
      tapDown = true;
    });
  }

  void _onTapCancel() {
    tapCancel = true;
    _controller.forward().then((_) {
      _controller.reverse();
      setState(() {
        tapDown = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: Material(
        clipBehavior: Clip.hardEdge,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        color: Colors.transparent,
        child: InkWell(
          highlightColor: widget.highlightColor,
          splashColor: widget.splashColor,
          hoverColor: widget.hoverColor,
          focusColor: widget.focusColor,
          onTapDown: _onTapDown,
          onTapUp: _onTapUp,
          onTapCancel: _onTapCancel,
          child: Ink(
            decoration: BoxDecoration(
              color: widget.buttonColor,
              borderRadius: BorderRadius.circular(widget.borderRadius)
            ),
            child: widget.button!(tapDown))
        ),
      ),
    );
  }
}