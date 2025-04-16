import 'package:flutter/material.dart';
import 'package:group_gallery/widgets/public/colors.dart';

/*
w100 Thin, the least thick
w200 Extra-light
w300 Light
w400 Normal / regular / plain
w500 Medium
w600 Semi-bold
w700 Bold
w800 Extra-bold
w900 Black, the most thick
 */

enum TextType {
  largeTitle,
  largeBoldTitle,
  title1,
  title1Bold,
  title2,
  title3,
  headline,
  body,
  callout,
  subhead,
  footnote,
  caption1,
  caption2
}

const Map<TextType, TextStyle> style = {
  TextType.largeTitle: TextStyle(fontSize: 34, fontWeight: FontWeight.w400, color: CustomColor.black, fontFamily: 'Pretendard'),
  TextType.largeBoldTitle: TextStyle(fontSize: 34, fontWeight: FontWeight.w700, color: CustomColor.black, fontFamily: 'Pretendard'),
  TextType.title1: TextStyle(fontSize: 28, fontWeight: FontWeight.w400, color: CustomColor.black, fontFamily: 'Pretendard'),
  TextType.title1Bold: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: CustomColor.black, fontFamily: 'Pretendard'),
  TextType.title2: TextStyle(fontSize: 22, fontWeight: FontWeight.w400, color: CustomColor.black, fontFamily: 'Pretendard'),
  TextType.title3: TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: CustomColor.black, fontFamily: 'Pretendard'),
  TextType.headline: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: CustomColor.black, fontFamily: 'Pretendard'),
  TextType.body: TextStyle(fontSize: 17, fontWeight: FontWeight.w400, color: CustomColor.black, fontFamily: 'Pretendard'),
  TextType.callout: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: CustomColor.black, fontFamily: 'Pretendard'),
  TextType.subhead: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: CustomColor.black, fontFamily: 'Pretendard'),
  TextType.footnote: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: CustomColor.black, fontFamily: 'Pretendard'),
  TextType.caption1: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: CustomColor.black, fontFamily: 'Pretendard'),
  TextType.caption2: TextStyle(fontSize: 11, fontWeight: FontWeight.w400, color: CustomColor.black, fontFamily: 'Pretendard')
};

class StyleText extends StatelessWidget {
  const StyleText({
    super.key,
    required this.textType,
    required this.text,
    this.maxLines,
    this.textStyle = const TextStyle(),
    this.overflow = TextOverflow.fade,
    this.softWrap = false,
  });

  final TextType textType;
  final String text;
  final int? maxLines;
  final TextStyle textStyle;
  final TextOverflow overflow;
  final bool softWrap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        text,
        maxLines: maxLines,
        overflow: overflow,
        softWrap: softWrap,
        style: style[textType]?.merge(textStyle)
      ),
    );
  }
}
