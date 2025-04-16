import 'package:flutter/material.dart';

import '../../curves/ease_in_circ.dart';
import '../../curves/ease_out_circ.dart';

class ScalableButton extends StatefulWidget {
  const ScalableButton({
    super.key,
    this.duration = const Duration(milliseconds: 100),
    this.reverseDuration = const Duration(milliseconds: 200),
    this.scale = 0.93,
    required this.button,
    required this.onTap
  });
  final Duration duration;
  final Duration reverseDuration;
  final Widget Function(bool tapDown)? button;
  final double scale;
  final Function() onTap;

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
        curve: Curves.easeOutCirc,
        reverseCurve: Curves.easeInCirc
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
        color: Colors.transparent,
        child: Stack(
          children: [
            widget.button!(tapDown),
            Positioned.fill(
              child: GestureDetector(
                onTapDown: _onTapDown,
                onTapUp: _onTapUp,
                onTapCancel: _onTapCancel,
                behavior: HitTestBehavior.translucent,
                child: const SizedBox.expand(), // 전면 터치 처리
              ),
            ),
          ],
        ),
      ),
    );
  }
}