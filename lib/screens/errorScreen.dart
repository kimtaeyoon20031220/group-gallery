import 'package:flutter/material.dart';
import 'package:group_gallery/widgets/public/text.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Text("존재하지 않는 페이지입니다.", style: style[TextType.title1Bold])
        ),
      ),
    );
  }
}
