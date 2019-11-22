import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_study/gallery/scales.dart';

class GalleryOptions {
  final ThemeMode themeMode;
  final GalleryTextScaleValue textScaleFactor;
  final TextDirection textDirection;
  final double timeDilation;
  final TargetPlatform platform;
  final bool showPerformanceOverlay;
  final bool showRasterCacheImagesCheckerboard;
  final bool showOffscreenLayersCheckerboard;

  GalleryOptions(
      {this.themeMode,
      this.textScaleFactor,
      this.textDirection = TextDirection.ltr,
      this.timeDilation = 1.0,
      this.platform,
      this.showPerformanceOverlay = false,
      this.showRasterCacheImagesCheckerboard = false,
      this.showOffscreenLayersCheckerboard = false});

  GalleryOptions copyWith(
      {ThemeMode themeMode,
      GalleryTextScaleValue textScaleFactor,
      TextDirection textDirection,
      double timeDilation,
      TargetPlatform platform,
      bool showPerformanceOverlay,
      bool showRasterCacheImagesCheckerboard,
      bool showOffscreenLayersCheckerboard}) {
    return GalleryOptions(
        themeMode: themeMode ?? this.themeMode,
        textScaleFactor: textScaleFactor ?? this.textScaleFactor,
        textDirection: textDirection ?? this.textDirection,
        timeDilation: timeDilation ?? this.timeDilation,
        platform: platform ?? this.platform,
        showPerformanceOverlay:
            showPerformanceOverlay ?? this.showPerformanceOverlay,
        showRasterCacheImagesCheckerboard: showRasterCacheImagesCheckerboard ??
            this.showRasterCacheImagesCheckerboard,
        showOffscreenLayersCheckerboard: showOffscreenLayersCheckerboard ??
            this.showOffscreenLayersCheckerboard);
  }

  @override
  bool operator ==(dynamic other) {
    if (runtimeType != other.runtimeType) return false;
    final GalleryOptions typedOther = other;
    return themeMode == typedOther.themeMode &&
        textScaleFactor == typedOther.textScaleFactor &&
        textDirection == typedOther.textDirection &&
        platform == typedOther.platform &&
        showPerformanceOverlay == typedOther.showPerformanceOverlay &&
        showRasterCacheImagesCheckerboard ==
            typedOther.showRasterCacheImagesCheckerboard &&
        showOffscreenLayersCheckerboard ==
            typedOther.showOffscreenLayersCheckerboard;
  }

  @override
  int get hashCode => hashValues(
      themeMode,
      textScaleFactor,
      textDirection,
      timeDilation,
      platform,
      showPerformanceOverlay,
      showRasterCacheImagesCheckerboard,
      showOffscreenLayersCheckerboard);

  @override
  String toString() {
    return "$runtimeType($themeMode)";
  }
}

const double _kItemHeight = 48.0;
const EdgeInsetsDirectional _kItemPadding =
    EdgeInsetsDirectional.only(start: 56.0);

//option 选项
class _OptionsItem extends StatelessWidget {
  const _OptionsItem({Key key, this.child}) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final double textScaleFactor = MediaQuery.textScaleFactorOf(context);
    return MergeSemantics(
      child: Container(
        constraints: BoxConstraints(minHeight: _kItemHeight * textScaleFactor),
        padding: _kItemPadding,
        alignment: AlignmentDirectional.centerStart,
        child: DefaultTextStyle(
          style: DefaultTextStyle.of(context).style,
          maxLines: 2,
          overflow: TextOverflow.fade,
          child:
              IconTheme(data: Theme.of(context).primaryIconTheme, child: child),
        ),
      ),
    );
  }
}

class _BooleanItem extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  final Key switchKey;

  const _BooleanItem(this.title, this.value, this.onChanged,
      {Key key, this.switchKey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return _OptionsItem(
      child: Row(
        children: <Widget>[
          Expanded(child: Text(title)),
          Switch(
            value: value,
            onChanged: onChanged,
            key: switchKey,
            activeColor: Color(0xff39cefd),
            activeTrackColor: isDark ? Colors.white30 : Colors.black26,
          )
        ],
      ),
    );
  }
}

