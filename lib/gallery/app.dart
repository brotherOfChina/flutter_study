import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_study/gallery/home.dart';
import 'package:flutter_study/gallery/options.dart';
import 'package:flutter_study/gallery/scales.dart';
import 'package:flutter_study/gallery/themes.dart';
import 'package:flutter_study/gallery/updater.dart';
import 'package:flutter_study/shrine/model/app_state_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'demos.dart';

import 'package:flutter/foundation.dart' show defaultTargetPlatform;

import 'package:flutter/scheduler.dart' show timeDilation;

class GalleryApp extends StatefulWidget {
  final UpdateUrlFetcher updateUrlFetcher;
  final bool enablePerformanceOverlay;
  final bool enableRasterCacheImagesCheckerboard;
  final bool enableOffscreenLayersCheckerboard;
  final VoidCallback onSendFeedback;
  final bool testMode ;

  const GalleryApp(
      {Key key,
      this.updateUrlFetcher,
      this.enablePerformanceOverlay=true,
      this.enableRasterCacheImagesCheckerboard=true,
      this.enableOffscreenLayersCheckerboard=true,
      this.onSendFeedback,
      this.testMode=false})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _GalleryAppState();
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
      value: (dynamic demo) => demo.builderRoute,
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
    Widget home = GalleryHome(
      testMode: widget.testMode,
      optionsPage: GalleryOptionsPage(
        options: _options,
        onOptionsChanged: _handleOptionsChanged,
        onSendFeedback: widget.onSendFeedback ??
            () {
              launch('https://github.com/flutter/flutter/issues/new/choose',
                  forceSafariVC: false);
            },
      ),
    );
    if (widget.updateUrlFetcher != null) {
      home = Updater(
        updateUrlFetcher: widget.updateUrlFetcher,
        child: home,
      );
    }
    return ScopedModel<AppStateModel>(
        model: model,
        child: MaterialApp(
          theme: kLightGalleryTheme.copyWith(platform: _options.platform),
          darkTheme: kDarkGalleryTheme.copyWith(platform: _options.platform),
          themeMode: _options.themeMode,
          title: "Flutter Gallery",
          color: Colors.grey,
          showPerformanceOverlay: _options.showPerformanceOverlay,
          checkerboardOffscreenLayers: _options.showOffscreenLayersCheckerboard,
          checkerboardRasterCacheImages:
              _options.showRasterCacheImagesCheckerboard,
          routes: _buildRoutes(),
          builder: (BuildContext context, Widget child) {
            return Directionality(
              textDirection: _options.textDirection,
              child: _applyTextScaleFactor(
                Builder(builder: (context) {
                  return CupertinoTheme(
                    data: CupertinoThemeData(
                      brightness: Theme.of(context).brightness,
                    ),
                    child: child,
                  );
                }),
              ),
            );
          },
          home: home,
        ));
  }
}
