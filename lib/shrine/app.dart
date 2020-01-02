import 'package:flutter/material.dart';

class ShrineApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return null;
  }
}

class _ShrineAppState extends State<ShrineApp>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 450), value: 1.0);
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Shrine',
    );
  }
}
