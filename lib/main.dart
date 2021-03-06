import 'package:flutter/material.dart';
import 'configure_nonweb.dart' if (dart.library.html) 'configure_web.dart';
import 'routing.dart';
import 'random_words.dart';
import 'layout_demo.dart';
import 'animation.dart';
import 'websockets.dart';

// https://stackoverflow.com/questions/59870357/how-to-remove-hash-from-url-in-flutter-web

// one line function can use arrow notation
void main() {
  configureApp();
  runApp(WebSocketsApp());
}
