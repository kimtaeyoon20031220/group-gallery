import 'package:flutter/material.dart';
import 'package:group_gallery/widgets/public/colors.dart';
import 'package:group_gallery/widgets/public/text.dart';
import 'package:group_gallery/widgets/public/wide_button.dart';

import '../../widgets/public/scalable_button.dart';

class TossSegmentedPickerScreen extends StatelessWidget {
  const TossSegmentedPickerScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final values = ["내 보험", "보험 찾기", "보험사"];
    final pageController = PageController();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: CustomColor.greyLightest,
        title: Text("토스 Segmented Picker", style: style[TextType.footnote]),
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: SegmentedPicker(
                  initialIndex: 0,
                  values: values,
                  onTaps: [() {
                    print(0);
                    pageController.animateToPage(0, duration: const Duration(milliseconds: 300), curve: Curves.easeOutCirc);
                  }, () {
                    print(1);
                    pageController.animateToPage(1, duration: const Duration(milliseconds: 300), curve: Curves.easeOutCirc);
                  }, () {
                    print(2);
                    pageController.animateToPage(2, duration: const Duration(milliseconds: 300), curve: Curves.easeOutCirc);
                  }],
                ),
              ),
              Expanded(
                child: PageView.builder(
                  pageSnapping: true,
                  controller: pageController,
                  itemCount: values.length,
                  itemBuilder: (context, index) =>
                    ListView(
                      children: [
                        Padding(padding: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(13),
                                  color: CustomColor.greyLightest,
                                ),
                                child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text("내 보험", style: style[TextType.footnote]?.merge(TextStyle(color: CustomColor.greyLight))),
                                                  Text("3,577원", style: style[TextType.title3]?.merge(TextStyle(fontWeight: FontWeight.w600)))
                                                ]
                                              ),
                                            ),
                                            SizedBox(
                                              width: 100,
                                              child: WideButton(
                                                text: "병원비 청구",
                                                borderRadius: 10,
                                                height: 40,
                                                pointColor: Color(0xffdee1f1),
                                                textStyle: TextStyle(color: CustomColor.grey, fontWeight: FontWeight.w600),
                                              ),
                                            )
                                          ]
                                        ),
                                      )
                                    ]
                                )
                              )
                            ]
                          ),
                        )
                      ],
                    )
                ),
              )
            ]
          )
        )
      ),
    );
  }
}

class SegmentedPicker extends StatefulWidget {
  const SegmentedPicker({
    super.key,
    required this.values,
    required this.onTaps,
    this.initialIndex = 0,
  });

  final List<String> values;
  final List<Function()> onTaps;
  final int initialIndex;

  @override
  State<SegmentedPicker> createState() => _SegmentedPickerState();
}

class _SegmentedPickerState extends State<SegmentedPicker> {

  late int _selectedIdx;

  @override
  void initState() {
    super.initState();
    _selectedIdx = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(13),
        color: CustomColor.greyLightest
      ),
      child: LayoutBuilder(
        builder: (context, constraints) => Stack(
          children: [
            AnimatedPositioned(
              left: (constraints.maxWidth / 3) * _selectedIdx,
              curve: Curves.easeOutCirc,
              duration: const Duration(milliseconds: 300),
              child: Container(
                width: constraints.maxWidth / 3 - constraints.maxHeight * 0.2,
                height: constraints.maxHeight * 0.8,
                margin: EdgeInsets.fromLTRB(constraints.maxHeight * 0.1, constraints.maxHeight * 0.1, constraints.maxHeight * 0.1, constraints.maxHeight * 0.1),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0.0, 3.0),
                      blurRadius: 3.0,
                      color: CustomColor.black.withOpacity(0.05)
                    )
                  ]
                ),
              ),
            ),
            Row(
              children: [
                for (int i = 0; i < widget.values.length; i++)
                  Expanded(child: button(i, widget.values[i], widget.onTaps[i]))
              ]
            ),
            Positioned(
              left: (constraints.maxWidth / 3) * _selectedIdx,
              child: Container(
                width: constraints.maxWidth / 3,
                height: constraints.maxHeight,
                decoration: BoxDecoration(
                    color: Colors.transparent
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget button(int index, String value, Function() onTap) {
    return ScalableButton(
      scale: 1.0,
      button: (tapDown) => Stack(
        children: [
          Positioned.fill(
            child: AnimatedOpacity(
              opacity: index == _selectedIdx ? 0 : tapDown ? 1 : 0,
              duration: const Duration(milliseconds: 100),
              child: AnimatedScale(
                scale: index == _selectedIdx ? 0 : tapDown ? 1 : 0.9,
                duration: const Duration(milliseconds: 100),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(13),
                    gradient: LinearGradient(
                      colors: [ CustomColor.greyLight.withOpacity(0), CustomColor.greyLight.withOpacity(0.15), CustomColor.greyLight.withOpacity(0) ],
                    )
                  ),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Center(
              child: AnimatedScale(
                duration: const Duration(milliseconds: 150),
                curve: Curves.easeOutCirc,
                scale: tapDown ? 0.9 : 1,
                child: Text(value, style: style[TextType.subhead]?.merge(TextStyle(color: index == _selectedIdx ? CustomColor.black : CustomColor.grey, fontWeight: FontWeight.w500)))),
            ),
          ),
        ],
      ),
      onTap: () {
        setState(() {
          _selectedIdx = index;
        });
        onTap();
      },
    );
  }
}

