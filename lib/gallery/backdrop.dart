import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

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
    _active = widget.controller.status == widget.status;
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

class _BackAppBar extends StatelessWidget {
  final Widget leading;
  final Widget title;
  final Widget trailing;

  const _BackAppBar({Key key, this.leading, this.title, this.trailing})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = <Widget>[
      Container(
        alignment: Alignment.center,
        width: 56.0,
        child: leading,
      ),
      Expanded(child: title)
    ];
    if (trailing != null) {
      children.add(Container(
        alignment: Alignment.center,
        width: 56.0,
        child: trailing,
      ));
    }
    final ThemeData theme = Theme.of(context);

    return IconTheme.merge(
        data: theme.primaryIconTheme,
        child: DefaultTextStyle(
            style: theme.primaryTextTheme.title,
            child: SizedBox(
              height: _kBackAppBarHeight,
              child: Row(
                children: children,
              ),
            )));
  }
}

class Backdrop extends StatefulWidget {
  final Widget frontAction;
  final Widget frontTitle;
  final Widget frontLayer;
  final Widget frontHeading;
  final Widget backTitle;
  final Widget backLayer;

  const Backdrop(
      {Key key,
      this.frontAction,
      this.frontTitle,
      this.frontLayer,
      this.frontHeading,
      this.backTitle,
      this.backLayer})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _BackdropState();
  }
}

class _BackdropState extends State<Backdrop>
    with SingleTickerProviderStateMixin {
  final GlobalKey _backdropKey = GlobalKey(debugLabel: 'Backdrop');
  AnimationController _controller;
  Animation<double> _frontOpacity;
  static final Animatable<double> _frontOpacityTween =
      Tween(begin: 0.2, end: 1.0).chain(
          CurveTween(curve: const Interval(0.0, 0.4, curve: Curves.easeInOut)));

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 300), value: 1.0, vsync: this);
    _frontOpacity = _controller.drive(_frontOpacityTween);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double get _backdropHeight {
    // Warning: this can be safely called from the event handlers but it may
    // not be called at build time.
    final RenderBox renderBox = _backdropKey.currentContext.findRenderObject();
    return math.max(
        0.0, renderBox.size.height - _kBackAppBarHeight - _kFrontClosedHeight);
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    _controller.value -=
        details.primaryDelta / (_backdropHeight ?? details.primaryDelta);
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_controller.isAnimating ||
        _controller.status == AnimationStatus.completed) {
      return;
    }
    final double flingVelocity =
        details.velocity.pixelsPerSecond.dy / _backdropHeight;
    if (flingVelocity < 0.0) {
      _controller.fling(velocity: math.max(2.0, -flingVelocity));
    } else if (flingVelocity > 0.0) {
      _controller.fling(velocity: math.min(-2.0, -flingVelocity));
    } else {
      _controller.fling(velocity: _controller.value < 0.5 ? -2.0 : 2.0);
    }
  }

  void _toggleFrontLayer() {
    final AnimationStatus status = _controller.status;
    final bool isOpen = status == AnimationStatus.completed ||
        status == AnimationStatus.forward;
    _controller.fling(velocity: isOpen ? -2.0 : 2.0);
  }

  Widget _buildStack(BuildContext context, BoxConstraints constraints) {
    final Animation<RelativeRect> frontRelativeRect =
        _controller.drive(RelativeRectTween(
      begin: RelativeRect.fromLTRB(
          0.0, constraints.biggest.height - _kFrontClosedHeight, 0.0, 0.0),
      end: const RelativeRect.fromLTRB(0.0, _kBackAppBarHeight, 0.0, 0.0),
    ));
    final List<Widget> layers = <Widget>[
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _BackAppBar(
            leading: widget.frontAction,
            title: _CrossFadeTransition(
              progress: _controller,
              alignment: AlignmentDirectional.centerStart,
              child0: Semantics(
                namesRoute: true,
                child: widget.frontTitle,
              ),
              child1: Semantics(
                namesRoute: true,
                child: widget.backTitle,
              ),
            ),
            trailing: IconButton(
                icon: AnimatedIcon(
                  icon: AnimatedIcons.close_menu,
                  progress: _controller,
                ),
                tooltip: 'toggle options page',
                onPressed: _toggleFrontLayer),
          ),
          Expanded(
            child: Visibility(
              child: widget.backLayer,
              visible: _controller.status != AnimationStatus.completed,
              maintainState: true,
            ),
          )
        ],
      ),
      PositionedTransition(
        rect: frontRelativeRect,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (BuildContext context, Widget child) {
            return PhysicalShape(
              elevation: 12.0,
              clipper: ShapeBorderClipper(
                  shape: BeveledRectangleBorder(
                borderRadius:
                    _kFrontHeadingBeveRadius.transform(_controller.value),
              )),
              color: Theme.of(context).canvasColor,
              clipBehavior: Clip.antiAlias,
              child: child,
            );
          },
          child: _TapAbleWhileStatusIs(
            status: AnimationStatus.completed,
            controller: _controller,
            child: FadeTransition(
              opacity: _frontOpacity,
              child: widget.frontLayer,
            ),
          ),
        ),
      ),
    ];
    if (widget.frontHeading != null) {
      layers.add(PositionedTransition(
        rect: frontRelativeRect,
        child: ExcludeSemantics(
          child: Container(
            alignment: Alignment.topLeft,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _toggleFrontLayer,
              onVerticalDragUpdate: _handleDragUpdate,
              onVerticalDragEnd: _handleDragEnd,
              child: widget.frontHeading,
            ),
          ),
        ),
      ));
    }
    return Stack(
      key: _backdropKey,
      children: layers,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: _buildStack,
    );
  }
}
