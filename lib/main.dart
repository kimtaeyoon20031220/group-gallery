import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:group_gallery/screens/groupScreen.dart';
import 'package:group_gallery/screens/groupSettingsScreen.dart';
import 'package:group_gallery/screens/homeScreen.dart';
import 'package:group_gallery/screens/lockScreen.dart';
import 'package:group_gallery/screens/photoScreen.dart';
import 'package:group_gallery/screens/workScreen.dart';
import 'package:group_gallery/utils/navigator_observer.dart';
import 'package:group_gallery/utils/route.dart';
import 'package:group_gallery/widgets/public/scalable_button.dart';
import 'package:group_gallery/widgets/public/text.dart';
import 'package:logger/logger.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final logger = Logger(printer: PrettyPrinter());
    return MaterialApp(
      navigatorObservers: [MyNavigatorObserver()],
      home: const Home(),
      theme: ThemeData(fontFamily: 'Pretendard'),
      onGenerateRoute: (settings) => pageRoute(settings)
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: TabBar(
          tabs: [
            Tab(icon: Text("홈")),
            Tab(icon: Text("작업"))
          ],
        ),
        body: const SafeArea(
          child: TabBarView(
            children: [
              HomeScreen(),
              WorkScreen()
            ]
          )
        )
      ),
    );
  }
}