// Stateful widgets maintain state that might change during the lifetime of the widget.
// StatefulWidget class is, itself, immutable and can be thrown away and regenerated,
// but the State class persists over the lifetime of the widget.
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

class RandomWords extends StatefulWidget {
  // just creates an instance of state.
  @override
  _RandomWordsState createState() => _RandomWordsState();
}

// Prefixing an identifier with an underscore enforces privacy in Dart,
// similar to convention for class fields in C#. Privacy is recommended best practice for State objects.
// The following is a private class.
class _RandomWordsState extends State<RandomWords> {

  // [] is a list, like in Python
  final _suggestions = <WordPair>[];
  // fontSize is a named optional parameter
  final _biggerFont = TextStyle(fontSize: 18.0);
  final _saved = Set<WordPair>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Startup Name Generator'),
          actions: [IconButton(icon: Icon(Icons.list), onPressed: _pushSaved,)]
      ),
      body: _buildSuggestions(),
    );
  }

  Widget _buildSuggestions() {
    return ListView.builder(
        padding: EdgeInsets.all(16.0),
        // anonymous function with braces (i.e. statement block) does not take arrow notation
        // this method is called once per row in the ListView
        itemBuilder: (context, i) {
          if (i.isOdd) return Divider();

          // final type must be initialised unless class member
          // explicitly specifying type is optional
          // ~/ is integer division. Never seen something like this before
          final index = i ~/ 2;

          // not enough suggestions? Add more to the list
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10));
          }
          return _buildRow(_suggestions[index]);
        }
    );
  }

  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair);
    return ListTile(
        title: Text(
            pair.asPascalCase,
            style: _biggerFont
        ),
        trailing: Icon(
          alreadySaved ? Icons.favorite : Icons.favorite_border,
          color: alreadySaved ? Colors.red : null,
        ),
        onTap: () {
          // calling setState() triggers a call to the build() method for the State object,
          // resulting in an update to the UI. Wow, this is exactly like React
          setState(() {
            if (alreadySaved) {
              _saved.remove(pair);
            } else {
              _saved.add(pair);
            }
          });
        }
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(
        MaterialPageRoute<void>(
          // builder is a (anonymous) factory method that constructs the page content
            builder: (BuildContext context) {
              final tiles = _saved.map(
                      (WordPair pair) {
                    return ListTile(
                      title: Text(
                        pair.asPascalCase,
                        style: _biggerFont,
                      ),
                    );
                  }
              );

              final divided = ListTile.divideTiles(tiles: tiles, context: context).toList();

              return Scaffold(
                appBar: AppBar(
                    title: Text('Saved Suggestions')
                ),
                // a different method of constructing a ListView. In _buildSuggestions(),
                // we use a factory pattern; here we give it ListTile instances
                body: ListView(children: divided),
              );
            }
        )
    );
  }
}
