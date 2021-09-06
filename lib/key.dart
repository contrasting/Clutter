import 'package:flutter/material.dart';

// https://medium.com/flutter/keys-what-are-they-good-for-13cb51742e7d

class PositionedTiles extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PositionedTilesState();
}

class PositionedTilesState extends State<PositionedTiles> {
  // ok
  final statelessTiles = [
    StatelessColorfulTile(),
    StatelessColorfulTile(),
  ];

  // not ok. Need to add key
  final statefulTiles = [
    StatefulColorfulTile(),
    StatefulColorfulTile(),
  ];

  // ok (as long as not cached in state)
  final statefulArgTiles = [
    StatefulColorfulTile(color: Colors.yellow),
    StatefulColorfulTile(color: Colors.blue),
  ];

  @override
  Widget build(BuildContext context) {
    final active = statefulTiles;
    return Scaffold(
      body: Row(children: active),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.sentiment_very_satisfied),
        onPressed: () {
          swapTiles(active);
        },
      ),
    );
  }

  swapTiles(List<Widget> widgets) {
    setState(() {
      widgets.insert(1, widgets.removeAt(0));
    });
  }
}

class StatelessColorfulTile extends StatelessWidget {
  final Color myColor = UniqueColorGenerator.getColor();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: myColor,
      child: Padding(padding: EdgeInsets.all(70.0)),
    );
  }
}

class StatefulColorfulTile extends StatefulWidget {
  final Color? color;

  const StatefulColorfulTile({Key? key, this.color}) : super(key: key);

  @override
  ColorfulTileState createState() => ColorfulTileState();
}

class ColorfulTileState extends State<StatefulColorfulTile> {
  late Color myColor;

  @override
  void initState() {
    super.initState();
    myColor = UniqueColorGenerator.getColor();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.color ?? myColor,
      child: Padding(
        padding: EdgeInsets.all(70.0),
      ),
    );
  }
}

abstract class UniqueColorGenerator {
  static int _index = 0;

  static Color getColor() {
    int i = _index;
    _index++;
    if (_index == Colors.primaries.length) _index = 0;
    return Colors.primaries[i];
  }
}
