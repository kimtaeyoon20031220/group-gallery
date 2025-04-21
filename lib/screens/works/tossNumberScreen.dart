import 'dart:math';

import 'package:flutter/material.dart';
import 'package:group_gallery/widgets/public/scalable_button.dart';
import 'package:group_gallery/widgets/public/text.dart';

import '../../widgets/public/colors.dart';

class TossNumberScreen extends StatefulWidget {
  const TossNumberScreen({super.key});

  @override
  State<TossNumberScreen> createState() => _TossNumberScreenState();
}

class TossNumberController extends ChangeNotifier {
  Size childSize = Size(0, 0);
  int currentIndex = 0;

  final ScrollController scrollController = ScrollController();

  Size measureTextSize(String text, TextStyle style, {double maxWidth = double.infinity}) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
      maxLines: null,
    )..layout(maxWidth: maxWidth);
    return textPainter.size; // Size(width, height)
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  get getCurrentIndex {
    return currentIndex;
  }

  get getController {
    return scrollController;
  }

  void setChildSize(Size size) {
    childSize = size;
  }

  Size getCurrentSize() {
    return measureTextSize("$currentIndex", style[TextType.title1Bold]!);
  }

  void animateToIndex(index) {
    setChildSize(measureTextSize("$index", style[TextType.title1Bold]!));
    currentIndex = index;
    print("scrollController: $scrollController");
    scrollController.animateTo(index * childSize.height, duration: const Duration(milliseconds: 600), curve: Curves.easeOutCirc);
    notifyListeners();
  }
}

class _TossNumberScreenState extends State<TossNumberScreen> {

  final TossNumberController controller = TossNumberController();
  late List<TossNumberController> controllers;
  final random = Random();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  int rand = 0;
  final list = [0, 112312312, 1, 3, 10, 123, 13245, 1234513245, 99999999999];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
            children: [
              Row(
                children: [
                  ScalableButton(button: (tapDown) => Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(list[rand % list.length].toString()),
                  ), onTap: () {
                    setState(() {
                      rand++;
                    });
                  }),
                  TossNumbers(maxLength: 20, number: list[rand % list.length]),
                ],
              )
            ]
        ),
      ),
    );
  }
}

class TossNumbers extends StatefulWidget {
  const TossNumbers({super.key, required this.maxLength, required this.number});

  final int maxLength;
  final int number;

  @override
  State<TossNumbers> createState() => _TossNumbersState();
}

class _TossNumbersState extends State<TossNumbers> with SingleTickerProviderStateMixin {

  int number = 0;
  int useLength = 1;

  double useWidth = 0;
  double allWidth = 0;

  Offset prevOffset = Offset.zero;

  late List<TossNumberController> controllers;

  @override
  void initState() {
    super.initState();
    controllers = List.generate(widget.maxLength, (_) => TossNumberController());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration.zero, () {
        animate();
        useWidth = controllers[0].getCurrentSize().width;
      });
    });
  }

  @override
  void didUpdateWidget(covariant TossNumbers oldWidget) {
    super.didUpdateWidget(oldWidget);
    animate();
  }

  Future<void> animate() async {
    final List<String> numberString = "${widget.number}".split("");
    print("${widget.maxLength} / ${numberString.length}");
    for (int i = 0; i < widget.maxLength - numberString.length; i++) { // 사용하지 않는 숫자 위치는 0으로 초기화
      if (controllers[i].scrollController.hasClients) {
        controllers[i].animateToIndex(0);
      }
    }
    for (int i = 0; i < numberString.length; i++) {
      if (controllers[widget.maxLength - numberString.length + i].scrollController.hasClients) {
        controllers[widget.maxLength - numberString.length + i].animateToIndex(int.parse(numberString.length >= i + 1 ? numberString[i] : "0"));
      }
    }
    setState(() {
      prevOffset = Offset(-allWidth + useWidth, 0.0);
    });
    useWidth = 0;
    allWidth = 0;
    useLength = numberString.length;
    for (int i = 0; i < widget.maxLength; i++) {
      allWidth += controllers[i].childSize.width;
      if (i > widget.maxLength - useLength - 1) {
        useWidth += controllers[i].childSize.width;
      }
    }
    setState(() {
      useLength = numberString.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(),
      clipBehavior: Clip.hardEdge,
      child: TweenAnimationBuilder(
        tween: Tween<Offset>(begin: prevOffset, end: Offset(-allWidth + useWidth, 0.0)),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCirc,
        builder: (context, offset, child) => Transform.translate(
          offset: offset,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(),
            clipBehavior: Clip.hardEdge,
            width: allWidth,
            height: controllers[0].childSize.height,
            child: ListView.builder(
              itemCount: widget.maxLength,
              scrollDirection: Axis.horizontal,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) => TossNumber(controller: controllers[index]),
            ),
          ),
        ),
      ),
    );
  }
}


class TossNumber extends StatefulWidget {
  const TossNumber({
    super.key,
    required this.controller,
  });

  final TossNumberController controller;

  @override
  State<TossNumber> createState() => _TossNumberState();
}

class _TossNumberState extends State<TossNumber> {
  final Duration duration = const Duration(milliseconds: 1000);
  final Curve curve = Curves.easeOutCirc;

  Size textSize = Size(0, 0);

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onControllerChange);
  }

  void _onControllerChange() {
    setState(() {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.controller.getCurrentSize().width,
      height: widget.controller.getCurrentSize().height,
      decoration: BoxDecoration(),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              controller: widget.controller.getController,
              itemCount: 10,
              itemBuilder: (context, index) => Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: widget.controller.getCurrentSize().height,
                  child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: index == widget.controller.getCurrentIndex
                          ? style[TextType.title1Bold] ?? TextStyle()
                          : style[TextType.title1Bold]?.copyWith(color: CustomColor.greyLight) ?? TextStyle(),
                      child: Text(index.toString())
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}



