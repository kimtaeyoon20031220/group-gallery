import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:group_gallery/screens/groupSettingsScreen.dart';
import 'package:group_gallery/screens/photoScreen.dart';
import 'package:group_gallery/utils/set_ui_overlay_style.dart';
import 'package:group_gallery/widgets/public/colors.dart';
import 'package:group_gallery/widgets/public/scalable_button.dart';
import 'package:group_gallery/widgets/public/text.dart';
import 'package:group_gallery/widgets/public/title.dart';

class GroupScreenArgs {
  final bool isLocked;
  final String id;
  final String title;
  final String icon;

  const GroupScreenArgs({ required this.isLocked, required this.id, required this.title, required this.icon });
}

class GroupScreen extends StatelessWidget {
  const GroupScreen({super.key, required this.args });
  final GroupScreenArgs args;

  void onPress(BuildContext context) {
    Navigator.pushNamed(context, "/group/settings", arguments: GroupSettingsScreenArgs(title: args.title, icon: args.icon));
  }

  List<Map> getPhotos(String id) {
    return [
      {
        "tag": ["카메라", "사람"],
        "link": "https://plus.unsplash.com/premium_photo-1664474619075-644dd191935f?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8JTIzaW1hZ2V8ZW58MHx8MHx8fDA%3D"
      },
      {
        "tag": ["카멜레온"],
        "link": "https://letsenhance.io/static/73136da51c245e80edc6ccfe44888a99/1015f/MainBefore.jpg"
      },
      {
        "tag": ["언덕", "나무", "구름", "하늘"],
        "link": "https://images.ctfassets.net/hrltx12pl8hq/28ECAQiPJZ78hxatLTa7Ts/2f695d869736ae3b0de3e56ceaca3958/free-nature-images.jpg?fit=fill&w=1200&h=630",
      },
      {
        "tag": ["석양", "나무", "수평선", "구름"],
        "link": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTtnvAOajH9gS4C30cRF7rD_voaTAKly2Ntaw&s",
      },
      {
        "tag": ["숲", "의자", "오솔길", "나무"],
        "link": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSNAkB1j2W0ejEMyWFYmTpvMoKYCzy99XwD_Q&s",
      },
      {
        "tag": ["호랑이", "수풀"],
        "link": "https://static.vecteezy.com/system/resources/thumbnails/036/324/708/small/ai-generated-picture-of-a-tiger-walking-in-the-forest-photo.jpg",
      },
      {
        "tag": ["나무", "분홍", "반사", "물"],
        "link": "https://static.gettyimages.com/display-sets/creative-landing/images/GettyImages-2181662163.jpg",
      },
      {
        "tag": ["수풀", "고양이"],
        "link": "https://huggingface.co/datasets/huggingfacejs/tasks/resolve/main/zero-shot-image-classification/image-classification-input.jpeg"
      }
    ];
  }

  @override
  Widget build(BuildContext context) {

    setUiOverlayStyle(false);

    var photoIds = getPhotos(args.id);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40),
        child: AppBar(
          scrolledUnderElevation: 0,
          backgroundColor: Colors.transparent,
          leading: Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 0, 0),
            child: ScalableButton(
              button: (tapDown) => Container(
                  padding: const EdgeInsets.all(5),
                  child: SvgPicture.asset("assets/icons/arrow-left.svg", height: 30, color: Color(0xff4A4B4F),)
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleIconButtonsBlock(
              textType: TextType.title1Bold,
              title: Row(
                children: [
                  (args.isLocked) ? Container(
                      margin: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                      child: SvgPicture.asset("assets/icons/lock-closed.svg")
                  ) : SizedBox(),
                  Expanded(child: Text(args.title, style: style[TextType.title1Bold], overflow: TextOverflow.fade, softWrap: false)),
                ]
              ),
              buttons: [
                SvgPicture.asset("assets/icons/squares-plus.svg"),
                SvgPicture.asset("assets/icons/cog-8-tooth.svg")
              ],
              buttonsOnPress: [
                () {},
                () {
                  Navigator.pushNamed(context, "/group/settings", arguments: GroupSettingsScreenArgs(title: args.title, icon: args.icon));
                }
              ]
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
              child: Stack(
                children: [
                  GridView.builder(
                    padding: const EdgeInsets.fromLTRB(0, 30, 0, 30),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10
                    ),
                    itemCount: photoIds.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ScalableButton(
                        onTap: () {
                          Navigator.pushNamed(context, '/group/photo', arguments: PhotoScreenArgs(pIds: photoIds, index: index));
                        },
                        button: (tapDown) => Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(13),
                              color: CustomColor.greyLightest
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(13),
                              child: Image.network(photoIds[index]["link"], fit: BoxFit.cover)
                            )
                          ),
                        ),
                      );
                    }
                  ),
                  Container(
                    width: double.infinity,
                    height: 20,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.white.withOpacity(1), Colors.white.withOpacity(0)]
                      )
                    ),
                  )
                ],
              ),
            )
          )
        ]
      ),
    );
  }
}
