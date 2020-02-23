import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'transition.dart';
import 'coupled_transition_controller.dart';


/// Can animate the scale, rotation, opacity, position relative to its normal position, its won size and clips and its [Align.alignment] property.

class CoupledTransition extends StatefulWidget {
  /// Create multiple transitions transition on a widget.
  ///
  /// The [child] argument must not be null.

  CoupledTransition({
    Key key,
    @required this.child,
    this.useCommonController = false,
    this.useCommonCurve = false,
    this.commonCurve = Curves.ease,
    this.commonDuration,
    this.build(CoupledTransitionController trigger),
    this.fadeAnimation,
    this.scaleAnimation,
    this.sizeAnimation,
    this.slideAnimation,
    this.rotationAnimation,
    this.alignmentAnimation,
  }): assert(child !=null),super(key: key);

  /// The widget below this widget in the tree
  ///
  /// {@macro flutter.widgets.child}
  final Widget child;

  /// Allows the use of a common animation controller across all transitions.
  ///
  /// if [useCommonController] is true then all transitions (except those with durations specified) will be controlled by  [commonController]
  final bool useCommonController;

  /// The Duration used on all transitions when using common controller
  ///
  /// if [useCommonController] is true, [commonDuration] cannot be null
  final Duration commonDuration;

  /// Similar to [useCommonController]. if true then all transitions (except those with curves specified) will be depend on [commonCurve]
  final bool useCommonCurve;

  /// The common curve to be used by every transition if [useCommonCurve] is set to true
  final Curve commonCurve;

