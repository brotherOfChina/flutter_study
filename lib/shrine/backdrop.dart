import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const Cubic _kAccelerateCurve = Cubic(0.548, 0.0, 0.757, 0.464);
const Cubic _kDecelerateCurve = Cubic(0.23, 0.94, 0.41, 1.0);
const double _kPeakVelocityTime = 0.248210;
const double _kPeakVelocityProgress = 0.379146;

class _FrontLayer extends StatelessWidget {
  final VoidCallback onTap;
  final Widget child;

  const _FrontLayer({Key key, this.onTap, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 16.0,
      shape: const BeveledRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(46.0))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onTap,
            child: Container(
              height: 40.0,
              alignment: AlignmentDirectional.centerStart,
            ),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _BackdropTitle extends AnimatedWidget {
  final Function onPress;
  final Widget frontTitle;
  final Widget backTitle;

  _BackdropTitle(this.onPress, this.frontTitle, this.backTitle);

  @override
  Widget build(BuildContext context) {
    return null;
  }
}

class BackDrop extends StatefulWidget {
  final Widget frontLayer;
  final Widget backLayer;
  final Widget frontTitle;
  final Widget backTitle;
  final AnimationController controller;

  const BackDrop(
      {Key key,
      this.frontLayer,
      this.backLayer,
      this.frontTitle,
      this.backTitle,
      this.controller})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return null;
  }
}

class _BackdropState extends State<BackDrop>
    with SingleTickerProviderStateMixin {
  final GlobalKey _backdropKey = GlobalKey(debugLabel: 'Backdrop');
  AnimationController _controller;
  Animation<RelativeRect> _layerAnimation;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _frontLayerVisible {
    final AnimationStatus status = _controller.status;
    return status == AnimationStatus.completed ||
        status == AnimationStatus.forward;
  }

  void _toggleBackdropLayerVisibility() {
    setState(() {
      _frontLayerVisible ? _controller.reverse() : _controller.forward();
    });
  }

  Animation<RelativeRect> _getLayerAnimation(Size layerSize, double layerTop) {
    Curve firstCurve;
    Curve secondCurve;
    double firstWeight;
    double secondWeight;
    Animation<double> animation;
    if (_frontLayerVisible) {}
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }
}
