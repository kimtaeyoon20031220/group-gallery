import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:group_gallery/widgets/public/image_button.dart';
import 'package:group_gallery/widgets/public/scalable_button_extend.dart';
import 'package:group_gallery/widgets/public/text.dart';
import 'package:group_gallery/widgets/public/wide_button.dart';
import 'package:group_gallery/widgets/public/scalable_button.dart';
import 'package:group_gallery/widgets/public/colors.dart';

import '../../curves/curved_animation.dart';

class TossWireScreen extends StatefulWidget {
  const TossWireScreen({super.key});

  @override
  State<TossWireScreen> createState() => _TossWireScreenState();
}

class TossWireData {
  const TossWireData({
    required this.accountNameFrom,
    required this.accountNumberFrom,
    required this.accountBankFrom,
    required this.accountNameTo,
    required this.accountNumberTo,
    required this.accountBankTo,
  });

  final String accountNameFrom;
  final String accountNumberFrom;
  final String accountBankFrom;

  final String accountNameTo;
  final String accountNumberTo;
  final String accountBankTo;
}

String numberComma(String number) {
  String result = "";
  for (int i = 0; i < number.length; i++) {
    result = number[number.length - i - 1] + (i % 3 == 0 ? "," : "") + result;
  }
  return result.substring(0, result.length - 1);
}

String numberMoney(String number) {
  String result = "";
  if (number.length >= 13) {
    result = "${numberComma(number.substring(0, number.length - 12))}조 ${numberComma(number.substring(number.length - 12, number.length - 8))}억 ${numberComma(number.substring(number.length - 8, number.length - 4))}만 ${numberComma(number.substring(number.length - 4, number.length))}";
  } else if (number.length >= 9) {
    result = "${numberComma(number.substring(0, number.length - 8))}억 ${numberComma(number.substring(number.length - 8, number.length - 4))}만 ${numberComma(number.substring(number.length - 4, number.length))}";
  } else if (number.length >= 5) {
    result = "${numberComma(number.substring(0, number.length - 4))}만 ${numberComma(number.substring(number.length - 4, number.length))}";
  } else {
    result = numberComma(number);
  }
  return result;
}

class _TossWireScreenState extends State<TossWireScreen> with SingleTickerProviderStateMixin {
  bool isTyping = true;
  bool isValid = false;
  String wireAmount = "0";

