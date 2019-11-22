import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_study/gallery/options.dart';
import 'package:flutter_study/gallery/scales.dart';
import 'package:flutter_study/gallery/updater.dart';
import 'package:flutter_study/shrine/model/app_state_model.dart';
import 'demos.dart';

import 'package:flutter/foundation.dart' show defaultTargetPlatform;

import 'package:flutter/scheduler.dart' show timeDilation;

class GalleryApp extends StatefulWidget {
  final UpdateUrlFetcher updateUrlFetcher;
  final bool enablePerformanceOverlay;
  final bool enableRasterCacheImagesCheckerboard;
  final bool enableOffscreenLayersCheckerboard;
  final VoidCallback onSendFeedback;
  final bool testMode;

  const GalleryApp(
      {Key key,
      this.updateUrlFetcher,
      this.enablePerformanceOverlay,
      this.enableRasterCacheImagesCheckerboard,
      this.enableOffscreenLayersCheckerboard,
      this.onSendFeedback,
      this.testMode})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return null;
  }
}

class _GalleryAppState extends State<GalleryApp> {
  GalleryOptions _options;
  Timer _timeDilationTimer;
  AppStateModel model;

  Map<String, WidgetBuilder> _buildRoutes() {
    return Map<String, WidgetBuilder>.fromIterable(
      kAllGalleryDemos,
      key: (dynamic demo) => "${demo.routeName}",
      value: (dynamic demo) => demo.buildRoute,
    );
  }

  @override
  void initState() {
    super.initState();
    _options = GalleryOptions(
      themeMode: ThemeMode.system,
      textScaleFactor: kAllGalleryTextScaleValues[0],
      timeDilation: timeDilation,
      platform: defaultTargetPlatform,
    );
    model = AppStateModel()..loadProducts();
  }

  @override
  void dispose() {
    _timeDilationTimer.cancel();
    _timeDilationTimer = null;
    super.dispose();
  }

  void _handleOptionsChanged(GalleryOptions newOptions) {
    setState(() {
      if (_options.timeDilation != newOptions.timeDilation) {
        _timeDilationTimer?.cancel();
        _timeDilationTimer = null;
        if (newOptions.timeDilation > 1.0) {
          _timeDilationTimer = Timer(const Duration(milliseconds: 150), () {
            timeDilation = newOptions.timeDilation;
          });
        } else {
          timeDilation = newOptions.timeDilation;
        }
      }
      _options = newOptions;
    });
  }

  Widget _applyTextScaleFactor(Widget child) {
    return Builder(
      builder: (BuildContext context) {
        return MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaleFactor: _options.textScaleFactor.scale),
            child: child);
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return null;
  }
}
