# extended_transition
Extended Transition is an open source package with new transitions for animations in flutter


## Widgets
 * `CoupledTransition` - A widget that can handle multiple transitions on its child simultaneously
 * Other transitions coming soon...

## Examples

* [Simple example](https://github.com/JosteveGit/coupled_transition_example) - A simple container with rotation and slide transitions


## Usage

A basic demo
```dart
import 'package:flutter/material.dart';

import 'package:extended_transitions/coupled_transition/coupled_transition.dart';
import 'package:extended_transitions/coupled_transition/coupled_transition_controller.dart';
import 'package:extended_transitions/coupled_transition/transition.dart';




void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CoupledTransitionController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CoupledTransition(
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 50,
              margin: EdgeInsets.symmetric(horizontal: 10),
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
              child: Center(
                  child: Text(
                "Lesser codes...Better animations",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
                overflow: TextOverflow.clip,
              )),
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Colors.blue, Colors.red]),
                  borderRadius: BorderRadius.circular(4)),
            ),
          ),
          build: (CoupledTransitionController controller) {
            this.controller = controller;
          },
          useCommonController: true,
          commonDuration: Duration(seconds: 3),
          rotationAnimation:
              Transition(tween: Tween(begin: 1, end: 4), curve: Curves.ease),
          slideAnimation:
              Transition(tween: Tween(begin: Offset(2, 0), end: Offset.zero)),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.startAll();
          controller.repeatAll(reverse: true);
        },
      ),
    );
  }
}


```

## Contributors
  * [Josteve Adekanbi](https://github.com/JosteveGit)

