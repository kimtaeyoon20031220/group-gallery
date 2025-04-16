import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyNavigatorObserver extends NavigatorObserver {
  @override
  void didPop(Route route, Route? previousRoute) {
    // 돌아왔을 때 상태 복원
    if (previousRoute?.settings.name == '/home') {
      darken();
    }
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    if (route.settings.name == '/lock') {
      lighten();
    }
  }

  void lighten() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light
      )
    );
  }

  void darken() {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.dark.copyWith(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark
        )
    );
  }
}
