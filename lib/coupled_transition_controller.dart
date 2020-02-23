import 'package:flutter/animation.dart';


/// An interface like abstract class that declare methods that will be implemented
abstract class CoupledTransitionController{
  void startAll();
  void stopAll();
  void reverseAll();
  void repeatAll({bool reverse});
  AnimationController getCommonAnimationController();
  AnimationController getScaleTransitionAnimationController();
  AnimationController getFadeTransitionAnimationController();
  AnimationController getSizeTransitionAnimationController();
  AnimationController getSlideTransitionAnimationController();
  AnimationController getRotationTransitionAnimationController();
}