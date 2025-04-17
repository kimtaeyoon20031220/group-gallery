import 'package:flutter/material.dart';
import 'package:group_gallery/widgets/public/colors.dart';
import 'package:group_gallery/widgets/public/text.dart';
import 'package:group_gallery/widgets/public/wide_button.dart';

class MapBallScreen extends StatefulWidget {
  const MapBallScreen({super.key});

  @override
  State<MapBallScreen> createState() => _MapBallScreenState();
}

class _MapBallScreenState extends State<MapBallScreen> {

  List<bool> isSelected = [false, true];
  List<double> loc = [0,0];
  final GlobalKey<_MapBallState> mapBallKey = GlobalKey<_MapBallState>();

  bool isMagnetic = false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("맵볼", style: style[TextType.footnote]),
      ),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              MapBall(
                key: mapBallKey,
                width: 300,
                height: 300,
                initialMapType: MapType.quadrant,
                lineTitle: MapAlign(left: "Social", right: "Solo", top: "Creative", bottom: "Classic"),
                loc: (value) {
                  setState(() {
                    loc = value;
                  });
                },
                initialLoc: [0.0, 0.0],
                magnetic: isMagnetic,
              ),
              Row(
                children: [
                  Expanded(
                    child: Center(
                      child: ToggleButtons(
                        isSelected: isSelected,
                        onPressed: (value) {
                          setState(() {
                            isSelected = List.filled(2, false);
                            isSelected[value] = true;
                            mapBallKey.currentState?.setMapType = [MapType.none, MapType.quadrant][value];
                            mapBallKey.currentState?.updatePoint();
                          });
                        },
                        children: [
                          Padding(padding: const EdgeInsets.all(7), child: Text("none")),
                          Padding(padding: const EdgeInsets.all(7), child: Text("quadrant"))
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: WideButton(
                      text: "Magnetic",
                      inactiveText: "None",
                      isActivate: isMagnetic,
                      onTap: () {
                        setState(() {
                          isMagnetic = !isMagnetic;
                        });
                      },
                    ),
                  )
                ],
              ),
              Text("x: ${loc[0]}, y: ${loc[1]}, 위치: ${mapBallKey.currentState?.getQuad}"),
              TextButton(onPressed: () {
                mapBallKey.currentState?.setPoint = [0.0, 0.0];
              }, child: Text("move to (0,0)")),
              TextButton(onPressed: () {
                mapBallKey.currentState?.setPoint = [100.0, 100.0];
              }, child: Text("move to (100,100)")),
              TextButton(onPressed: () {
                mapBallKey.currentState?.setPoint = [100.0, -100.0];
              }, child: Text("move to (100,-100)"))
            ]
          ),
        ),
      ),
    );
  }
}

enum MapType { quadrant, none }
class MapAlign {
  final String left;
  final String right;
  final String top;
  final String bottom;
  const MapAlign({ required this.left, required this.right, required this.top, required this.bottom });
}
class PointTitle {
  final double number;
  final String title;
  const PointTitle({ required this.number, required this.title });
}

class MapBall extends StatefulWidget {
  const MapBall({
    super.key,
    required this.width,
    required this.height,
    this.initialMapType = MapType.none,
    required this.loc,
    this.pointRadius = 25,
    this.lineTitle = const MapAlign(left: "", right: "", top: "", bottom: ""),
    this.magnetic = true,
    this.magneticRadius = 15,
    this.initialLoc = const [0.0, 0.0]
  });

  final double width;
  final double height;
  final MapType initialMapType;
  final Function(List<double>) loc;
  final int pointRadius;
  final MapAlign lineTitle;
  final bool magnetic;
  final int magneticRadius;
  final List<double> initialLoc;

  @override
  State<MapBall> createState() => _MapBallState();
}

class _MapBallState extends State<MapBall> with TickerProviderStateMixin {

