import 'package:flutter/material.dart';
import 'random_words.dart';

// one line function can use arrow notation
void main() => runApp(MyApp());

// In Flutter, almost everything is a widget, including alignment, padding, and layout.

// Widget's main job is to provide a build() method that describes how to display
// the widget in terms of other, lower level widgets. A bit like React components...

// A stateless widget is immutable, meaning that its properties can't change
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      theme: ThemeData.dark(),
      home: RandomWords()
    );
  }
}