  TossWireData data = TossWireData(
    accountNameFrom: "내 입출금계좌",
    accountNumberFrom: "110-512-641308",
    accountBankFrom: "신한은행",
    accountNameTo: "김태윤",
    accountNumberTo: "100-1234-1234-11",
    accountBankTo: "토스뱅크",
  );

  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 600)
    );
    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant TossWireScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  void backToType() {
    setState(() {
      isTyping = true;
    });
  }

  bool backKeyEvent() {
    if (isTyping) {
      if (int.parse(wireAmount) > 0) {
        setState(() {
          wireAmount = "0";
          isValid = false;
        });
        return false;
      } else {
        return true;
      }
    } else {
      setState(() {
        isTyping = true;
      });
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        if (didPop) {
          return;
        }
        if (backKeyEvent()) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: ImageButton(
              onTap: () {
                if (isTyping) {
                  if (int.parse(wireAmount) > 0) {
                    setState(() {
                      wireAmount = "0";
                      isValid = false;
                    });
                  } else {
                    Navigator.pop(context);
                  }
                } else {
                  setState(() {
                    isTyping = true;
                  });
                }
              },
              icon: SvgPicture.asset("assets/icons/arrow-left.svg", color: CustomColor.greyLight)
          ),
        ),
        body: FadeTransition(
          opacity: Tween(begin: 0.0, end: 1.0).animate(animationController),
          child: Stack(
            children: [
              TossWireDecision(
                isTyping: isTyping,
                data: data,
                wireAmount: wireAmount,
                backToType: backToType,
              ),
              Column(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 100),
                          opacity: isTyping ? 1 : 0,
                          child: TossWireTypingScreen(
                            accountFromBalance: "34931",
                            data: data,
                            wireAmount: wireAmount,
                            changeWireAmount: (value) {
                              setState(() {
                                wireAmount = value;
                                isValid = true;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  IgnorePointer(
                    ignoring: !isTyping,
                    child: AnimatedSlide(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeOutCirc,
                      offset: isValid ? Offset.zero : Offset(0.0, 1.0),
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 100),
                        opacity: isTyping ? 1 : 0,
                        child: Stack(
                          children: [
                            Container(
                              width: double.infinity,
                              height: 50,
                              color: CustomColor.blue,
                            ),
                            WideButton(
                              isActivate: isValid,
                              text: "다음",
                              onTap: () {
                                setState(() {
                                  isTyping = false;
                                });
                              },
                              highlightColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              pressedColorOpacity: 0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  IgnorePointer(
                    ignoring: !isTyping,
                    child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 100),
                        opacity: isTyping ? 1 : 0,
                        child: _keypad()
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _keypad() {
    final keys = ['1','2','3','4','5','6','7','8','9','00','0','←'];
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          color: Colors.white,
          height: 280,
          child: GridView.count(
            crossAxisCount: 3,
            childAspectRatio: (constraints.maxWidth / 3) / (280 / 4),
            children: keys.map((k) => WideButton(
                text: k,
                pointColor: Colors.white,
                pressedColorDuration: Duration(milliseconds: 100),
                height: 300,
                textStyle: style[TextType.largeTitle]!,
                onTap: () {
                  if (k == "←") {
                    if (wireAmount.length - 1 == 0 || wireAmount == "") {
                      setState(() {
                        isValid = false;
                        wireAmount = "0";
                      });
                    } else {
                      setState(() {
                        isValid = true;
                        wireAmount = wireAmount.substring(0, wireAmount.length - 1);
                      });
                    }
                  } else if (k == "0" || k == "00") {
                    if (int.parse(wireAmount + k) == 0) {
                      setState(() {
                        isValid = false;
                        wireAmount = "0";
                      });
                    } else {
                      setState(() {
                        isValid = true;
                        wireAmount += k;
                      });
                    }
                  } else {
                    if (wireAmount == "0" || wireAmount == "") {
                      setState(() {
                        isValid = true;
                        wireAmount = k;
                      });
                    } else {
                      setState(() {
                        isValid = true;
                        wireAmount += k;
                      });
                    }
                  }
                }
            )).toList(),
          ),
        );
      },
    );
  }
}

class TossWireTypingScreen extends StatefulWidget {
  const TossWireTypingScreen({
    super.key,
    required this.data,
    required this.accountFromBalance,
    required this.wireAmount,
    required this.changeWireAmount
  });

  final TossWireData data;
  final String accountFromBalance;
  final String wireAmount;
  final Function(String value) changeWireAmount;

  @override
  State<TossWireTypingScreen> createState() => _TossWireTypingScreenState();
}

class _TossWireTypingScreenState extends State<TossWireTypingScreen> with SingleTickerProviderStateMixin {

  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(30, 10, 30, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    widget.data.accountNameFrom,
                    style: style[TextType.title3]?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    '에서',
                    style: style[TextType.title3],
                  ),
                ],
              ),
              SlideTransition(
                position: Tween(begin: Offset(0.4, 0.0), end: Offset.zero).animate(CurvedAnimation(parent: animationController, curve: Curves.easeOutCirc)),
                child: Row(
                  children: [
                    Text(
                      '잔액 ',
                      style: style[TextType.footnote]?.copyWith(color: CustomColor.greyLight),
                    ),
                    Text(
                      widget.accountFromBalance,
                      style: style[TextType.footnote]?.copyWith(color: CustomColor.black),
                    ),
                    Text(
                      '원',
                      style: style[TextType.footnote]?.copyWith(color: CustomColor.greyLight),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 60),
              Text(
                '${widget.data.accountBankTo} ${widget.data.accountNumberTo}',
                style: style[TextType.footnote]?.copyWith(color: CustomColor.greyLight),
              ),
              const SizedBox(height: 70),
              widget.wireAmount == "0" ? Padding(
                padding: const EdgeInsets.only(top: 10),
                child: ScalableButton(
                  button: (tapDown) => Container(
                    padding: const EdgeInsets.fromLTRB(10, 7, 10, 7),
                    child: Text("잔액 · ${numberComma(widget.accountFromBalance)}원 입력"),
                  ),
                  buttonColor: CustomColor.greyLightest,
                  borderRadius: 7,
                  onTap: () {
                    widget.changeWireAmount(widget.accountFromBalance);
                  },
                ),
              ) :
              Text(
                '${numberMoney(widget.wireAmount)}원',
                style: style[TextType.footnote]?.copyWith(color: CustomColor.greyLight),
              ),
            ],
          ),
        ),
        const Spacer(),
      ],
    );
  }
}

class TossWireDecision extends StatefulWidget {
  const TossWireDecision({
    super.key,
    required this.isTyping,
    required this.data,
    required this.wireAmount,
    required this.backToType
  });

  final bool isTyping;
  final TossWireData data;
  final String wireAmount;
  final Function() backToType;

  @override
  State<TossWireDecision> createState() => _TossWireDecisionState();
}

class _TossWireDecisionState extends State<TossWireDecision> with TickerProviderStateMixin {

  bool tapDown = false;
  late AnimationController animationController;
  late AnimationController textAnimationController;
  late Animation _textAnimation;
  late Animation _text2Animation;
  bool isTextAnimated = false;

  Matrix4 _buildTransform(double angle) {
    return Matrix4.identity()
      ..setEntry(0, 2, 0.001)
      ..rotateX(angle);
  }

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    textAnimationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500), reverseDuration: const Duration(milliseconds: 0));
    _textAnimation = Tween<double>(begin: 0.0, end: -1.0)
        .animate(CurvedAnimation(parent: textAnimationController, curve: Curves.ease));
    _text2Animation = Tween<double>(begin: 1.0, end: 0.0)
        .animate(CurvedAnimation(parent: textAnimationController, curve: Curves.ease));
    animationController.forward();
  }

  @override
  void didUpdateWidget(covariant TossWireDecision oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isTyping) {
      setState(() {
        isTextAnimated = false;
      });
      textAnimationController.reverse();
    } else {
      Future.delayed(const Duration(milliseconds: 200), () {
        setState(() {
          isTextAnimated = true;
        });
        textAnimationController.forward();
      });
    }
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final duration = const Duration(milliseconds: 600);
    final curve =  Curves.easeOutCirc;

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Stack(
          children: [
            AnimatedScale(
              scale: tapDown ? 0.95 : 1,
              duration: const Duration(milliseconds: 100),
              child: Stack(
                children: [
                  AnimatedPositioned(
                    duration: duration,
                    left: widget.isTyping ? 30 : 0,
                    top: widget.isTyping ? 90 : (screenHeight * 0.5) / 2,
                    curve: widget.isTyping ? Curves.ease : Curves.easeOutCirc,
                    child: ScalableButtonExtend(
                      scale: 1,
                      lock: widget.isTyping,
                      tapDown: (tapDownState) {
                        setState(() {
                          tapDown = tapDownState;
                        });
                      },
                      onTap: () {
                        setState(() {
                          widget.backToType();
                        });
                      },
                      button: SizedBox(
                        width: screenWidth,
                        height: 50,
                        child: AnimatedOpacity(
                          opacity: tapDown ? 0.6 : 1,
                          duration: const Duration(milliseconds: 100),
                          child: AnimatedAlign(
                            curve: widget.isTyping ? Curves.easeOutCirc : Curves.ease,
                            duration: duration,
                            alignment: widget.isTyping ? Alignment.topLeft : Alignment.topCenter,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AnimatedDefaultTextStyle(
                                    duration: duration,
                                    curve: curve,
                                    style: widget.isTyping ? style[TextType.title3]?.copyWith(fontWeight: FontWeight.w600) ?? TextStyle() : style[TextType.title1Bold] ?? TextStyle(),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.transparent
                                      ),
                                      clipBehavior: Clip.hardEdge,
                                      child: Stack(
                                        children: [
                                          AnimatedSlide(
                                            duration: const Duration(milliseconds: 300),
                                            offset: isTextAnimated ? Offset(0.0, -1.0) : Offset.zero,
                                            curve: CustomCurves.bounceOut,
                                            child: AnimatedBuilder(
                                              animation: textAnimationController,
                                              builder: (context, child) => Transform(
                                                alignment: Alignment.topCenter,
                                                transform: _buildTransform(_textAnimation.value),
                                                child: Text(
                                                  widget.data.accountNameTo,
                                                ),
                                              ),
                                            ),
                                          ),
                                          AnimatedSlide(
                                            duration: const Duration(milliseconds: 300),
                                            offset: isTextAnimated ? Offset.zero : Offset(0.0, 1.0),
                                            curve: CustomCurves.bounceOut,
                                            child: AnimatedBuilder(
                                              animation: textAnimationController,
                                              builder: (context, child) => Transform(
                                                transform: _buildTransform(_text2Animation.value),
                                                child: Text(
                                                    widget.data.accountNameTo,
                                                    style: isTextAnimated ? style[TextType.title1Bold]?.copyWith(color: CustomColor.blue) : style[TextType.title3]?.copyWith(color: CustomColor.blue)
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                ),
                                AnimatedDefaultTextStyle(
                                  duration: duration,
                                  curve: curve,
                                  style: widget.isTyping ? style[TextType.title3] ?? TextStyle() : style[TextType.title1Bold] ?? TextStyle(),
                                  child: Text(
                                    "님에게",
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  AnimatedPositioned(
                    duration: duration,
                    left: widget.isTyping ? 30 : 0,
                    top: widget.isTyping ? 165 : (screenHeight * 0.5 + 70) / 2,
                    curve: widget.isTyping ? Curves.ease : Curves.easeOutCirc,
                    child: ScalableButtonExtend(
                      scale: 1,
                      lock: widget.isTyping,
                      tapDown: (tapDownState) {
                        setState(() {
                          tapDown = tapDownState;
                        });
                      },
                      onTap: () {
                        setState(() {
                          widget.backToType();
                        });
                      },
                      button: Container(
                        width: screenWidth,
                        height: 100,
                        child: AnimatedOpacity(
                          opacity: tapDown ? 0.6 : 1,
                          duration: const Duration(milliseconds: 100),
                          child: AnimatedAlign(
                            curve: widget.isTyping ? Curves.easeOutCirc : Curves.ease,
                            duration: duration,
                            alignment: widget.isTyping ? Alignment.topLeft : Alignment.topCenter,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ScaleTransition(
                                    alignment: Alignment.centerLeft,
                                    scale: Tween(begin: 0.6, end: 1.0).animate(CurvedAnimation(parent: animationController, curve: Curves.easeOutCirc)),
                                    child: Container(
                                      constraints: BoxConstraints(
                                          maxWidth: widget.isTyping ? screenWidth - 30 : screenWidth
                                      ),
                                      child: AnimatedDefaultTextStyle(
                                        duration: duration,
                                        curve: curve,
                                        style: style[TextType.title1Bold]!.copyWith(color: widget.wireAmount == "0" ? CustomColor.greyLight.withOpacity(0.5) : CustomColor.black,),
                                        textAlign: widget.isTyping ? TextAlign.start : TextAlign.center,
                                        child: Text(
                                          widget.wireAmount == "0" ? "얼마나 보낼까요?" : widget.isTyping ? '${numberComma(widget.wireAmount)}원' : '${numberComma(widget.wireAmount)}원을\n보낼까요?',
                                          maxLines: widget.isTyping ? 1 : null,
                                          softWrap: false,
                                          overflow: TextOverflow.fade,
                                        ),
                                      ),
                                    )
                                  // ) :
                                  // SizedBox(
                                  //   width: MediaQuery.of(context).size.width,
                                  //   child: Text(
                                  //     '${numberComma(widget.wireAmount)}원을\n보낼까요?',
                                  //     style: style[TextType.title1Bold],
                                  //     textAlign: TextAlign.center,
                                  //     softWrap: false,
                                  //     overflow: TextOverflow.fade,
                                  //   ),
                                  // ),
                                  // AnimatedCrossFade(
                                  //   duration: const Duration(milliseconds: 50),
                                  //   firstChild:
                                  //   secondChild:
                                  //   crossFadeState: widget.isTyping ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned.fill(
                bottom: 0,
                child: Column(
                  children: [
                    Spacer(),
                    !widget.isTyping ? TossWireSend(isTyping: widget.isTyping, data: widget.data) : SizedBox(),
                  ],
                ))
          ]
      ),
    );
  }
}

class TossWireSend extends StatefulWidget {
  const TossWireSend({
    super.key,
    required this.isTyping,
    required this.data,
  });

  final bool isTyping;
  final TossWireData data;

  @override
  State<TossWireSend> createState() => _TossWireSendState();
}

class TossWireSendPost {
  const TossWireSendPost({ required this.title, required this.content });
  final String title;
  final String content;
}

class _TossWireSendState extends State<TossWireSend> {

  List<bool> isShowing = [false, false, false, false, false];
  late List<TossWireSendPost> posts = [
    TossWireSendPost(title: "받는 분에게 표시", content: ""),
    TossWireSendPost(title: "출금 계좌", content: ""),
    TossWireSendPost(title: "입금 계좌", content: "")
  ];

  @override
  void initState() {
    super.initState();
    setState(() {
      posts = [
        TossWireSendPost(title: "받는 분에게 표시", content: widget.data.accountNameTo),
        TossWireSendPost(title: "출금 계좌", content: widget.data.accountNameFrom),
        TossWireSendPost(title: "입금 계좌", content: "${widget.data.accountBankTo} ${widget.data.accountNumberTo}")
      ];
    });
    for (int i = 0; i < isShowing.length; i++) {
      Future.delayed(Duration(milliseconds: 30 * i), () {
        setState(() {
          isShowing[i] = true;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < 3; i++)
          slide(i, ScalableButton(
            onTap: () {},
            button: (tapDown) => Stack(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(30, 7, 30, 7),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7)
                  ),
                  child: Row(
                    children: [
                      Text(posts[i].title, style: style[TextType.footnote]?.copyWith(color: CustomColor.greyLight)),
                      Spacer(),
                      Text(posts[i].content, style: style[TextType.footnote]),
                      SvgPicture.asset("assets/icons/chevron-right.svg", width: 14,)
                    ],
                  ),
                ),
              ],
            ),
          )),
        slide(3, Padding(
          padding: const EdgeInsets.fromLTRB(30, 20, 30, 0),
          child: WideButton(text: "보내기"),
        )),
        slide(4, Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 20),
            height: 50,
            child: Center(
              child: ScalableButton(
                buttonColor: Colors.transparent,
                button: (tapDown) => Container(
                  padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7)
                  ),
                  child: Text("평생 수수료 무료", style: style[TextType.footnote]?.copyWith(color: CustomColor.greyLight)),
                ),
                onTap: () {},
              ),
            )
        ))
      ],
    );
  }

  Widget slide(index, child) {
    return AnimatedSlide(
      offset: isShowing[index] ? Offset.zero : Offset(0.0, 1.0),
      curve: Curves.easeOutCirc,
      duration: const Duration(milliseconds: 500),
      child: AnimatedOpacity(
          duration: const Duration(milliseconds: 100),
          opacity: isShowing[index] ? 1 : 0,
          child: child
      ),
    );
  }
}
