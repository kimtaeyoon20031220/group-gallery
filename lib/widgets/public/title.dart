import 'package:flutter/material.dart';
import 'package:group_gallery/widgets/public/scalable_button.dart';
import 'package:group_gallery/widgets/public/text.dart';

class TitleBlock extends StatelessWidget {
  const TitleBlock({super.key, required this.textType, required this.title});
  final TextType textType;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(30, 30, 30, 20),
      child: Row(
        children: [
          StyleText(textType: textType, text: title, maxLines: 1,),
        ],
      )
    );
  }
}

class TitleIconBlock extends StatelessWidget {
  const TitleIconBlock({super.key, required this.textType, required this.title, required this.icon});
  final TextType textType;
  final String title;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(30, 30, 30, 20),
      child: Row(
        spacing: 10,
        children: [
          icon,
          StyleText(textType: textType, text: title, maxLines: 1,),
        ]
      )
    );
  }
}

class TitleIconButtonsBlock extends StatelessWidget {
  const TitleIconButtonsBlock({super.key, required this.textType, required this.title, required this.buttons, required this.buttonsOnPress});
  final TextType textType;
  final Widget title;
  final List<Widget> buttons;
  final List<Function> buttonsOnPress;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(30, 0, 30, 0),
      child: Row(
        children: [
          Expanded(
            child: title
          ),
          SizedBox(
            child: Row(
              children: [
                for (int i = 0; i < buttons.length; i++) ScalableButton(
                    button: (tapDown) => Container(
                      padding: const EdgeInsets.all(10),
                      child: buttons[i]
                    ),
                    onTap: ()
                    {
                      buttonsOnPress[i]();
                    }
                )
              ]
            )
          )
        ],
      )
    );
  }
}

