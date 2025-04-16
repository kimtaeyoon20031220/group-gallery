import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:group_gallery/widgets/public/colors.dart';
import 'package:group_gallery/widgets/public/text.dart';
import 'package:logger/logger.dart';

class TossVerifyCodeScreen extends StatelessWidget {
  const TossVerifyCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("토스 문자 인증", style: style[TextType.footnote]),
        backgroundColor: CustomColor.greyLightest,
        elevation: 0.0,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 30, 30, 30),
              child: Text("문자로 받은\n인증번호 6자리를 입력해주세요", style: style[TextType.title3]?.merge(TextStyle(fontWeight: FontWeight.w700))),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: TossVerifyCode(numberLength: 6, height: 70,),
            ),
          ],
        ),
      ),
    );
  }
}

class TossVerifyCode extends StatefulWidget {
  const TossVerifyCode({super.key, required this.numberLength, this.height = 70});

  final int numberLength;
  final double height;

  @override
  State<TossVerifyCode> createState() => _TossVerifyCodeState();
}

class _TossVerifyCodeState extends State<TossVerifyCode> with TickerProviderStateMixin {

  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late List<String> numbers;

  late List<AnimationController> _animationRepeatControllers;
  late AnimationController _animationBoxController;

  bool isCompleted = false;
  bool isClosed = false;

  @override
  void initState() {
    super.initState();
    numbers = List.filled(widget.numberLength, "");
    _animationRepeatControllers = List.generate(widget.numberLength, (i) => AnimationController(vsync: this, duration: const Duration(milliseconds: 500)));
    _animationBoxController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    triggerStaggeredAnimation();
  }

  @override
  void dispose() {
    for (var controller in _animationRepeatControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void triggerStaggeredAnimation() async {
    if (mounted) {
      for (var i = 0; i < widget.numberLength; i++) {
        _animationRepeatControllers[i].reset();
        await Future.delayed(Duration(milliseconds: 100));
        _animationRepeatControllers[i].repeat();
      }
      setState(() {});
    }
  }

  void onTextChanged() async {
    if (mounted) {
      triggerStaggeredAnimation();
    }
    if (_textEditingController.text.length > numbers.length) {
      _textEditingController.text = _textEditingController.text.substring(0, numbers.length);
    }
    _textEditingController.text = _textEditingController.text.trim();
    final text = _textEditingController.text;
    setState(() {
      for (var i = 0; i < numbers.length; i++) {
        numbers[i] = (i < text.length) ? text[i] : "";
      }
    });
    if (_textEditingController.text.length == numbers.length) {
      _animationBoxController.forward();
      setState(() {
        isCompleted = true;
      });
      await Future.delayed(const Duration(milliseconds: 500));
      setState(() {
        isClosed = true;
        _animationBoxController.forward().then((_) {
          _animationBoxController.reverse();
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      child: GestureDetector(
        onTap: () {
          _focusNode.requestFocus();
        },
        child: Stack(
          children: [
            ScaleTransition(
              scale: Tween(begin: (isClosed) ? 0.9 : 1.0, end: (isClosed) ? 0.4 : 0.9).animate(CurvedAnimation(parent: _animationBoxController, curve: Curves.easeOutCirc, reverseCurve: Curves.easeInCirc)),
              child: Column(
                children: [
                  Expanded(
                    child: Center(
                      child: AnimatedContainer(
                        width: isClosed ? 70 : MediaQuery.of(context).size.width,
                        height: widget.height,
                        curve: Curves.easeOutCirc,
                        duration: Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(isClosed ? widget.height : 20),
                          color: isClosed ? CustomColor.blue : Colors.white,
                          border: Border.all(width: 3, color: CustomColor.blue.withOpacity(isCompleted ? 0.3 : 0))
                        ),
                        child: isClosed ?
                            Center(
                              child: SvgPicture.asset("assets/icon/check.svg", color: Colors.white, width: 40,),
                            ) :
                            Row(
                              spacing: 10,
                              children: [
                                for (var i = 0; i < widget.numberLength; i++)
                                  Flexible(child: ColorChangeNumberContainer(index: i, number: numbers[i], numberLength: numbers.length, animationRepeatController: _animationRepeatControllers[i], isCompleted: isCompleted))
                              ],
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Opacity(
              opacity: 0,
              child: TextField(
                focusNode: _focusNode,
                controller: _textEditingController,
                enabled: !isCompleted,
                keyboardType: TextInputType.number,
                onChanged: (_) {
                  onTextChanged();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ColorChangeNumberContainer extends StatefulWidget {
  const ColorChangeNumberContainer({
    super.key,
    this.duration = const Duration(milliseconds: 500),
    required this.index,
    required this.number,
    required this.numberLength,
    required this.animationRepeatController,
    required this.isCompleted,
  });

  final Duration duration;
  final int index;
  final String number;
  final int numberLength;
  final AnimationController animationRepeatController;
  final bool isCompleted;

  @override
  State<ColorChangeNumberContainer> createState() => _ColorChangeNumberContainerState();
}

class _ColorChangeNumberContainerState extends State<ColorChangeNumberContainer> with TickerProviderStateMixin {

  late Animation<Color?> colorTween;

  late AnimationController _animationController;

  final Color startColor = CustomColor.greyLightest;
  final Color endColor = Colors.white;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 100));
    colorTween = ColorTween(begin: startColor, end: endColor).animate(widget.animationRepeatController)..addListener(() {
      if (!mounted) return;
      setState(() {});
    });
  }

  @override
  void didUpdateWidget(covariant ColorChangeNumberContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.number != widget.number && widget.number != "" && mounted) {
      _animationController.forward().then((_) {
        _animationController.reverse();
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {

    return ScaleTransition(
          scale: Tween<double>(begin: 1.0, end: 0.9).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOutCirc, reverseCurve: Curves.easeInCirc)),
          child: AnimatedBuilder(
            animation: widget.animationRepeatController,
            builder: (context, child) => AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: (widget.number == "") ? colorTween.value : Colors.white,
                  border: (widget.number == "") ? Border.all(width: 1, color: CustomColor.greyLightest.withOpacity(0)) : Border.all(width: 1, color: CustomColor.greyLightest.withOpacity(widget.isCompleted ? 0 : 1))
              ),
              child: Center(
                child: Text(widget.number, style: style[TextType.title1]?.merge(TextStyle(color: CustomColor.blue, fontWeight: FontWeight.w700))),
              ),
            ),
          ),
        );
  }
}

