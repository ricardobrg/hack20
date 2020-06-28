import 'package:flutter/material.dart';
import 'package:flutter95/flutter95.dart';


class Home extends StatefulWidget{

  @override
  State<StatefulWidget> createState() => _HomeState();

}

class _HomeState<Home> extends State {

  @override
  Widget build(BuildContext context) {
    return Scaffold95(
      body: Column(
        children: [
          Button95(
              onTap: () => _showDialog(),
              child: Text('Button95'),
          ),
        ]
      ),
      title: "teste",
    );
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // retorna um objeto do tipo Dialog
        return Container(
          padding: EdgeInsets.symmetric(horizontal:15),
          child: Elevation95(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              WindowHeader95(title: "popup"),
              const SizedBox(height: 4),
              Text("body"),
            ],
          )
        ));
      },
    );
  }
}