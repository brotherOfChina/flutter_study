import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_study/gallery/Test.dart';
import 'package:flutter_study/gallery/icons.dart';

class GalleryDemoCategory {
  const GalleryDemoCategory._({this.name, this.icon});

  final String name;
  final IconData icon;

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other)) {
      return true;
    }
    if (runtimeType != other.runtimeType) {
      return false;
    }
    final GalleryDemoCategory typedOther = other;

    return typedOther.name == name && typedOther.icon == icon;
  }

  @override
  int get hashCode => hashValues(name, icon);

  @override
  String toString() {
    return "$runtimeType($name)";
  }
}

const GalleryDemoCategory _kDemos =
    GalleryDemoCategory._(name: "Studies", icon: Icons.home);

const GalleryDemoCategory _kStyle = GalleryDemoCategory._(
  name: "style",
  icon: GalleryIcons.custom_typography,
);

const GalleryDemoCategory _kMaterialCompoents = GalleryDemoCategory._(
  name: "Cupertino",
  icon: GalleryIcons.category_mdc,
);
const GalleryDemoCategory _kCupertinoComponents = GalleryDemoCategory._(
  name: "Cupertino",
  icon: GalleryIcons.phone_iphone,
);
const GalleryDemoCategory _kMedia = GalleryDemoCategory._(
  name: "MeDia",
  icon: GalleryIcons.drive_video,
);

class GalleryDemo {
  final String title;
  final IconData icon;
  final String subTitle;
  final GalleryDemoCategory category;
  final String routeName;
  final WidgetBuilder builderRoute;
  final String documentationUrl;

  GalleryDemo(
      {@required this.title,
      @required this.icon,
      this.subTitle,
      @required this.category,
      @required this.routeName,
      @required this.builderRoute,
      this.documentationUrl})
      : assert(title != null),
        assert(category != null),
        assert(routeName != null),
        assert(builderRoute != null);

  @override
  String toString() {
    return "$runtimeType($title $routeName)";
  }
}

List<GalleryDemo> _buildGalleryDemos() {
  final List<GalleryDemo> galleryDemos = <GalleryDemo>[
    GalleryDemo(
      title: 'Shrine',
      subTitle: 'Basic shopping app',
      icon: GalleryIcons.shrine,
      category: _kDemos,
      routeName: Test.routeName,
      builderRoute: (BuildContext context) => const Test(),
    ),
  ];
  assert(() {
    galleryDemos.insert(
        0,
        GalleryDemo(
            title: "pesto",
            subTitle: 'Simple recipe browser',
            icon: Icons.adjust,
            category: _kDemos,
            routeName:  Test.routeName,
            builderRoute: (BuildContext context) => const Test()));
    return true;
  }());
  return galleryDemos;
}

final List<GalleryDemo> kAllGalleryDemos = _buildGalleryDemos();

final Set<GalleryDemoCategory> kAllGalleyDemoCategories =
    kAllGalleryDemos.map((GalleryDemo demo) => demo.category).toSet();

final Map<GalleryDemoCategory, List<GalleryDemo>> kGalleryCategoryToDemos =
    Map<GalleryDemoCategory, List<GalleryDemo>>.fromIterable(
        kAllGalleyDemoCategories,
        value: (dynamic category) {
       return kAllGalleryDemos
      .where((GalleryDemo demo) => demo.category == category)
      .toList();
});

final Map<String,String> kDemoDocumentationUrl=
    Map<String,String>.fromIterable(
      kAllGalleryDemos.where((GalleryDemo demo)=>demo.documentationUrl!=null),
      key: (dynamic demo)=>demo.routeName,
      value: (dynamic demo)=>demo.documentationUrl,
    );
