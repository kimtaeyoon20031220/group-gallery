import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void setUiOverlayStyle (isDarkMode) {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.white, // Color for Android
      statusBarIconBrightness:
      isDarkMode ? Brightness.light : Brightness.dark,
      statusBarBrightness: isDarkMode
          ? Platform.isIOS
          ? Brightness.dark
          : Brightness.light
          : Platform.isIOS
          ? Brightness.light
          : Brightness.dark
  ));
}

enum ThemeType { dark, light }

void setUiOverlayStyleIOS (ThemeType type) {
  SystemChrome.setSystemUIOverlayStyle(type == ThemeType.dark ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light);
}