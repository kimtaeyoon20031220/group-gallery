import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:group_gallery/widgets/public/button_darken.dart';
import 'package:group_gallery/widgets/public/colors.dart';
import 'package:group_gallery/widgets/public/icon_text_button.dart';
import 'package:group_gallery/widgets/public/image_button.dart';
import 'package:group_gallery/widgets/public/round_dialog.dart';
import 'package:group_gallery/widgets/public/text.dart';
import 'package:logger/logger.dart';

import '../widgets/public/scalable_button.dart';

class PhotoScreenArgs {
  final List<Map> pIds;
  final int index;
  const PhotoScreenArgs({ required this.pIds, required this.index });
}

class PhotoScreen extends StatefulWidget {
  const PhotoScreen({super.key, required this.args });

  final PhotoScreenArgs args;

  @override
  State<PhotoScreen> createState() => _PhotoScreenState();
}

class _PhotoScreenState extends State<PhotoScreen> {

  late int pointIndex;
  CarouselSliderController carouselSliderController = CarouselSliderController();
  CarouselSliderController photosListCarouselSliderController = CarouselSliderController();

  @override
  void initState() {
    super.initState();
    pointIndex = widget.args.index;
  }

  @override
  Widget build(BuildContext context) {


    void setIndex(setIdx) {
      setState(() {
        pointIndex = setIdx;
        carouselSliderController.animateToPage(pointIndex, curve: Curves.easeOutCirc);
        photosListCarouselSliderController.animateToPage(pointIndex, curve: Curves.easeOutCirc);
      });
    }

    void deletePhoto() {}

    return Scaffold(
      backgroundColor: CustomColor.black,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 20, 30, 0),
              child: SizedBox(
                height: 50,
                width: double.infinity,
                child: Row(
                  children: [
                    Expanded(child: PhotosList(pIds: widget.args.pIds, index: pointIndex, setIndex: setIndex, controller: photosListCarouselSliderController)),
                    ScalableButton(
                      button: (tapDown) => Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: SvgPicture.asset("assets/icon/x-mark.svg"),
                          ),
                          ButtonDarken(tapDown: tapDown, color: CustomColor.greyLightest)
                        ],
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    )
                  ],
                )
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  CarouselSlider.builder(
                    carouselController: carouselSliderController,
                    options: CarouselOptions(
                      aspectRatio: 3/4,
                      enableInfiniteScroll: false,
                      initialPage: pointIndex,
                      viewportFraction: 1,
                      enlargeCenterPage: true,
                      onPageChanged: (index, reason) => setState(() {
                        pointIndex = index;
                        photosListCarouselSliderController.animateToPage(index, curve: Curves.easeOutCirc);
                      })
                    ),
                    itemCount: widget.args.pIds.length,
                    itemBuilder: (context, index, realIndex) {
                      final path = widget.args.pIds[index]["link"];
                      return Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: CustomColor.black,
                        child: Image.network(path)
                      );
                    },
                  ),
                  Positioned.directional(
                    textDirection: TextDirection.ltr,
                    bottom: 30,
                    start: 0,
                    end: 0,
                    child: Center(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: CustomColor.blackLight,
                        ),
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconTextButton(icon: SvgPicture.asset("assets/icon/trash-bin.svg", width: 20,), text: "삭제", shadowColor: CustomColor.greyLightest, opacity: 0.1, borderRadius: 15, onTap: () {
                              showSlideDialog(
                                context,
                                RoundDialog(
                                  title: Text("사진을 삭제하시겠습니까?", style: style[TextType.title3]!.merge(TextStyle(fontWeight: FontWeight.w600))),
                                  content: Text("사진을 삭제하면 복구할 수 없어요. ${widget.args.pIds[pointIndex]["tag"]}", style: style[TextType.callout]),
                                  cancelText: "취소",
                                  onClose: () {},
                                  acceptText: "삭제",
                                  onAccept: () {
                                    deletePhoto();
                                  },
                                  pointColor: CustomColor.red,
                                )
                              );
                            }),
                            IconTextButton(icon: SvgPicture.asset("assets/icon/pencil.svg", width: 20,), text: "수정", shadowColor: CustomColor.greyLightest, opacity: 0.1, borderRadius: 15, onTap: () {})
                          ]
                        ),
                      ),
                    )
                  )
                ],
              ),
            )
          ]
        ),
      ),
    );
  }
}

class PhotosList extends StatelessWidget {
  const PhotosList({ super.key, required this.pIds, required this.index, required this.setIndex, required this.controller });

  final List<Map> pIds;
  final int index;
  final Function(dynamic) setIndex;
  final CarouselSliderController controller;

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      carouselController: controller,
      options: CarouselOptions(
          enableInfiniteScroll: false,
          initialPage: index,
          viewportFraction: 0.17,
      ),
      itemCount: pIds.length,
      itemBuilder: (context, idx, realIdx) => ScalableButton(
        onTap: () {
          setIndex(idx);
        },
        button: (tapDown) => Stack(
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                border: Border.all(style: (idx == index) ? BorderStyle.solid : BorderStyle.solid, width: (index == idx) ? 4 : 1, color: Colors.white.withOpacity(index == idx ? 1 : 0.2), strokeAlign: BorderSide.strokeAlignInside)
              ),
              child: Image.network(pIds[idx]["link"])
            ),
            ButtonDarken(tapDown: tapDown, color: CustomColor.greyLightest, borderRadius: 0)
          ],
        ),
      ),
    );
  }
}