  Offset _position = const Offset(0.0, 0.0);
  MapType mapType = MapType.none;

  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
    mapType = widget.initialMapType;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _position = locToOffset(widget.initialLoc);
  }

  bool onPanDown = false;

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void updateOffset(Offset details) {
    if (details.dx >= widget.pointRadius
        && details.dx <= widget.width - widget.pointRadius
    ) {
      if (widget.magnetic && (getPoint(details)[0].abs()) < widget.magneticRadius) {
        if (details.dy >= widget.pointRadius && details.dy <= widget.height - widget.pointRadius) {
          _position = Offset(locToOffset([0.0, 0.0]).dx, details.dy);
        }
        if (getPoint(details)[1].abs() < widget.magneticRadius) {
          _position = locToOffset([0.0, 0.0]);
        }
      } else {
        _position = Offset(details.dx, _position.dy);
      }
    }
    if (details.dy >= widget.pointRadius
        && details.dy <= widget.height - widget.pointRadius) {
      if (widget.magnetic && (getPoint(details)[1].abs()) < widget.magneticRadius) {
        if (details.dx >= widget.pointRadius && details.dx <= widget.width - widget.pointRadius) {
          _position = Offset(details.dx, locToOffset([0.0, 0.0]).dy);
        }
        if (getPoint(details)[0].abs() < widget.magneticRadius) {
          _position = locToOffset([0.0, 0.0]);
        }
      } else {
        _position = Offset(_position.dx, details.dy);
      }
    }
    setState(() {
      updatePoint();
    });
  }

  List<double> getPoint(Offset position) {
    switch (mapType) {
      case MapType.quadrant: {
        return [(position.dx - widget.pointRadius / 2) - ((widget.width - widget.pointRadius) / 2), ((widget.height - widget.pointRadius) / 2) - (position.dy - widget.pointRadius / 2)];
      }
      case MapType.none: {
        return [position.dx - widget.pointRadius, position.dy - widget.pointRadius];
      }
    }
  }

  Offset locToOffset(List<double> loc) {
    switch (mapType) {
      case MapType.quadrant: {
        return Offset(widget.width / 2 + loc[0], widget.height / 2 - loc[1]);
      }
      case MapType.none: {
        return Offset(widget.pointRadius + loc[0], widget.pointRadius + loc[1]);
      }
    }
  }

  set setPoint(loc) {
    setState(() {
      updateOffset(locToOffset(loc));
    });
    updatePoint();
  }

  void updatePoint() {
    widget.loc(getPoint(_position));
  }

  set setMapType(MapType newValue) {
    setState(() {
      mapType = newValue;
    });
  }

  get getMapType {
    return mapType;
  }

  get getQuad {
    final pos = getPoint(_position);
    switch (mapType) {
      case MapType.quadrant: {
        if (pos[0] > 0 && pos[1] > 0) { return 0; } // 1사분면
        else if (pos[0] > 0 && pos[1] < 0) { return 1; } // 2사분면
        else if (pos[0] < 0 && pos[1] < 0) { return 2; } // 3사분면
        else if (pos[0] < 0 && pos[1] > 0) { return 3; } // 4사분면
        else if (pos[0] == 0 && pos[1] != 0) { return 4; } // x축 위
        else if (pos[0] != 0 && pos[1] == 0) { return 5; } // y축 위
        else if (pos[0] == 0 && pos[1] == 0) { return 6; } // 원점
        else { return 7; } // 오류
      }
      case MapType.none: {
        return 0; // 사분면 없음, 1면
      }
    }
  }

  int getPointQuad() {
    final pointLoc = getPoint(_position);
    switch (mapType) {
      case MapType.quadrant: {
        if (pointLoc[0] > 0 && pointLoc[1] > 0) { return 0; }
        else if (pointLoc[0] > 0 && pointLoc[1] < 0) { return 1; }
        else if (pointLoc[0] < 0 && pointLoc[1] < 0) { return 2; }
        else { return 3; }
      }
      case MapType.none: { return 0; }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Stack(
        children: [
          Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: CustomColor.greyLightest
            ),
          ),
          AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: mapType == MapType.quadrant ? 1 : 0,
            child: Container(
              margin: EdgeInsets.fromLTRB(0, widget.height / 2, 0, 0),
              width: double.infinity,
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    CustomColor.greyLight.withOpacity(0),
                    CustomColor.greyLight.withOpacity(1),
                    CustomColor.greyLight.withOpacity(0)
                  ]
                )
              ),
            ),
          ),
          AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: mapType == MapType.quadrant ? 1 : 0,
            child: Container(
              margin: EdgeInsets.fromLTRB(widget.width / 2, 0, 0, 0),
              width: 1,
              height: widget.height,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        CustomColor.greyLight.withOpacity(0),
                        CustomColor.greyLight.withOpacity(1),
                        CustomColor.greyLight.withOpacity(0)
                      ]
                  )
              ),
            ),
          ),
          (mapType == MapType.quadrant) ?
              Positioned.fill(
                child: Stack(
                  children: [
                    Positioned(
                      top: 10,
                      left: 0,
                      right: 0,
                      child: Text(widget.lineTitle.top, style: style[TextType.footnote]?.merge(TextStyle(color: CustomColor.greyLight)), textAlign: TextAlign.center),
                    ),
                    Positioned(
                      top: 0,
                      bottom: 0,
                      right: 10,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(widget.lineTitle.right, style: style[TextType.footnote]?.merge(TextStyle(color: CustomColor.greyLight))),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      left: 0,
                      right: 0,
                      child: Text(widget.lineTitle.bottom, style: style[TextType.footnote]?.merge(TextStyle(color: CustomColor.greyLight)),  textAlign: TextAlign.center),
                    ),
                    Positioned(
                      top: 0,
                      bottom: 0,
                      left: 10,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(widget.lineTitle.left, style: style[TextType.footnote]?.merge(TextStyle(color: CustomColor.greyLight))),
                        ],
                      ),
                    ),
                  ],
                ),
              ) :
              Positioned.fill(
                child: Stack(
                  children: [
                    Positioned(
                      bottom: 10,
                      left: 0,
                      right: 0,
                      child: Text(widget.lineTitle.bottom, style: style[TextType.footnote]?.merge(TextStyle(color: CustomColor.greyLight)), textAlign: TextAlign.center,),
                    ),
                    Positioned(
                      top: 0,
                      bottom: 0,
                      right: 10,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(widget.lineTitle.right, style: style[TextType.footnote]?.merge(TextStyle(color: CustomColor.greyLight))),
                        ],
                      ),
                    ),
                  ]
                ),
              ),
          Positioned(
              left: _position.dx - widget.pointRadius,
              top: _position.dy - widget.pointRadius,
              child: ScaleTransition(
                scale: Tween(begin: 1.2, end: 1.0).animate(CurvedAnimation(parent: animationController, curve: Curves.easeOutCirc)),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: widget.pointRadius * 2,
                  height: widget.pointRadius * 2,
                  decoration: BoxDecoration(
                      color: onPanDown ? CustomColor.black : CustomColor.grey,
                      shape: BoxShape.circle
                  ),
                ),
              )
          ),
          Positioned.fill(
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  updateOffset(details.localPosition);
                });
              },
              onPanDown: (details) {
                updateOffset(details.localPosition);
              },
              onPanStart: (details) {
                setState(() {
                  onPanDown = true;
                });
                animationController.reverse();
              },
              onPanEnd: (details) {
                setState(() {
                  onPanDown = false;
                });
                animationController.reverse().then((_) {
                  animationController.forward();
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
