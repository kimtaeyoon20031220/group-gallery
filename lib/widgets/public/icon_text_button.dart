import 'package:flutter/material.dart';
import 'package:group_gallery/widgets/public/button_darken.dart';
import 'package:group_gallery/widgets/public/colors.dart';
import 'package:group_gallery/widgets/public/scalable_button.dart';
import 'package:group_gallery/widgets/public/text.dart';

class IconTextButton extends StatelessWidget {
  const IconTextButton({
    super.key,
    required this.icon,
    required this.text,
    this.textStyle,
    required this.onTap,
    this.padding = const EdgeInsets.fromLTRB(15, 10, 15, 10),
    this.shadowColor = CustomColor.black,
    this.borderRadius = 13,
    this.opacity = 0.2
  });

  final Widget icon;
  final String text;
  final TextStyle? textStyle;
  final Function() onTap;
  final EdgeInsets padding;
  final Color shadowColor;
  final double borderRadius;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return ScalableButton(
      button: (tapDown) => Stack(
        children: [
          Padding(
              padding: padding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 3,
                children: [
                  icon,
                  Text(text, style: (textStyle == null) ? style[TextType.footnote]?.merge(TextStyle(color: CustomColor.greyLightest)) : textStyle)
                ],
              )
          ),
          ButtonDarken(tapDown: tapDown, color: shadowColor, borderRadius: borderRadius, opacity: opacity)
        ],
      ),
      onTap: onTap,
    );
  }
}
