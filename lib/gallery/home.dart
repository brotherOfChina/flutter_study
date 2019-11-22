import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_study/gallery/demos.dart';

const String _kGalleryAssesPackage = "flutter_gallery_assets";
const Color _kFltterBlue = Color(0xFF003D75);
const double _kDemoItemHeight = 64.0;
const Duration _kFrontLayerSwitchDurration = Duration(milliseconds: 300);

class _FlutterLogo extends StatelessWidget {
  const _FlutterLogo({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: Container(
        width: 34.0,
        height: 34.0,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("logos/flutter_white/logo.png",
                package: _kGalleryAssesPackage),
          ),
        ),
      ),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final GalleryDemoCategory category;
  final VoidCallback onTap;

  const _CategoryItem({Key key, this.category, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme=Theme.of(context);
    final bool isDark=theme.brightness==Brightness.dark;

    return null;
  }
}