class _ActionItem extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _ActionItem({Key key, this.text, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _OptionsItem(
      child: _FlatButton(
        onPressed: onTap,
        child: Text(text),
      ),
    );
  }
}

class _FlatButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;

  const _FlatButton({Key key, this.onPressed, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
        onPressed: onPressed,
        child: DefaultTextStyle(
            style: Theme.of(context).primaryTextTheme.subhead, child: child));
  }
}

//标题
class _Heading extends StatelessWidget {
  final String text;

  const _Heading({Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return _OptionsItem(
      child: DefaultTextStyle(
        style: themeData.textTheme.body1
            .copyWith(fontFamily: 'GoogleSans', color: themeData.accentColor),
        child: Semantics(
          child: Text(text),
          header: true,
        ),
      ),
    );
    return null;
  }
}

//主题选择控件
class _ThemeModeItem extends StatelessWidget {
  final GalleryOptions options;
  final ValueChanged<GalleryOptions> onOptionsChanged;

  static final Map<ThemeMode, String> modeLabels = <ThemeMode, String>{
    ThemeMode.system: "System Default",
    ThemeMode.light: "Light",
    ThemeMode.dark: "Dark",
  };

  const _ThemeModeItem({Key key, this.options, this.onOptionsChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _OptionsItem(
      child: Row(
        children: <Widget>[
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text("Theme"),
              Text(
                "${modeLabels[options.themeMode]}",
                style: Theme.of(context).primaryTextTheme.body1,
              ),
            ],
          )),
          PopupMenuButton<ThemeMode>(
            padding: EdgeInsetsDirectional.only(end: 16.0),
            icon: Icon(Icons.arrow_drop_down),
            initialValue: options.themeMode,
            itemBuilder: (BuildContext context) {
              return ThemeMode.values
                  .map<PopupMenuItem<ThemeMode>>((ThemeMode mode) {
                return PopupMenuItem(
                    value: mode, child: Text(modeLabels[mode]));
              }).toList();
            },
            onSelected: (ThemeMode mode) {
              onOptionsChanged(options.copyWith(themeMode: mode));
            },
          ),
        ],
      ),
    );
  }
}

//字体大小的控件
class _TextScaleFactorItem extends StatelessWidget {
  final GalleryOptions options;
  final ValueChanged<GalleryOptions> onOptionsChanged;

  const _TextScaleFactorItem({Key key, this.options, this.onOptionsChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _OptionsItem(
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              //辅轴，靠左排列
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Text Size"),
                Text(
                  "${options.textScaleFactor.label}",
                  style: Theme.of(context).primaryTextTheme.body1,
                ),
              ],
            ),
          ),
          PopupMenuButton(
            padding: EdgeInsetsDirectional.only(end: 16.0),
            icon: Icon(Icons.arrow_drop_down),
            itemBuilder: (BuildContext context) {
              return kAllGalleryTextScaleValues.map((scaleValue) {
                return PopupMenuItem(
                    value: scaleValue, child: Text(scaleValue.label));
              }).toList();
            },
            onSelected: (scaleValue) {
              onOptionsChanged(options.copyWith(textScaleFactor: scaleValue));
            },
          ),
        ],
      ),
    );
  }
}

class _TextDirectionItem extends StatelessWidget {
  final GalleryOptions options;
  final ValueChanged<GalleryOptions> onOptionsChanged;

  const _TextDirectionItem({Key key, this.options, this.onOptionsChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _BooleanItem(
      "Force RTL",
      options.textDirection == TextDirection.rtl,
      (bool value) {
        onOptionsChanged(options.copyWith(
            textDirection: value ? TextDirection.rtl : TextDirection.ltr));
      },
      switchKey: Key('text_direction'),
    );
  }
}

class _TimeDilationItem extends StatelessWidget {
  final GalleryOptions options;
  final ValueChanged<GalleryOptions> onOptionChanged;

  const _TimeDilationItem({Key key, this.options, this.onOptionChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _BooleanItem(
      "Slow motion",
      options.timeDilation != 1.0,
      (bool value) {
        options.copyWith(timeDilation: value ? 20.0 : 1.0);
      },
      switchKey: Key("slow_motion"),
    );
  }
}

class _PlatformItem extends StatelessWidget {
  final GalleryOptions options;
  final ValueChanged<GalleryOptions> onOptionsChanged;

