import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:group_gallery/animations/doridori.dart';
import 'package:group_gallery/widgets/public/colors.dart';
import 'package:group_gallery/widgets/public/text.dart';
import 'package:logger/logger.dart';
import 'package:shimmer/shimmer.dart';

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
              child: TossVerifyCode(numberLength: 6, height: 70, getVerifyCode: () async {
                await Future.delayed(const Duration(milliseconds: 300));
                return "121212";
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class TossVerifyCode extends StatefulWidget {
  const TossVerifyCode({super.key, required this.numberLength, this.height = 70, required this.getVerifyCode});

  final int numberLength;
  final double height;
  final Function() getVerifyCode;

  @override
  State<TossVerifyCode> createState() => _TossVerifyCodeState();
}

class _TossVerifyCodeState extends State<TossVerifyCode> with TickerProviderStateMixin {

  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late List<String> numbers;

  late AnimationController _animationBoxController;

  final GlobalKey<DoridoriState> doridoriKey = GlobalKey<DoridoriState>();

  bool isCompleted = false;
  bool isClosed = false;
  bool isWrong = false;

  @override
  void initState() {
    super.initState();
    numbers = List.filled(widget.numberLength, "");
    _animationBoxController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _animationBoxController.dispose();
    super.dispose();
  }

  void onTextChanged(value) async {
    if (_textEditingController.text.length > numbers.length) {
      _textEditingController.text = _textEditingController.text.substring(0, numbers.length);
      _textEditingController.selection = TextSelection.fromPosition(
        TextPosition(offset: _textEditingController.text.length)
      );
    }
    _textEditingController.text = _textEditingController.text.trim();

    // macOS에서 controller.text에 값을 직접 할당한 이후 커서가 모든 값을 잡아서 입력 때마다 값이 초기화되어
    // TextSelection.position을 text의 맨 뒤로 넘기는 코드.
    _textEditingController.selection = TextSelection.fromPosition(
        TextPosition(offset: _textEditingController.text.length)
    );

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
      final verifyCode = await widget.getVerifyCode();
      if (verifyCode == _textEditingController.text) {
        setState(() {
          isClosed = true;
          _animationBoxController.forward().then((_) {
            _animationBoxController.reverse();
          });
        });
      } else {
        _animationBoxController.reverse();
        setState(() {
          isCompleted = false;
          doridoriKey.currentState?.shake();
          isWrong = true;
        });
        await Future.delayed(const Duration(milliseconds: 500));
        _textEditingController.clear();
        setState(() {
          numbers = List.filled(widget.numberLength, "");
          isWrong = false;
        });
        _focusNode.requestFocus();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: Doridori(
        key: doridoriKey,
        child: GestureDetector(
          onTap: () {
            _focusNode.requestFocus();
          },
          child: Stack(
            children: [
              Opacity(
                opacity: 0,
                child: TextField(
                  focusNode: _focusNode,
                  controller: _textEditingController,
                  enabled: !isCompleted,
                  keyboardType: TextInputType.number,
                  onChanged: onTextChanged,
                ),
              ),
              ScaleTransition(
                scale: Tween(begin: (isClosed) ? 1.0 : 1.0, end: (isClosed) ? 0.8 : 0.8).animate(CurvedAnimation(parent: _animationBoxController, curve: Curves.easeOutCirc, reverseCurve: Curves.easeInCirc)),
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
                                child: SvgPicture.asset("assets/icons/check.svg", color: Colors.white, width: 40,),
                              ) :
                              Stack(
                                children: [
                                  Shimmer.fromColors(
                                    baseColor: CustomColor.greyLightest,
                                    highlightColor: Colors.white,
                                    child: Row(
                                      spacing: 10,
                                      children: [
                                        for (var i = 0; i < widget.numberLength; i++)
                                          Flexible(
                                            child: ColorFiltered(
                                              colorFilter: ColorFilter.mode(Colors.transparent, BlendMode.dst),
                                              child: ColorChangeNumberContainer(shimmer: true, index: i, number: numbers[i], numberLength: numbers.length, isCompleted: isCompleted, isWrong: isWrong,)
                                            )
                                          )
                                      ],
                                    ),
                                  ),
                                  Row(
                                    spacing: 10,
                                    children: [
                                      for (var i = 0; i < widget.numberLength; i++)
                                        Flexible(
                                            child: ColorFiltered(
                                                colorFilter: ColorFilter.mode(Colors.transparent, BlendMode.dst),
                                                child: ColorChangeNumberContainer(shimmer: false, index: i, number: numbers[i], numberLength: numbers.length, isCompleted: isCompleted, isWrong: isWrong,)
                                            )
                                        )
                                    ],
                                  ),
                                ],
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ColorChangeNumberContainer extends StatefulWidget {
  const ColorChangeNumberContainer({
    super.key,
    this.shimmer = false,
    this.duration = const Duration(milliseconds: 500),
    required this.index,
    required this.number,
    required this.numberLength,
    required this.isCompleted,
    required this.isWrong
  });

  final bool shimmer;
  final Duration duration;
  final int index;
  final String number;
  final int numberLength;
  final bool isCompleted;
  final bool isWrong;

  @override
  State<ColorChangeNumberContainer> createState() => _ColorChangeNumberContainerState();
}

class _ColorChangeNumberContainerState extends State<ColorChangeNumberContainer> with TickerProviderStateMixin {

  late AnimationController _animationController;

  final Color startColor = CustomColor.greyLightest;
  final Color endColor = Colors.white;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 100));
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
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: (widget.number == "") ? (widget.shimmer) ? CustomColor.greyLightest : CustomColor.greyLightest.withOpacity(0) : (widget.isWrong) ? CustomColor.redLightest : Colors.white,
                border: (widget.number == "") ? Border.all(width: 1, color: CustomColor.greyLightest.withOpacity(0)) : Border.all(width: 1, color: (widget.isWrong) ? CustomColor.redLightest : CustomColor.greyLightest.withOpacity(widget.isCompleted ? 0 : 1))
            ),
            child: Center(
              child: Text(widget.number, style: style[TextType.title1]?.merge(TextStyle(color: widget.isWrong ? CustomColor.red : CustomColor.blue, fontWeight: FontWeight.w700))),
            ),
          ),
        );
  }
}

