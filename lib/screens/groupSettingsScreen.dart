import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:group_gallery/widgets/public/colors.dart';
import 'package:group_gallery/widgets/public/edit_text.dart';
import 'package:group_gallery/widgets/public/round_dialog.dart';
import 'package:group_gallery/widgets/public/text.dart';
import 'package:logger/logger.dart';

import '../widgets/public/button_darken.dart';
import '../widgets/public/scalable_button.dart';

class GroupSettingsScreenArgs {
  final String title;
  final String icon;

  const GroupSettingsScreenArgs({ required this.title, required this.icon });
}

class GroupSettingsScreen extends StatelessWidget {
  const GroupSettingsScreen({
    super.key,
    required this.args
  });

  final GroupSettingsScreenArgs args;

  @override
  Widget build(BuildContext context) {
    final TextEditingController textEditingController = TextEditingController();

    final settings = [
      { "title": "대출 받기", "description": "신용 · 주택 · 대환 · 내 대출", "icon": "🙈", "id": "" },
      { "title": "계좌 개설", "description": "토스뱅크 · 타 은행/증권", "icon": "😎", "id": "" },
      { "title": "카드 발급", "description": "혜택 추천 · 타 은행/증권", "icon": "👀", "id": "" },
      { "title": "휴대폰 · 인터넷", "description": "통신요금 · 기기구매", "icon": "📱", "id": "" }
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        leading: Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 0, 0),
          child: ScalableButton(
            button: (tapDown) => Stack(
                children: [
                  Container(
                      padding: const EdgeInsets.all(5),
                      child: SvgPicture.asset("assets/icon/arrow-left.svg", height: 30, color: Color(0xff4A4B4F),)
                  ),
                  ButtonDarken(tapDown: tapDown)
                ]
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            SettingsBox(title: "그룹 설정", settings: [
              SettingItem(title: args.title, description: "", icon: args.icon, id: "GROUP_TITLE", onTap: () {
                showSlideDialog(context, RoundDialog(
                  title: Text("그룹 정보 수정", style: style[TextType.headline]),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      EditText(controller: textEditingController, backgroundColor: CustomColor.greyLightest, textColor: CustomColor.black, hintColor: CustomColor.grey, hint: "그룹 이름")
                    ],
                  ),
                ));
              })
            ]),
            SettingsBox(title: "모든 서비스", settings: [
              for (var i = 0; i < settings.length; i++) SettingItem(title: settings[i]["title"]!, description: settings[i]["description"]!, icon: settings[i]["icon"]!, id: settings[i]["id"]!, onTap: () {})
            ])
          ]
        ),
      ),
    );
  }
}

class SettingsBox extends StatelessWidget {
  const SettingsBox({
    super.key,
    required this.title,
    required this.settings
  });

  final String title;
  final List<SettingItem> settings;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 30, 0, 30),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(30, 0, 30, 20),
            child: Text(title, style: style[TextType.headline])
          ),
          for (var i = 0; i < settings.length; i++)
            SettingItem(title: settings[i].title, description: settings[i].description, icon: settings[i].icon, id: settings[i].id, onTap: settings[i].onTap)
        ]
      )
    );
  }
}

class SettingItem extends StatelessWidget {
  const SettingItem({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.id,
    required this.onTap
  });
  final String title;
  final String description;
  final String icon;
  final String id;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return ScalableButton(
      button: (tapDown) => Stack(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
            child: Row(
              spacing: 15,
              children: [
                Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(7), color: CustomColor.greyLightest),
                  width: 30,
                  height: 30,
                  child: Center(child: Text(icon, style: style[TextType.title3]))
                ),
                Expanded(
                  child: Text(title, style: style[TextType.body], softWrap: false, maxLines: 1, overflow: TextOverflow.ellipsis)
                ),
                (description != "") ? Expanded(child: Text(description, style: style[TextType.caption1]?.merge(TextStyle(color: CustomColor.grey)), textAlign: TextAlign.end, softWrap: false, overflow: TextOverflow.ellipsis, maxLines: 1,)) : SizedBox()
              ],
            )
          ),
          ButtonDarken(tapDown: tapDown)
        ],
      ),
      onTap: () {
        onTap();
      },
    );
  }
}
