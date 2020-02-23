import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_package/coulped_transition.dart';

/// A class used to specify the [Tween], [Duration] and [Curve] for an animation
///
///
/// For example
/// class MyStatelessWidget extends StatelessWidget {
///   @override
///   Widget build(BuildContext context) {
///     return Scaffold(
///       body: SafeArea(
///         child: CoupledTransition(
///           child: Container(
///             child: Text("Hello World"),
///           ),
///           fadeAnimation: Transition(
///             tween: Tween(begin: 0, end: 3),
///             duration: Duration(seconds: 2),
///             curve: Curves.bounceInOut
///           ),
///         ),
///       ),
///     );
///   }
/// }
class Transition<T>{
  Tween<T> tween;
  Duration duration;
  Curve curve;


  ///Create a [Transition]
  Transition({@required this.tween, this.duration, this.curve});
}


