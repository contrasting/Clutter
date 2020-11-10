import 'package:flutter/material.dart';

class LogoApp extends StatefulWidget {
  _LogoAppState createState() => _LogoAppState();
}

class _LogoAppState extends State<LogoApp> with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
    animation = Tween<double>(begin: 0, end: 300).animate(controller)
    // this is dart cascade notation. Allows assigning object to a variable
    // as well as operation on it
      ..addListener(() {
        setState(() {
          // setState ostensibly doesn't do anything, but in fact marks the
          // current frame as dirty, so forces build() to be called.
          // the Container in build() changes size because it uses the animation's value
        });
      });
    // this call starts the animation
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        height: animation.value,
        width: animation.value,
        child: FlutterLogo(),
      ),
    );
  }

  @override
  void dispose() {
    // do this to prevent mem leak
    controller.dispose();
    super.dispose();
  }
}