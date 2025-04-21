import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:group_gallery/screens/works/mapBallScreen.dart';
import 'package:group_gallery/screens/works/tossSegmentedPickerScreen.dart';
import 'package:group_gallery/screens/works/tossVerifyCodeScreen.dart';
import 'package:group_gallery/screens/workScreen.dart';
import 'package:group_gallery/screens/works/tossWireScreen.dart';

import '../screens/errorScreen.dart';
import '../screens/groupScreen.dart';
import '../screens/groupSettingsScreen.dart';
import '../screens/homeScreen.dart';
import '../screens/lockScreen.dart';
import '../screens/photoScreen.dart';

Route pageRoute(settings) {
  switch (settings.name) {
    case '/home': return pageRouteBuilder(HomeScreen(), TransitionType.fromBottom, settings);
    case '/lock': {
      final args = settings.arguments as LockScreenArgs;
      return pageRouteBuilder(LockScreen(args: args), TransitionType.fromRight, settings);
    }
    case '/group': {
      final args = settings.arguments as GroupScreenArgs;
      return pageRouteBuilder(GroupScreen(args: args), TransitionType.fromRight, settings);
    }
    case '/group/settings': {
      final args = settings.arguments as GroupSettingsScreenArgs;
      return pageRouteBuilder(GroupSettingsScreen(args: args), TransitionType.fromRight, settings);
    }
    case '/group/photo': {
      final args = settings.arguments as PhotoScreenArgs;
      return pageRouteBuilder(PhotoScreen(args: args), TransitionType.fromRight, settings);
    }
    case '/toss_verify_code': {
      return pageRouteBuilder(TossVerifyCodeScreen(), TransitionType.fromRight, settings);
    }
    case '/work': {
      return pageRouteBuilder(WorkScreen(), TransitionType.fromRight, settings);
    }
    case '/map_ball': {
      return pageRouteBuilder(MapBallScreen(), TransitionType.fromRight, settings);
    }
    case '/toss_segmented_picker': {
      return pageRouteBuilder(TossSegmentedPickerScreen(), TransitionType.fromRight, settings);
    }
    case '/toss_wire': {
      return pageRouteBuilder(TossWireScreen(), TransitionType.fromRight, settings);
    }
    default: return pageRouteBuilder(ErrorScreen(), TransitionType.fromBottom, settings);
  }
}

PageRouteBuilder pageRouteBuilder(Widget nextScreen, TransitionType transitionType, dynamic settings) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => nextScreen,
    settings: settings,
    transitionsBuilder: (context, animation, secondaryAnimation, child) => transition(context, animation, secondaryAnimation, child, transitionType)
  );
}

enum TransitionType { fromBottom, fromTop, fromLeft, fromRight, fadeInScaleUp, fadeIn }

class SlideCurvedTransition extends StatelessWidget {
  const SlideCurvedTransition({
    super.key,
    required this.begin,
    required this.end,
    required this.animation,
    required this.child
  });

  final Offset begin;
  final Offset end;
  final Animation<double> animation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
        position: Tween<Offset>(
            begin: begin,
            end: end
        ).animate(
            CurvedAnimation(
                parent: animation,
                curve: Curves.linearToEaseOut,
                reverseCurve: Curves.easeInToLinear
            )
        ),
        child: child
    );
  }
}

Widget transition(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child, TransitionType transitionType) {
  switch (transitionType) {
    case TransitionType.fromBottom: {
      return SlideCurvedTransition(
        begin: const Offset(0.0, 1.0),
        end: const Offset(0.0, 0.0),
        animation: animation,
        child: SlideCurvedTransition(
          begin: const Offset(0.0, 0.0),
          end: const Offset(0.0, -0.33),
          animation: secondaryAnimation,
          child: child,
        ),
      );
    }
    case TransitionType.fromTop: {
      return SlideCurvedTransition(
        begin: const Offset(0.0, -1.0),
        end: const Offset(0.0, 0.0),
        animation: animation,
        child: SlideCurvedTransition(
          begin: const Offset(0.0, 0.0),
          end: const Offset(0.0, 0.33),
          animation: secondaryAnimation,
          child: child,
        ),
      );
    }
    case TransitionType.fromLeft: {
      return SlideCurvedTransition(
        begin: const Offset(-1.0, 0.0),
        end: const Offset(0.0, 0.0),
        animation: animation,
        child: SlideCurvedTransition(
          begin: const Offset(0.0, 0.0),
          end: const Offset(0.33, 0.0),
          animation: secondaryAnimation,
          child: child,
        ),
      );
    }
    case TransitionType.fromRight: {
      return SlideCurvedTransition(
        begin: const Offset(1.0, 0.0),
        end: const Offset(0.0, 0.0),
        animation: animation,
        child: SlideCurvedTransition(
          begin: const Offset(0.0, 0.0),
          end: const Offset(-0.33, 0.0),
          animation: secondaryAnimation,
          child: child,
        ),
      );
    }
    case TransitionType.fadeInScaleUp: {
      final curvedAnimation = CurvedAnimation(parent: animation, curve: Curves.easeOutCirc, reverseCurve: Curves.easeInCirc);
      return FadeTransition(
        opacity: Tween<double>(begin: 0.0, end: 1.0).animate(curvedAnimation),
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.0, end: 1.0).animate(curvedAnimation),
          child: child
        ),
      );
    }
    case TransitionType.fadeIn: {
      final curvedAnimation = CurvedAnimation(parent: animation, curve: Curves.easeOutCirc, reverseCurve: Curves.easeInCirc);
      return FadeTransition(
        opacity: Tween<double>(begin: 0.0, end: 1.0).animate(curvedAnimation),
        child: child,
      );
    }
  }




}