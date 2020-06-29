import 'package:flutter/widgets.dart';
import 'package:flutter95/flutter95.dart';

class AlertDialog95 extends StatelessWidget {

  final String title;
  final Widget body;
  final List<Widget>actions;

  const AlertDialog95({Key key, this.title, this.body, this.actions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Elevation95(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                WindowHeader95(title: this.title ?? "Alert"),
                const SizedBox(height: 4),
                this.body ?? Container(),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: actions ?? []
                )
              ],
            )
        ));
  }
}