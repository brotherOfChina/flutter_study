import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

const double _kFrontHeadingHeight = 32.0;
const double _kFrontClosedHeight = 92.0;
const double _kBackAppBarHeight = 56.0;

final Animatable<BorderRadius> _kFrontHeadingBeveRadius = BorderRadiusTween(
    begin: const BorderRadius.only(
      topLeft: Radius.circular(12.0),
      topRight: Radius.circular(12.0),
    ),
    end: const BorderRadius.only(
        topLeft: Radius.circular(_kFrontClosedHeight),
        topRight: Radius.circular(_kFrontHeadingHeight)));

class _TapAbleWhileStatusIs extends StatefulWidget {
  final AnimationController controller;
  final AnimationStatus status;
  final Widget child;

  const _TapAbleWhileStatusIs(
      {Key key, this.controller, this.status, this.child})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _TapAbleWhileStatusIsState();
  }
}

class _TapAbleWhileStatusIsState extends State<_TapAbleWhileStatusIs> {
  bool _active;

  @override
  void initState() {
    super.initState();
    widget.controller.addStatusListener(_handleStatusChange);
  }

  void _handleStatusChange(AnimationStatus status) {
    final bool value = widget.controller.status == widget.status;
    if (_active != true) {
      setState(() {
        _active = value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: !_active,
      child: widget.child,
    );
  }
}

class _CrossFadeTransition extends AnimatedWidget {
  final AlignmentGeometry alignment;
  final Widget child0;
  final Widget child1;

  _CrossFadeTransition(
      {Key key,
      this.alignment,
      this.child0,
      this.child1,
      Animation<double> progress})
      : super(key: key, listenable: progress);

  @override
  Widget build(BuildContext context) {
    final Animation<double> progress = listenable;
    final double opacity1 = CurvedAnimation(
      parent: ReverseAnimation(progress),
      curve: const Interval(0.5, 1.0),
    ).value;
    final double opacity2 = CurvedAnimation(
      parent: progress,
      curve: const Interval(0.5, 1.0),
    ).value;

    return Stack(
      alignment: alignment,
      children: <Widget>[
        Opacity(
          opacity: opacity1,
          child: Semantics(
            scopesRoute: true,
            explicitChildNodes: true,
            child: child1,
          ),
        ),
        Opacity(
          opacity: opacity2,
          child: Semantics(
            scopesRoute: true,
            explicitChildNodes: true,
            child: child0,
          ),
        )
      ],
    );
  }
}
