import 'package:flutter/cupertino.dart';

class RouteDemo {
  final String title;
  final String subTitle;
  final IconData icon;
  final String routeName;
  final String documentationUrl;
  final WidgetBuilder buildRoute;

  RouteDemo({this.title, this.subTitle, this.icon, this.routeName,
      this.documentationUrl, this.buildRoute});
}
