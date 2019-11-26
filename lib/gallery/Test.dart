import 'package:flutter/material.dart';

class Test extends StatefulWidget{
  const Test({Key key}):super (key:key);
  static const String routeName = '/Test';
  @override
  State<StatefulWidget> createState() {
    return TestState();
  }
}
class TestState extends State<Test>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: Text("Test"),
    );
  }

}