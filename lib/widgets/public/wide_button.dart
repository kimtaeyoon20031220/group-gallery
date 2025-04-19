import 'package:flutter/material.dart';
import 'package:group_gallery/animations/doridori.dart';
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
    this.textStyle = const TextStyle(color: Colors.white),
    this.inactiveText,
    this.height = 50,
    this.borderRadius = 13,
    this.pressedColor = CustomColor.blackLightest,
    this.pressedColorOpacity = 0.1
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
  final String? inactiveText;
  final double height;
  final double borderRadius;
  final Color pressedColor;
  final double pressedColorOpacity;

  @override
  Widget build(BuildContext context) {
    final GlobalKey<DoridoriState> doridoriKey = GlobalKey<DoridoriState>();
    return ScalableButton(
      onTap: () {
        if (isActivate) {
          onTap?.call();
        } else {
          doridoriKey.currentState?.shake();
        }
      },
      button: (tapDown) => Doridori(
        key: doridoriKey,
        child: Stack(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(borderRadius),
                  color: pointColor.withOpacity(isActivate ? 1 : 0.5)
              ),
              width: double.infinity,
              height: height,
              child: Stack(
                children: [
                  Center(
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 50),
                      opacity: isActivate ? 1 : 0,
                      child: Text(
                          text,
                          style: style[TextType.subhead]?.merge(textStyle)
                      ),
                    ),
                  ),
                  Center(
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 50),
                      opacity: !isActivate ? 1 : 0,
                      child: Text(
                          (inactiveText != null) ? inactiveText! : text,
                          style: style[TextType.subhead]?.merge(textStyle)
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ButtonDarken(tapDown: tapDown, color: pressedColor, opacity: pressedColorOpacity)
          ],
        ),
      ),
    );
  }
}