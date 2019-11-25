import 'dart:developer';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_study/gallery/demos.dart';
import 'dart:math' as math;

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
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    return RepaintBoundary(
      child: RawMaterialButton(
        padding: EdgeInsets.zero,
        hoverColor: theme.primaryColor.withOpacity(0.05),
        splashColor: theme.primaryColor.withOpacity(0.12),
        highlightColor: Colors.transparent,
        onPressed: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(6.0),
              child: Icon(
                category.icon,
                size: 60.0,
                color: isDark ? Colors.white : _kFltterBlue,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              height: 48.0,
              alignment: Alignment.center,
              child: Text(
                category.name,
                textAlign: TextAlign.center,
                style: theme.textTheme.subhead.copyWith(
                    fontFamily: "GoogleSans",
                    color: isDark ? Colors.white : _kFltterBlue),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _CategoriesPage extends StatelessWidget {
  final Iterable<GalleryDemoCategory> categories;
  final ValueChanged<GalleryDemoCategory> onCategoryTap;

  const _CategoriesPage({Key key, this.categories, this.onCategoryTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double aspectRatio = 160.0 / 180.0;
    final List<GalleryDemoCategory> categoryList = categories.toList();
    final int columnCount =
    (MediaQuery
        .of(context)
        .orientation == Orientation.portrait) ? 2 : 3;
    return Semantics(
      scopesRoute: true,
      namesRoute: true,
      label: "categories",
      explicitChildNodes: true,
      child: SingleChildScrollView(
        key: const PageStorageKey<String>("categories"),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final double columnWidth =
                constraints.biggest.width / columnCount.toDouble();
            final double rowHeight = math.min(225.0, columnWidth * aspectRatio);
            final int rowCount =
                (categories.length + columnCount * 1) ~/ columnCount;
            return RepaintBoundary(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: List<Widget>.generate(rowCount, (int rowIndex) {
                  final int columnCountForRow = rowIndex == rowCount - 1
                      ? categories.length -
                      columnCount * math.max(0, rowCount - 1)
                      : columnCount;
                  return Row(
                    children: List<Widget>.generate(columnCountForRow,
                            (int columnIndex) {
                          final int index = rowIndex * columnCount +
                              columnIndex;
                          final GalleryDemoCategory category = categoryList[index];
                          return SizedBox(
                            width: columnWidth,
                            height: rowHeight,
                            child: _CategoryItem(
                              category: category,
                              onTap: () {
                                onCategoryTap(category);
                              },
                            ),
                          );
                        }),
                  );
                }),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _DemoItem extends StatelessWidget {
  final GalleryDemo demo;

  const _DemoItem({Key key, this.demo}) : super(key: key);

  void _launchDemo(BuildContext context) {
    if (demo.routeName != null) {
      Timeline.instantSync('Start Transition', arguments: <String, String>{
        'from': '/',
        'to': demo.routeName,
      });
      Navigator.pushNamed(context, demo.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final double textScaleFactor = MediaQuery.textScaleFactorOf(context);
    final List<Widget> titleChildren = <Widget>[
      Text(
        demo.title,
        style: theme.textTheme.subhead.copyWith(
          color: isDark ? Colors.white : const Color(0xFF202124),
        ),
      )
    ];
    if (demo.subTitle != null) {
      titleChildren.add(Text(
        demo.subTitle,
        style: theme.textTheme.body1
            .copyWith(color: isDark ? Colors.white : const Color(0XFF60646b)),
      ));
    }
    return RawMaterialButton(
      padding: EdgeInsets.zero,
      splashColor: theme.primaryColor.withOpacity(0.12),
      highlightColor: Colors.transparent,
      onPressed: () {
        _launchDemo(context);
      },
      child: Container(
        constraints:
        BoxConstraints(minHeight: _kDemoItemHeight * textScaleFactor),
        child: Row(
          children: <Widget>[
            Container(
              width: 56.0,
              height: 56.0,
              alignment: Alignment.center,
              child: Icon(
                demo.icon,
                size: 24.0,
                color: isDark ? Colors.white : _kFltterBlue,
              ),
            ),
            Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: titleChildren,
                )),
            const SizedBox(
              width: 44.0,
            ),
          ],
        ),
      ),
    );
  }
}

class _DemosPage extends StatelessWidget {
  final GalleryDemoCategory category;

  const _DemosPage({Key key, this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double windowBottomPadding = MediaQuery
        .of(context)
        .padding
        .bottom;

    return KeyedSubtree(
      key: const ValueKey<String>('GalleryDemoList'),
      child: Semantics(
        scopesRoute: true,
        namesRoute: true,
        label: category.name,
        explicitChildNodes: true,
        child: ListView(
          dragStartBehavior: DragStartBehavior.down,
          key: PageStorageKey(category.name),
          padding: EdgeInsets.only(top: 8.0, bottom: windowBottomPadding),
          children: kGalleryCategoryToDemos[category].map<Widget>((demo) {
            return _DemoItem(
              demo: demo,
            );
          }).toList(),
        ),
      ),
    );
  }
}

class GalleryHome extends StatefulWidget {
  final Widget optionsPage;
  final bool testMode;

  const GalleryHome({Key key, this.optionsPage, this.testMode})
      : super(key: key);
  static bool showPreviewBanner = true;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return null;
  }
}

class _GalleryHomeState extends State<GalleryHome>
    with SingleTickerProviderStateMixin {
  static final GlobalKey<ScaffoldState> _scaffoldKey =
  GlobalKey<ScaffoldState>();
  AnimationController _controller;
  GalleryDemoCategory _category;

  static Widget _topHomeLayout(Widget currentChild,
      List<Widget> previousChildren) {
    List<Widget> children = previousChildren;
    if (currentChild != null) {
      children = children.toList()
        ..add(currentChild);
      return Stack(
        children: children,
        alignment: Alignment.topCenter,
      );
    }
  }

  static const AnimatedSwitcherLayoutBuilder _centerHomeLayout =
      AnimatedSwitcher.defaultLayoutBuilder;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      debugLabel: 'preview banner',
      vsync: this,
    )
      ..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final MediaQueryData media = MediaQuery.of(context);
    final bool centerHome =
        media.orientation == Orientation.portrait && media.size.height < 800.0;
    const Curve swtichOutCurVe =
    Interval(0.4, 1.0, curve: Curves.fastOutSlowIn);
    const Curve swtichInCurve = Interval(0.4, 1.0, curve: Curves.fastOutSlowIn);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: isDark ? _kFltterBlue : theme.primaryColor,
      body: SafeArea(child: WillPopScope(
        child: Backdrop(),


      ),
        bottom: false,),
    );
  }
}
