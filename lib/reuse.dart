import 'package:flutter/material.dart';

/* How to reuse logic between different flutter components?
*
* Rather unfortunately, the official flutter docs don't really have much to say on this
* (as far as I could find). Luckily, flutter is a reactive paradigm, and React does
* have some things to say about this.
*
* With functional components in React, you could just extract the logic into
* custom hooks, but hooks aren't a thing in flutter.
*
* Edit: hooks are actually a thing in flutter!
*
* People coming from a non-declarative paradigm would be forgiven for the next
* most natural thing that comes to mind, i.e. inheritance. But why is this
* not such a good idea? Take a look at the following:
* */

class A extends StatelessWidget {
  const A({Key? key}) : super(key: key);

  void _signUp() {
    // ...
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text('Sign Up'),
      onPressed: _signUp,
    );
  }
}

class B extends A {
  const B({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.star),
      onPressed: _signUp,
    );
  }
}

/* The sign up method is shared between A and B.
* This is not bad, but it's not really true that B is an extension of A, it's just
* a different type of A. However, how would you share logic between stateless and stateful
* components?
*
* And the problem becomes even more complicated when the widgets are stateful:
* */

class C extends StatefulWidget {
  const C({Key? key}) : super(key: key);

  @override
  _CState createState() => _CState();
}

class _CState extends State<C> {
  void _signUp() {
    setState(() {
      //...
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text('Sign Up'),
      onPressed: _signUp,
    );
  }
}

class D extends StatefulWidget {
  final String username;

  const D({Key? key, required this.username}) : super(key: key);

  @override
  _DState createState() => _DState();
}

class _DState extends _CState {
  @override
  Widget build(BuildContext context) {
    // not accessible
    // widget.username
    return IconButton(
      icon: Icon(Icons.star),
      onPressed: _signUp,
    );
  }
}

/* Now, because the logic is in the state class, it's the state classes that inherit.
* This will compile, BUT you would not be able to access fields in the stateful widget
* like you normally do, because D state extends C state, which itself extends State<C>!!
*
* Clearly we need a better way of sharing logic between components than inheritance.
* As stated at https://reactjs.org/docs/composition-vs-inheritance.html,
* we should really be using composition rather than inheritance to reuse code.
*
* Option 1: mixins. Edit: Mixins are actually not great, because they don't allow
* for composition of widgets. See option 2 for a better way
* */

mixin SignUpMixin {
  void signUp() {
    // ...
  }
}

class E extends StatelessWidget with SignUpMixin {
  const E({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text('Sign Up'),
      onPressed: signUp,
    );
  }
}

class F extends StatelessWidget with SignUpMixin {
  const F({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.star),
      onPressed: signUp,
    );
  }
}

/* What if the mixin needs to call setState? You might be tempted to pass the state
* itself, but the compiler will warn you about calling setState outside the stateful
* widget, because it's protected.
*
* To be honest, I don't really see a problem with this, and you could probably ignore
* the warning with impunity. Like inheritance, the real issue comes with sharing logic
* between stateless and stateful components, because you can't pass a state from a stateless widget!
* */

mixin SignUpMixin2 {
  void signUp<T extends StatefulWidget>(State<T> state) {
    // ...
    // compiler warning
    state.setState(() {});
  }
}

class G extends StatefulWidget {
  const G({Key? key}) : super(key: key);

  @override
  _GState createState() => _GState();
}

class _GState extends State<G> with SignUpMixin2 {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.star),
      onPressed: () {
        // not great
        signUp(this);
      },
    );
  }
}

/* The solution? Simply don't call setState from the mixin, and delegate it to the state.
* */

class H extends StatefulWidget {
  const H({Key? key}) : super(key: key);

  @override
  _HState createState() => _HState();
}

class _HState extends State<H> with SignUpMixin {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.star),
      onPressed: () {
        // better
        setState(() {
          signUp();
        });
      },
    );
  }
}

/* Option 2: builder method or "render props"
*
* "Traditionally in React, we’ve had two popular ways to share stateful logic between
*  components: render props and higher-order components." From https://reactjs.org/docs/hooks-custom.html
*
* What is this? Intuitively, we might be tempted to pass the widget to be rendered
* down as a prop, but the problem is, it wouldn't be able to use the logic:
* */

class SignUpButton extends StatelessWidget {
  final Widget button;

  const SignUpButton({Key? key, required this.button}) : super(key: key);

  void _signUp() {
    // ...
  }

  @override
  Widget build(BuildContext context) {
    // how to make button call _signUp()??
    return button;
  }
}

/* So the solution? To pass the logic back up via a builder method: */

class SignUpButton2 extends StatelessWidget {
  final Widget Function(void Function() signUp) builder;

  const SignUpButton2({Key? key, required this.builder}) : super(key: key);

  void _signUp() {
    // ...
  }

  @override
  Widget build(BuildContext context) {
    return builder(_signUp);
  }
}

class SignUpApp extends StatelessWidget {
  const SignUpApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SignUpButton2(
      builder: (signUp) {
        // or TextButton, or whatever
        return IconButton(
          icon: Icon(Icons.star),
          onPressed: signUp,
        );
      },
    );
  }
}

/* Pretty cool, pretty cool. In this way, the sign up logic can be reused anywhere
* in the app. Similarly for a stateful widget.
*
* Option 3: higher-order widgets or "HOWs"
*
* "Concretely, a higher-order component is a function that takes a component and returns a new component."
* From https://reactjs.org/docs/higher-order-components.html
*
* I have to say, this one is a new and rather alien concept to me. I don't think it's
* actually possible in flutter, because dart doesn't allow this kind of type mutation
* like in javascript.
*
* TODO
*/