  /// A call back function that can return the current [CoupledTransitionController] giving access to all controllers
  ///
  /// For example
  /// class MyStateFulWidget extends StatefulWidget {
  ///   @override
  ///   _MyStateFulWidgetState createState() => _MyStateFulWidgetState();
  /// }
  ///
  /// class _MyStateFulWidgetState extends State<MyStateFulWidget> {
  ///
  ///   TransitionController controller;
  ///
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     return Scaffold(
  ///       body: SafeArea(
  ///         child: CoupledTransition(
  ///           child: Container(
  ///             child: Text("Hello World"),
  ///           ),
  ///           build: (TransitionController controller){
  ///             this.controller = controller;
  ///           },
  ///         ),
  ///       ),
  ///       floatingActionButton: FloatingActionButton(
  ///         onPressed: (){
  ///           controller.startAll();
  ///         },
  ///       ),
  ///     );
  ///   }
  /// }
  final Function build;

  /// A [Transition] that sets the [Tween], [Curve], [Duration] for the [fadeAnimation].
  ///
  /// [Tween] is required while [Curve] and [Duration] are optional. If [Curve] is null
  /// then [commonCurve] is used if [useCommonCurve] is true else [Curves.ease].
  ///
  /// if [Duration] is null then [commonDuration] is used if [useCommonController] is true else duration is set to Duration(seconds: 0)
  final Transition<double> fadeAnimation;

  /// A [Transition] that sets the [Tween], [Curve], [Duration] for the [scaleAnimation].
  ///
  /// [Tween] is required while [Curve] and [Duration] are optional. If [Curve] is null
  /// then [commonCurve] is used if [useCommonCurve] is true else [Curves.ease].
  ///
  /// if [Duration] is null then [commonDuration] is used if [useCommonController] is true else duration is set to Duration(seconds: 0)
  final Transition<double> scaleAnimation;

  /// A [Transition] that sets the [Tween], [Curve], [Duration] for the [sizeAnimation].
  ///
  /// [Tween] is required while [Curve] and [Duration] are optional. If [Curve] is null
  /// then [commonCurve] is used if [useCommonCurve] is true else [Curves.ease].
  ///
  /// if [Duration] is null then [commonDuration] is used if [useCommonController] is true else duration is set to Duration(seconds: 0)
  final Transition<double> sizeAnimation;

  /// A [Transition] that sets the [Tween], [Curve], [Duration] for the [slideAnimation].
  ///
  /// [Tween] is required while [Curve] and [Duration] are optional. If [Curve] is null
  /// then [commonCurve] is used if [useCommonCurve] is true else [Curves.ease].
  ///
  /// if [Duration] is null then [commonDuration] is used if [useCommonController] is true else duration is set to Duration(seconds: 0)
  final Transition<Offset> slideAnimation;

  /// A [Transition] that sets the [Tween], [Curve], [Duration] for the [rotationAnimation].
  ///
  /// [Tween] is required while [Curve] and [Duration] are optional. If [Curve] is null
  /// then [commonCurve] is used if [useCommonCurve] is true else [Curves.ease].
  ///
  /// if [Duration] is null then [commonDuration] is used if [useCommonController] is true else duration is set to Duration(seconds: 0)
  final Transition<double> rotationAnimation;

  /// A [Transition] that sets the [Tween], [Curve], [Duration] for the [alignmentAnimation].
  ///
  /// [Tween] is required while [Curve] and [Duration] are optional. If [Curve] is null
  /// then [commonCurve] is used if [useCommonCurve] is true else [Curves.ease].
  ///
  /// if [Duration] is null then [commonDuration] is used if [useCommonController] is true else duration is set to Duration(seconds: 0)
  final Transition<AlignmentGeometry> alignmentAnimation;

  /// Subclasses typically do not override this method.
  @override
  _CoupledTransitionState createState() => _CoupledTransitionState();
}

class _CoupledTransitionState extends State<CoupledTransition>
    with TickerProviderStateMixin
    implements CoupledTransitionController {

  ///Common AnimationController to control every transition (that is not null) without duration
  AnimationController commonController;

  ///Scale Transition AnimationController to control the scale of the widget
  AnimationController scaleTransitionController;

  ///Fade Transition AnimationController to control the opacity of the widget
  AnimationController fadeTransitionController;

  ///Size Transition AnimationController to control the size of the widget
  AnimationController sizeTransitionController;

  ///Scale Transition AnimationController to control the position relative to the normal position of the widget [widget.child]
  AnimationController slideTransitionController;

  ///Size Transition AnimationController to control the rotation of the widget
  AnimationController rotationTransitionController;

  ///Size Transition AnimationController to control the [Align.alignment] property of the widget
  AnimationController alignmentTransitionController;

  @override
  void initState() {
    super.initState();

    ///Initializing the [commonController] is [widget.useCommonController] is true
    if (widget.useCommonController) {
      assert(widget.commonDuration != null);
      commonController = AnimationController(vsync: this, duration: widget.commonDuration);
    }

    initializeAllControllers();
  }

  ///Initialize (if it can )each individual controller for different transitions
  initializeAllControllers() {
    if (initSingleController(widget.scaleAnimation)) {
      scaleTransitionController = AnimationController(
          vsync: this, duration: widget.scaleAnimation.duration);
    }

    if (initSingleController(widget.fadeAnimation)) {
      fadeTransitionController = AnimationController(
          vsync: this, duration: widget.fadeAnimation.duration);
    }

    if (initSingleController(widget.sizeAnimation)) {
      sizeTransitionController = AnimationController(
          vsync: this, duration: widget.sizeAnimation.duration);
    }

    if (initSingleController(widget.slideAnimation)) {
      slideTransitionController = AnimationController(
          vsync: this, duration: widget.slideAnimation.duration);
    }

    if (initSingleController(widget.rotationAnimation)) {
      rotationTransitionController = AnimationController(
          vsync: this, duration: widget.rotationAnimation.duration);
    }

    if (initSingleController(widget.alignmentAnimation)) {
      alignmentTransitionController = AnimationController(
          vsync: this, duration: widget.alignmentAnimation.duration);
    }
  }

  ///A function to check if a transition controller may be initialized or not
  bool initSingleController(Transition transition) {
    if (transition != null) {
      if (transition.duration != null) {
        assert(transition.tween != null);
        return true;
      }
    }
    return false;
  }

  /// If true, [commonController] will be used for the transitions (if [widget.useCommonController] is also true)
  bool validate(Transition transition) {
    if (transition != null) {
      return transition.duration == null;
    }
    return true;
  }

  /// Returns the controller to be used for a transition
  ///
  /// If the transition is null or (the controller is null and [widget.useCommonController] is not true
  /// then a default supportive sudo [AnimationController] is created and returned
  ///
  /// If [widget.useCommonController] is true and the transition is validate then
  ///   If the transition tween is not null then [commonController] drives the tween
  ///   If the transition tween is null then a default supportive sudo [AnimationController] is created and returned
  ///
  /// If none of the above assumptions is true then the controller passed drives the tween
  getAnim<T>(AnimationController controller, Transition transition) {
    AnimationController newController = AnimationController(vsync: this, duration: Duration(seconds: 0));
    if (transition == null || (controller==null && !widget.useCommonController)) {
      if (T == double) {
        return newController.drive(Tween<double>(begin: 1, end: 1));
      } else if (T == Offset) {
        return newController
            .drive(Tween<Offset>(begin: Offset.zero, end: Offset.zero));
      } else if (T == AlignmentGeometry) {
        return newController.drive(Tween<AlignmentGeometry>(
            begin: Alignment.center, end: Alignment.center));
      }
    }
    else if (widget.useCommonController && validate(transition)) {
      if (transition.tween != null) {
        return commonController.drive(transition.tween
            .chain(CurveTween(curve: getCurve(transition.curve))));
      } else {
        if (T == double) {
          return commonController.drive(Tween<double>(begin: 1, end: 1));
        } else if (T == Offset) {
          return commonController
              .drive(Tween<Offset>(begin: Offset.zero, end: Offset.zero));
        } else if (T == AlignmentGeometry) {
          return commonController.drive(Tween<AlignmentGeometry>(
              begin: Alignment.center, end: Alignment.center));
        }
      }
    } else {
      assert(transition.tween != null);
      return controller.drive(
          transition.tween.chain(CurveTween(curve: getCurve(transition.curve))));
    }
  }

  @override
  Widget build(BuildContext context) {
    widget.build(this);
    return ScaleTransition(
        scale:
            getAnim<double>(scaleTransitionController, widget.scaleAnimation),
        child: FadeTransition(
          opacity:
              getAnim<double>(fadeTransitionController, widget.fadeAnimation),
          child: SizeTransition(
            sizeFactor:
                getAnim<double>(sizeTransitionController, widget.sizeAnimation),
            child: SlideTransition(
                position: getAnim<Offset>(
                    slideTransitionController, widget.slideAnimation),
                child: RotationTransition(
                    turns: getAnim<double>(
                        rotationTransitionController, widget.rotationAnimation),
                    child: AlignTransition(
                      alignment: getAnim<AlignmentGeometry>(
                          alignmentTransitionController,
                          widget.alignmentAnimation),
                      child: widget.child,
                    ))),
          ),
        ));
  }

  /// Returns [commonCurve] is [widget.useCommonCurve] is true
  /// Returns the curve passed if it (the curve) is not null and [commonCurve] is false or null
  /// Returns [Curves.ease] if none of the above assumptions is true
  Curve getCurve(Curve transitionCurve) {
    if (widget.useCommonCurve != null &&
        widget.useCommonCurve &&
        transitionCurve == null) {
      assert(widget.commonCurve != null);
      return widget.commonCurve;
    }
    return transitionCurve == null ? Curves.ease : transitionCurve;
  }

  /// Returns [widget.commonCurve] if it is not null else flags an error
  get commonCurve {
    assert(widget.commonCurve != null);
    return widget.commonCurve;
  }


  /// Function to start all nonnull controllers simultaneously
  @override
  void startAll() {
    if (widget.commonDuration != null) {
      try {
        commonController.forward();
      } catch (e) {
        //
      }
    }
    startController(scaleTransitionController);
    startController(fadeTransitionController);
    startController(sizeTransitionController);
    startController(slideTransitionController);
    startController(rotationTransitionController);
    startController(alignmentTransitionController);
  }

  @override
  AnimationController getCommonAnimationController() {
    return commonController;
  }

  @override
  AnimationController getFadeTransitionAnimationController() {
    return fadeTransitionController;
  }

  @override
  AnimationController getRotationTransitionAnimationController() {
    return rotationTransitionController;
  }

  @override
  AnimationController getScaleTransitionAnimationController() {
    return scaleTransitionController;
  }

  @override
  AnimationController getSizeTransitionAnimationController() {
    return sizeTransitionController;
  }

  @override
  AnimationController getSlideTransitionAnimationController() {
    return slideTransitionController;
  }


  /// Function to repeat all controllers simultaneously.
  /// If reverse is true then repetition occurs in the reverse manner
  @override
  void repeatAll({bool reverse}) {
    repeatController(commonController, true);
    repeatController(scaleTransitionController, true);
    repeatController(fadeTransitionController, true);
    repeatController(sizeTransitionController, true);
    repeatController(slideTransitionController, true);
    repeatController(rotationTransitionController, true);
  }

  /// Function to reverse all controllers simultaneously
  @override
  void reverseAll() {
    reverseController(commonController);
    reverseController(scaleTransitionController);
    reverseController(fadeTransitionController);
    reverseController(sizeTransitionController);
    reverseController(slideTransitionController);
    reverseController(rotationTransitionController);
  }


  /// Function to stop all controllers simultaneously
  @override
  void stopAll() {
   stopController(commonController);
   stopController(scaleTransitionController);
   stopController(fadeTransitionController);
   stopController(sizeTransitionController);
   stopController(slideTransitionController);
   stopController(rotationTransitionController);
  }

  void repeatController(AnimationController controller, bool reverse){
    if(controller != null){
      try{
        controller.repeat(reverse: reverse);
      }catch(e){
        //
      }
    }
  }

  void stopController(AnimationController controller){
    if(controller !=null){
      try{
        controller.stop();
      }catch(e){
        //
      }
    }
  }

  void reverseController(AnimationController controller){
    if(controller !=null){
      try{
        controller.reverse();
      }catch(E){
        //
      }
    }
  }


  void startController(AnimationController controller) {
    if (controller != null) {
      try {
        if (!controller.isAnimating) {
          controller.forward();
        }
      } catch (e) {
        //
      }
    }

  }
}
