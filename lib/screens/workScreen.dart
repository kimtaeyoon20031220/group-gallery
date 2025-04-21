import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../widgets/public/colors.dart';
import '../widgets/public/scalable_button.dart';
import '../widgets/public/text.dart';
import '../widgets/public/title.dart';

class Work {
  final String title;
  final String icon;
  final String address;
  final String date;
  
  const Work({ required this.title, required this.icon, required this.address, required this.date });
}

class WorkScreen extends StatelessWidget {
  const WorkScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final List<Work> works = [
      Work(title: "토스 문자 인증", icon: "assets/images/toss_logo.png", address: "/toss_verify_code", date: "2025.04.16"),
      Work(title: "맵볼", icon: "assets/images/toss_logo.png", address: "/map_ball", date: "2025.04.17"),
      Work(title: "토스 Segmented Picker", icon: "assets/images/toss_logo.png", address: "/toss_segmented_picker", date: "2025.04.17"),
      Work(title: "토스 송금", icon: "assets/images/toss_logo.png", address: "/toss_wire", date: "2025.04.19"),
      Work(title: "토스 숫자", icon: "assets/images/toss_logo.png", address: "/toss_number", date: "2025.04.21")
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
            children: [
              TitleBlock(textType: TextType.title1Bold, title: "작업 기록"),
              Expanded(
                  child: ListView.builder(
                    itemCount: works.length,
                    itemBuilder: (BuildContext context, int index) {
                      return WorkListItem(work: works[index]);
                    },
                  )
              )
            ]
        ),
      ),
    );
  }
}

class WorkListItem extends StatelessWidget {
  const WorkListItem({super.key, required this.work });

  final Work work;

  @override
  Widget build(BuildContext context) {
    return ScalableButton(
        onTap: () {
          Navigator.pushNamed(context, work.address);
        },
        focusColor: CustomColor.greyLightest,
        button: (tapDown) => Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(13),
            ),
            padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
            child: Row(
                spacing: 15,
                children: [
                  Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        color: CustomColor.greyLightest,
                      ),
                      width: 35,
                      height: 35,
                      child: Center(
                          child: Image.asset(work.icon, width: 25),
                      )
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(work.title, style: style[TextType.body], softWrap: false, overflow: TextOverflow.fade, maxLines: 1),
                  ),
                  Container(
                    child: Text(work.date, style: style[TextType.footnote]?.merge(TextStyle(color: CustomColor.grey)), softWrap: false, overflow: TextOverflow.fade, maxLines: 1, textAlign: TextAlign.end,),
                  ),
                  SvgPicture.asset("assets/icons/chevron-right.svg")
                ]
            )
        )
    );
  }
}