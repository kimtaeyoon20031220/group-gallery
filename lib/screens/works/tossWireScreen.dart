import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:group_gallery/widgets/public/button_darken.dart';
import 'package:group_gallery/widgets/public/image_button.dart';
import 'package:group_gallery/widgets/public/scalable_button_extend.dart';
import 'package:group_gallery/widgets/public/text.dart';
import 'package:group_gallery/widgets/public/wide_button.dart';
import 'package:group_gallery/widgets/public/scalable_button.dart';
import 'package:group_gallery/widgets/public/colors.dart';

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

class _TossWireScreenState extends State<TossWireScreen> with TickerProviderStateMixin {
  late AnimationController _keyboardFadeAnimation;

  bool isTyping = true;
  String wireAmount = "0";

  TossWireData data = TossWireData(
    accountNameFrom: "내 입출금계좌",
    accountNumberFrom: "110-512-641308",
    accountBankFrom: "신한은행",
    accountNameTo: "김토스",
    accountNumberTo: "100-1234-1234-11",
    accountBankTo: "토스뱅크",
  );

  @override
  void initState() {
    super.initState();
    _keyboardFadeAnimation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    _keyboardFadeAnimation.dispose();
    super.dispose();
  }

  void backToType() {
    setState(() {
      isTyping = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: ImageButton(
          onTap: () {
            if (isTyping) {
              Navigator.pop(context);
            } else {
              setState(() {
                isTyping = true;
              });
            }
          },
          icon: SvgPicture.asset("assets/icons/arrow-left.svg", color: CustomColor.greyLight)
        ),
      ),
      body: Stack(
        children: [
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
                      ),
                    ),
                  ],
                ),
              ),
              IgnorePointer(
                ignoring: !isTyping,
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
                        text: "다음",
                        onTap: () {
                          setState(() {
                            isTyping = !isTyping;
                          });
                        },
                        pressedColorOpacity: 0,
                      ),
                    ],
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
              )
            ],
          ),
          TossWireDecision(
              isTyping: isTyping,
              data: data,
              wireAmount: wireAmount,
              backToType: backToType,
          ),
        ],
      ),
    );
  }
  Widget _keypad() {
    final keys = ['1','2','3','4','5','6','7','8','9','00','0','←'];
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          height: 280,
          child: GridView.count(
            crossAxisCount: 3,
            childAspectRatio: (constraints.maxWidth / 3) / (280 / 4),
            children: keys.map((k) => WideButton(
              text: k,
              pointColor: Colors.white,
              height: 300,
              textStyle: style[TextType.largeTitle]!,
              onTap: () {
                setState(() {
                  if (k != "←") {
                    wireAmount += k;
                    if (wireAmount.isNotEmpty && wireAmount[0] == "0") {
                      wireAmount = wireAmount.substring(1, wireAmount.length);
                    }
                  } else {
                    wireAmount = wireAmount.substring(0, wireAmount.length - 1);
                    if (wireAmount.isEmpty) {
                      wireAmount = "0";
                    }
                  }
                });
              },
            )).toList(),
          ),
        );
      },
    );
  }
}

class TossWireTypingScreen extends StatelessWidget {
  const TossWireTypingScreen({
    super.key,
    required this.data,
    required this.accountFromBalance,
    required this.wireAmount,
  });

  final TossWireData data;
  final String accountFromBalance;
  final String wireAmount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      data.accountNameFrom,
                      style: style[TextType.title3]?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      '에서',
                      style: style[TextType.title3],
                    ),
                  ],
                ),
                Text(
                  '잔액 $accountFromBalance원',
                  style: style[TextType.footnote]?.copyWith(color: CustomColor.greyLight),
                ),
                const SizedBox(height: 70),
                Text(
                  '${data.accountBankTo} ${data.accountNumberTo}',
                  style: style[TextType.footnote]?.copyWith(color: CustomColor.greyLight),
                ),
                const SizedBox(height: 60),
                Text(
                  '$wireAmount원',
                  style: style[TextType.footnote]?.copyWith(color: CustomColor.greyLight),
                ),
              ],
            ),
          ),
          const Spacer(),
        ],
      ),
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

class _TossWireDecisionState extends State<TossWireDecision> with SingleTickerProviderStateMixin {

  bool tapDown = false;

  late AnimationController textOverAnimationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));

  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final duration = const Duration(milliseconds: 300);
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
                    top: widget.isTyping ? 120 : (screenHeight * 0.5) / 2,
                    curve: curve,
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
                            curve: curve,
                            duration: duration,
                            alignment: widget.isTyping ? Alignment.topLeft : Alignment.topCenter,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AnimatedDefaultTextStyle(
                                  duration: duration,
                                  curve: curve,
                                  style: widget.isTyping ? style[TextType.title3]?.copyWith(fontWeight: FontWeight.w600) ?? TextStyle() : style[TextType.title1Bold] ?? TextStyle(),
                                  child: Stack(
                                    children: [
                                      AnimatedSlide(
                                          duration: const Duration(milliseconds: 400),
                                          offset: widget.isTyping ? Offset.zero : Offset(0.0, -0.3),
                                          curve: Curves.easeOutCirc,
                                          child: AnimatedOpacity(
                                            duration: const Duration(milliseconds: 150),
                                            opacity: widget.isTyping ? 1 : 0,
                                            child: Text(
                                              widget.data.accountNameTo,
                                            ),
                                          ),
                                        ),
                                      AnimatedSlide(
                                        duration: const Duration(milliseconds: 400),
                                        offset: widget.isTyping ? Offset(0.0, 3.0) : Offset.zero,
                                        curve: Curves.easeOutCirc,
                                        child: AnimatedOpacity(
                                          duration: const Duration(milliseconds: 100),
                                          opacity: widget.isTyping ? 0 : 1,
                                          child: Text(
                                            widget.data.accountNameTo,
                                            style: widget.isTyping ? style[TextType.title3] ?? TextStyle() : style[TextType.title1Bold]?.copyWith(color: CustomColor.blue) ?? TextStyle(),
                                          ),
                                        ),
                                      ),
                                    ],
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
                  top: widget.isTyping ? 185 : (screenHeight * 0.5 + 70) / 2,
                  curve: curve,
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
                          curve: curve,
                          duration: duration,
                          alignment: widget.isTyping ? Alignment.topLeft : Alignment.topCenter,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AnimatedCrossFade(
                                duration: const Duration(milliseconds: 50),
                                firstChild: Text(
                                  '${widget.wireAmount}원',
                                  style: style[TextType.title1Bold],
                                ),
                                secondChild: Text(
                                  '${widget.wireAmount}원을\n보낼까요?',
                                  style: style[TextType.title1Bold],
                                  textAlign: TextAlign.center,
                                ),
                                crossFadeState: widget.isTyping ? CrossFadeState.showFirst : CrossFadeState.showSecond,
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
      Future.delayed(Duration(milliseconds: 50 * i), () {
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
                ButtonDarken(tapDown: tapDown)
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
              button: (tapDown) => Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7)
                    ),
                    child: Text("평생 수수료 무료", style: style[TextType.footnote]?.copyWith(color: CustomColor.greyLight)),
                  ),
                  ButtonDarken(tapDown: tapDown)
                ]
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