  const _PlatformItem({Key key, this.options, this.onOptionsChanged})
      : super(key: key);

  String _platformLabel(TargetPlatform platform) {
    switch (platform) {
      case TargetPlatform.android:
        return "Mountain View";
      case TargetPlatform.fuchsia:
        return "Fuchsia";
      case TargetPlatform.iOS:
        return "Cupertino";
    }
    assert(false);
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return _OptionsItem(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
              child: Column(
            children: <Widget>[
              Text("Platform mechanics"),
              Text(
                "${_platformLabel(options.platform)}",
                style: Theme.of(context).primaryTextTheme.body1,
              ),
            ],
          )),
          PopupMenuButton(
            padding: EdgeInsetsDirectional.only(end: 16.0),
            icon: Icon(Icons.arrow_drop_down),
            itemBuilder: (BuildContext context) {
              return TargetPlatform.values.map((platform) {
                return PopupMenuItem(
                  child: Text(_platformLabel(platform)),
                  value: platform,
                );
              }).toList();
            },
            onSelected: (platform) {
              onOptionsChanged(options.copyWith(platform: platform));
            },
          ),
        ],
      ),
    );
    return null;
  }
}

class GalleryOptionsPage extends StatelessWidget {
  final GalleryOptions options;
  final ValueChanged<GalleryOptions> onOptionsChanged;
  final VoidCallback onSendFeedback;

  const GalleryOptionsPage(
      {Key key, this.options, this.onOptionsChanged, this.onSendFeedback})
      : super(key: key);

  List<Widget> _enableDiagnosticItems() {
    if (options.showOffscreenLayersCheckerboard == null &&
        options.showRasterCacheImagesCheckerboard == null &&
        options.showPerformanceOverlay == null) {
      return const <Widget>[];
    }
    final List<Widget> items = <Widget>[
      const Divider(),
      const _Heading(text: 'Diagnostics'),
    ];
    if (options.showOffscreenLayersCheckerboard != null) {
      items.add(_BooleanItem(
          "Highlight offscreen layers", options.showOffscreenLayersCheckerboard,
          (bool value) {
        onOptionsChanged(
            options.copyWith(showOffscreenLayersCheckerboard: value));
      }));
    }
    if (options.showRasterCacheImagesCheckerboard != null) {
      items.add(_BooleanItem("Highlight offscreen layers",
          options.showRasterCacheImagesCheckerboard, (bool value) {
        onOptionsChanged(
            options.copyWith(showRasterCacheImagesCheckerboard: value));
      }));
    }
    if (options.showPerformanceOverlay != null) {
      items.add(_BooleanItem(
          "Highlight offscreen layers", options.showPerformanceOverlay,
          (bool value) {
        onOptionsChanged(options.copyWith(showPerformanceOverlay: value));
      }));
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return DefaultTextStyle(
      style: themeData.primaryTextTheme.subhead,
      child: ListView(
        padding: EdgeInsets.only(bottom: 124.0),
        children: <Widget>[
          const _Heading(
            text: "Display",
          ),
          _ThemeModeItem(options: options, onOptionsChanged: onOptionsChanged),
          _TextScaleFactorItem(
            options: options,
            onOptionsChanged: onOptionsChanged,
          ),
          _TextDirectionItem(
            options: options,
            onOptionsChanged: onOptionsChanged,
          ),
          _TimeDilationItem(
            onOptionChanged: onOptionsChanged,
            options: options,
          ),
          const Divider(),
          const _Heading(
            text: "Platform mechanics",
          ),
          _PlatformItem(
            options: options,
            onOptionsChanged: onOptionsChanged,
          ),
          ..._enableDiagnosticItems(),
          const Divider(),
          const _Heading(text: 'Flutter gallery'),
          _ActionItem(
            text: "About Flutter Gallert",
            onTap: () {},
          ),

          _ActionItem(text:"Send feedback",onTap: onSendFeedback,)
        ],
      ),
    );
  }
}
