import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:group_gallery/animations/doridori.dart';
import 'package:group_gallery/screens/groupScreen.dart';
import 'package:group_gallery/utils/set_ui_overlay_style.dart';
import 'package:group_gallery/widgets/public/colors.dart';
import 'package:group_gallery/widgets/public/edit_text.dart';
import 'package:group_gallery/widgets/public/scalable_button.dart';
import '../widgets/public/text.dart';

class LockScreenArgs {
  final String icon;
  final String title;
  final String id;

  LockScreenArgs({ required this.icon, required this.title, required this.id });
}

class LockScreen extends StatefulWidget {
  const LockScreen({super.key, required this.args });
  final LockScreenArgs args;

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  final GlobalKey<DoridoriState> doridoriKey = GlobalKey<DoridoriState>();

  @override
  Widget build(BuildContext context) {

    setUiOverlayStyle(true);

    void unlock() {
      Navigator.pop(context);
      Navigator.pushNamed(context, "/group", arguments: GroupScreenArgs(isLocked: true, id: widget.args.id, title: widget.args.title, icon: widget.args.icon));
    }

    TextEditingController controller = TextEditingController();
    FocusNode textFocus = FocusNode();

    return Scaffold(
      backgroundColor: Color(0xff2F3137),
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Color(0xff2F3137),
        leading: Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 0, 0),
          child: ScalableButton(
            button: (tapDown) => Container(
                padding: const EdgeInsets.all(5),
                child: SvgPicture.asset("assets/icons/arrow-left.svg", height: 30, color: CustomColor.greyLight)
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            textFocus.unfocus();
          },
          child: Stack(
            children: [
              ListView(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 105,
                        height: 105,
                        margin: const EdgeInsets.fromLTRB(0, 120, 0, 0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Color(0xff41434D),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xff1A1F34),
                              blurRadius: 100,
                              offset: Offset.zero
                            )
                          ]
                        ),
                        child: Center(child: Text(widget.args.icon, style: TextStyle(fontSize: 50)))
                      ),
                    ],
                  ),
                  SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 10,
                      children: [
                        SvgPicture.asset("assets/icons/lock-closed.svg", color: Colors.white),
                        Flexible(child: Text(widget.args.title, style: style[TextType.title1Bold]?.merge(TextStyle(color: Colors.white)), softWrap: true))
                      ],
                    ),
                  ),
                  SizedBox(height: 23),
                  Column(
                    children: [
                      Text("잠긴 갤러리입니다.", style: style[TextType.body]?.merge(TextStyle(color: Color(0xffB8BDD1)))),
                      Text("비밀번호를 입력하여 잠금 해제하세요.", style: style[TextType.body]?.merge(TextStyle(color: Color(0xffB8BDD1)))),
                    ],
                  ),
                  Doridori(
                    key: doridoriKey,
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(30, 30, 30, 30),
                      child: EditText(
                          focusNode: textFocus,
                          controller: controller,
                          hint: "비밀번호 입력",
                          keyboardType: TextInputType.number,
                          obscureText: true,
                          onComplete: () {
                            if (controller.text == "1234") {
                              Navigator.pop(context);
                              Navigator.pushNamed(context, "/group", arguments: GroupScreenArgs(isLocked: true, id: widget.args.id, title: widget.args.title, icon: widget.args.icon));
                            } else {
                              controller.clear();
                              doridoriKey.currentState?.shake();
                            }
                          },
                      )
                    ),
                  ),
                ]
              ),
            ],
          ),
        )
      ),
    );
  }
}
