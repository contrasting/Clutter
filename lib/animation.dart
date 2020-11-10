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
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
      });
    /*
      ..addListener(() {
        setState(() {
          // setState ostensibly doesn't do anything, but in fact marks the
          // current frame as dirty, so forces build() to be called.
          // the Container in build() changes size because it uses the animation's value
        });
      });
    */
    // this call starts the animation
    controller.forward();
  }

  // simplify by subclassing AnimatedWidget
  @override
  Widget build(BuildContext context) => AnimatedLogo(animation: animation,);
  /*
  {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        height: animation.value,
        width: animation.value,
        child: FlutterLogo(),
      ),
    );
  }
  */

  @override
  void dispose() {
    // do this to prevent mem leak
    controller.dispose();
    super.dispose();
  }
}

class AnimatedLogo extends AnimatedWidget {
  AnimatedLogo({Key key, Animation<double> animation})
      : super(key: key, listenable: animation);

  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        height: animation.value,
        width: animation.value,
        child: FlutterLogo(),
      ),
    );
  }
}