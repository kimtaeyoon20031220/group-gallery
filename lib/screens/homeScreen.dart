import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:group_gallery/screens/groupScreen.dart';
import 'package:group_gallery/utils/set_ui_overlay_style.dart';
import 'package:group_gallery/widgets/home/list_item.dart';
import 'package:group_gallery/widgets/public/button_darken.dart';
import 'package:group_gallery/widgets/public/colors.dart';
import 'package:group_gallery/widgets/public/text.dart';
import 'package:group_gallery/widgets/public/title.dart';

import '../widgets/public/scalable_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    setUiOverlayStyleIOS(ThemeType.dark);

    final items = [
      { "id": "", "title": "개인정보 ㅁㄴㅇㄹㅁㄴㅇㄹㅁㄴㅇㅇㄹㄴㅁㅇㄹasdfasdfasdfasdf", "image_count": 7, "icon": "🔐", "is_locked": true },
      { "id": "", "title": "asdfasdfasdf", "image_count": 10, "icon": "🎶", "is_locked": false },
      { "id": "", "title": "개인정보", "image_count": 12, "icon": "🧾", "is_locked": true }
    ];

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              TitleBlock(textType: TextType.title1Bold, title: "갤러리"),
              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (BuildContext context, int index) {
                    Map<String, dynamic> item = items[index];
                    return ListItem(id: item["id"], title: item["title"], imageCount: item["image_count"], icon: item["icon"], isLocked: item["is_locked"]);
                  },
                )
              )
            ]
          )
        ),
      ),
    );
  }

  Widget containerButton(BuildContext context, String title) {
    return ScalableButton(
      button: (tapDown) => Stack(
        children: [
          Container(
            width: 120,
            height: 100,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(13),
              color: CustomColor.greyLightest
            ),
            child: Text(title, style: style[TextType.headline]),
          ),
          ButtonDarken(tapDown: tapDown)
        ],
      ),
      onTap: () {
        Navigator.pushNamed(context, '/toss_verify_code');
      },
    );
  }
}