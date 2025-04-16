import 'package:flutter/material.dart';
import 'package:group_gallery/widgets/public/button_darken.dart';
import 'package:group_gallery/widgets/public/colors.dart';
import 'package:group_gallery/widgets/public/scalable_button.dart';
import 'package:group_gallery/widgets/public/text.dart';

class WideButton extends StatelessWidget {
  const WideButton({
    super.key,
    required this.text,
    this.isActivate = true,
    this.onTap,
    this.tapDown = false,
    this.duration = const Duration(milliseconds: 100),
    this.reverseDuration = const Duration(milliseconds: 200),
    this.scale = 0.93,
    this.pointColor = CustomColor.blue,
    this.textStyle = const TextStyle(color: Colors.white)
  });
  final bool isActivate;
  final String text;
  final Function? onTap;
  final bool tapDown;
  final Duration duration;
  final Duration reverseDuration;
  final double scale;
  final Color pointColor;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return ScalableButton(
      onTap: () {
        onTap?.call();
      },
      button: (tapDown) => Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(13),
              color: pointColor
            ),
            width: double.infinity,
            height: 50,
            child: Center(
              child: Text(
                text,
                style: style[TextType.subhead]?.merge(textStyle)
              ),
            ),
          ),

          ButtonDarken(tapDown: tapDown)
        ],
      ),
    );
  }
}
