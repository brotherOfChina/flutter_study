import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

typedef UpdateUrlFetcher = Future<String> Function();

class Updater extends StatefulWidget {
  final UpdateUrlFetcher updateUrlFetcher;
  final Widget child;

  const Updater({Key key, this.updateUrlFetcher, this.child})
      : assert(updateUrlFetcher != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return UpdaterState();
  }
}

class UpdaterState extends State<Updater> {
  @override
  void initState() {
    super.initState();
    _checkForUpdates();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  static DateTime _lastUpdateCheck;

  Future<void> _checkForUpdates() async {
    if (_lastUpdateCheck != null &&
        DateTime.now().difference(_lastUpdateCheck) < const Duration(days: 1)) {
      return;
    }
    _lastUpdateCheck = DateTime.now();
    final String updateUrl = await widget.updateUrlFetcher();
    if (updateUrl != null) {
      final bool wantsUpdate =
          await showDialog(context: context, builder: _buildDialog);
      if (wantsUpdate != null && wantsUpdate) {
        launch(updateUrl);
      }
    }
  }

  Widget _buildDialog(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextStyle dialogTextStyle =
        theme.textTheme.subhead.copyWith(color: theme.textTheme.caption.color);
    return AlertDialog(
      title: const Text("update flutter gallery"),
      content: Text(
        "A newer version is aviailale",
        style: dialogTextStyle,
      ),
      actions: <Widget>[
        FlatButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: const Text("no thanks")),
        FlatButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: const Text("UPDATE")),
      ],
    );
  }
}
