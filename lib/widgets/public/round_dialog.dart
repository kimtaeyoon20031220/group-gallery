import 'package:flutter/material.dart';
import 'package:group_gallery/widgets/public/colors.dart';
import 'package:group_gallery/widgets/public/scalable_button.dart';
import 'package:group_gallery/widgets/public/text.dart';
import 'package:group_gallery/widgets/public/wide_button.dart';

class RoundDialog extends StatelessWidget {
  const RoundDialog({
    super.key,
    this.title = const Text(""),
    this.content = const Text(""),
    this.acceptText,
    this.onAccept,
    this.cancelText = "닫기",
    this.onCancel,
    this.onClose,
    this.pointColor = CustomColor.blue
  });

  final Widget title;
  final Widget content;
  final String? acceptText;
  final Function()? onAccept;
  final String cancelText;
  final Function()? onCancel;
  final Function()? onClose;
  final Color pointColor;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: const EdgeInsets.fromLTRB(35, 35, 35, 0),
      contentPadding: const EdgeInsets.fromLTRB(35, 10, 35, 35),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25)
      ),
      title: title,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 35),
            child: content
          ),
          Row(
            children: [
              Flexible(
                child: WideButton(
                  text: cancelText,
                  pointColor: (acceptText != null) ? CustomColor.greyLightest : pointColor,
                  textStyle: style[TextType.callout]!.merge(TextStyle(color: (acceptText != null) ? CustomColor.blackLight : Colors.white)),
                  onTap: () {
                    if (onCancel != null) onCancel!();
                    if (onClose != null) onClose!();
                    Navigator.of(context, rootNavigator: true).pop('dialog');
                  },
                ),
              ),
              SizedBox(width: (acceptText != null) ? 10 : 0),
              (acceptText != null) ?
                  Flexible(
                    child: WideButton(
                      text: acceptText!,
                      pointColor: pointColor,
                      textStyle: style[TextType.callout]!.merge(TextStyle(color: Colors.white)),
                      onTap: () {
                        if (onAccept != null) onAccept!();
                        if (onClose != null) onClose!();
                        Navigator.of(context, rootNavigator: true).pop('dialog');
                      },
                    ),
                  )
                  :
                  SizedBox()
            ],
          )
        ],
      )
    );
  }
}

void showSlideDialog(BuildContext context, Widget dialog) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: "Dismiss",
    barrierColor: Colors.black54, // 배경 블러
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, anim1, anim2) {
      return const SizedBox.shrink(); // 여긴 안 씀, 아래 transitionBuilder에서 실제 UI 만듦
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );
      
      final opacityAnimation = Tween(begin: 0.0, end: 1.0);

      return FadeTransition(
        opacity: opacityAnimation.animate(animation),
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1), // 아래에서 올라오도록
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: dialog
        ),
      );
    },
  );
}