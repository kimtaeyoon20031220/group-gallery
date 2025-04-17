import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:group_gallery/widgets/public/image_button.dart';
import 'package:group_gallery/widgets/public/text.dart';

class EditText extends StatelessWidget {
  const EditText({
    super.key,
    this.hint = "",
    this.hintColor = const Color(0x77ffffff),
    this.textColor = const Color(0xffffffff),
    this.obscureText = false,
    this.backgroundColor = const Color(0xff41434D),
    this.keyboardType = TextInputType.none,
    required this.controller,
    this.focusNode,
    this.onComplete
  });

  final String hint;
  final Color hintColor;
  final Color textColor;
  final bool obscureText;
  final Color backgroundColor;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final Function()? onComplete;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(13),
        color: backgroundColor
      ),
      padding: const EdgeInsets.fromLTRB(15, 5, 10, 5),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: TextField(
              focusNode: (focusNode != null) ? focusNode! : null,
              style: style[TextType.subhead]?.merge(TextStyle(color: textColor)),
              obscureText: obscureText,
              keyboardType: keyboardType,
              cursorColor: textColor,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hint,
                hintStyle: style[TextType.subhead]?.merge(TextStyle(color: hintColor))
              ),
              controller: controller,
            ),
          ),
          (onComplete != null) ? ImageButton(
            padding: const EdgeInsets.all(7),
            onTap: onComplete!,
            icon: SvgPicture.asset("assets/icons/arrow-right-circle.svg", width: 25)
          )
           : SizedBox()
        ],
      ),
    );
  }
}
