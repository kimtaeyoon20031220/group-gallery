import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:group_gallery/screens/groupScreen.dart';
import 'package:group_gallery/screens/lockScreen.dart';
import 'package:group_gallery/widgets/public/button_darken.dart';
import 'package:group_gallery/widgets/public/colors.dart';
import 'package:group_gallery/widgets/public/text.dart';

import '../public/scalable_button.dart';

class ListItem extends StatelessWidget {
  const ListItem({
    super.key,
    required this.id,
    required this.icon,
    required this.title,
    required this.imageCount,
    required this.isLocked
  });
  final String id;
  final String icon;
  final String title;
  final int imageCount;
  final bool isLocked;

  @override
  Widget build(BuildContext context) {
    return ScalableButton(
      onTap: () {
        (isLocked) ?
            Navigator.pushNamed(context, '/lock', arguments: LockScreenArgs(icon: icon, title: title, id: id))
            :
            Navigator.pushNamed(context, '/group', arguments: GroupScreenArgs(isLocked: false, id: id, title: title, icon: icon));
      },
      button: (tapDown) => Stack(
        children: [
          Container(
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
                    child: Text(icon, style: style[TextType.headline])
                  )
                ),
                Expanded(
                  flex: 1,
                  child: Text(title, style: style[TextType.body], softWrap: false, overflow: TextOverflow.fade, maxLines: 1),
                ),
                (isLocked) ? SvgPicture.asset("assets/icons/lock-closed.svg", width: 13, height: 13, color: Color(0xff4A4B4F),) : SizedBox(),
                Text("$imageCount", style: style[TextType.body]?.merge(TextStyle(color: CustomColor.grey))),
                SvgPicture.asset("assets/icons/chevron-right.svg")
              ]
            )
          ),
          ButtonDarken(tapDown: tapDown, color: Color(0xff4A4B4F), duration: Duration(milliseconds: 100))
        ]
      )
    );
  }
}
