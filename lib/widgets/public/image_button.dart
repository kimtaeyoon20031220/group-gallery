import 'package:flutter/material.dart';
import 'package:group_gallery/widgets/public/colors.dart';
import 'package:group_gallery/widgets/public/scalable_button.dart';

class ImageButton extends StatelessWidget {
  const ImageButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.padding = const EdgeInsets.all(10),
    this.shadowColor = CustomColor.black,
    this.borderRadius = 13,
    this.opacity = 0.2
  });

  final Widget icon;
  final Function() onTap;
  final EdgeInsets padding;
  final Color shadowColor;
  final double borderRadius;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return ScalableButton(
      buttonColor: Colors.transparent,
      button: (tapDown) => Stack(
        children: [
          Padding(
            padding: padding,
            child: Center(child: icon)
          ),
        ],
      ),
      onTap: onTap,
    );
  }
}
