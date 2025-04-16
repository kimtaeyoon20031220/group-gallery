import 'package:flutter/material.dart';
import 'package:group_gallery/widgets/public/colors.dart';

class ButtonDarken extends StatelessWidget {
  const ButtonDarken({
    super.key,
    this.duration = const Duration(milliseconds: 100),
    this.color = CustomColor.blackLightest,
    this.opacity = 0.1,
    this.borderRadius = 13,
    required this.tapDown
  });
  final Duration duration;
  final Color color;
  final double opacity;
  final double borderRadius;
  final bool tapDown;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
        child: AnimatedContainer(
          duration: duration,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              color: color.withOpacity(tapDown ? opacity : 0)
          ),
        )
    );
  }
}
