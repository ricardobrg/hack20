import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_treeview/tree_view.dart';
import 'package:hack20/home/channel.dart';
import 'package:hack20/home/channel_page.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _selectedNode;
  List<Node> _nodes = [];
  TreeViewController _treeViewController;
  bool deepExpanded = true;
  final Map<ExpanderPosition, Widget> expansionPositionOptions = const {
    ExpanderPosition.start: Text('Start'),
    ExpanderPosition.end: Text('End'),
  };
  final Map<ExpanderType, Widget> expansionTypeOptions = const {
    ExpanderType.caret: Icon(
      Icons.arrow_drop_down,
      size: 28,
    ),
    ExpanderType.arrow: Icon(Icons.arrow_downward),
    ExpanderType.chevron: Icon(Icons.expand_more),
    ExpanderType.plusMinus: Icon(Icons.add),
  };
  final Map<ExpanderModifier, Widget> expansionModifierOptions = const {
    ExpanderModifier.none: ModContainer(ExpanderModifier.none),
    ExpanderModifier.circleFilled: ModContainer(ExpanderModifier.circleFilled),
    ExpanderModifier.circleOutlined:
        ModContainer(ExpanderModifier.circleOutlined),
    ExpanderModifier.squareFilled: ModContainer(ExpanderModifier.squareFilled),
    ExpanderModifier.squareOutlined:
        ModContainer(ExpanderModifier.squareOutlined),
  };
  ExpanderPosition _expanderPosition = ExpanderPosition.start;
  ExpanderType _expanderType = ExpanderType.caret;
  ExpanderModifier _expanderModifier = ExpanderModifier.none;

  final _filterDispatchesCtrl = TextEditingController();

  String filterText = '';

  List<Channel> nodeMapping = [
    Channel(
      name: 'Flutter',
      nodes: [
        'Flutter/Web',
        'Flutter/Br',
        'Flutter/Help',
      ],
    ),
    Channel(
      name: 'Hack20',
      nodes: [
        'Flutter Brasil Community',
      ],
    ),
    Channel(name: 'Startup', nodes: [
      'Forum/Startup',
      'Ivenstimento/Startup',
    ]),
  ];

  @override
  void initState() {
    _nodes = createListNode();
    _treeViewController = TreeViewController(
      children: _nodes,
      selectedKey: _selectedNode,
    );

    _filterDispatchesCtrl.addListener(() {
      setState(() => filterText = _filterDispatchesCtrl?.text ?? '');
    });
    super.initState();
  }

  List<Node> createListNode() {
    List<Node> nodeList = [];

    nodeMapping
            .map((Channel channel) => nodeList.add(
                  Node(
                    label: channel.name,
                    key: channel.name,
                    icon: NodeIcon(
                        codePoint: Icons.folder.codePoint, color: "yellow600"),
                    children: channel.nodes
                            .map(
                              (nomeChannel) => Node(
                                label: nomeChannel,
                                key: nomeChannel,
                                icon: NodeIcon(
                                    codePoint: Icons.chat.codePoint,
                                    color: "green"),
                              ),
                            )
                            .toList() ??
                        [],
                  ),
                ))
            .toList() ??
        [];

    return nodeList;
  }

  @override
  Widget build(BuildContext context) {
    TextStyle underlineStyle() => Theme.of(context)
        .textTheme
        .subtitle1
        .copyWith(decoration: TextDecoration.underline);

    TreeViewTheme _treeViewTheme = TreeViewTheme(
      expanderTheme: ExpanderThemeData(
        type: _expanderType,
        modifier: _expanderModifier,
        position: _expanderPosition,
        color: Colors.grey.shade800,
        size: 20,
      ),
      labelStyle: TextStyle(
        fontSize: 16,
        letterSpacing: 0.3,
      ),
      parentLabelStyle: TextStyle(
        fontSize: 16,
        letterSpacing: 0.1,
        fontWeight: FontWeight.w800,
        color: Colors.blue.shade700,
      ),
      iconTheme: IconThemeData(
        size: 18,
        color: Colors.grey.shade800,
      ),
      colorScheme: Theme.of(context).brightness == Brightness.light
          ? ColorScheme.light(
              primary: Colors.blue.shade50,
              onPrimary: Colors.grey.shade900,
              background: Colors.transparent,
              onBackground: Colors.black,
            )
          : ColorScheme.dark(
              primary: Colors.black26,
              onPrimary: Colors.white,
              background: Colors.transparent,
              onBackground: Colors.white70,
            ),
    );

    Widget _searchListField() => Container(
          decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: TextField(
            controller: _filterDispatchesCtrl,
            decoration: InputDecoration(
              hintText: 'Digite o nome da sala para conversa',
              prefixIcon: Icon(Icons.search),
              contentPadding:
                  const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[200]),
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[200]),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        );

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.all(20),
          height: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 20),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [_userName(), _iconLogout()]),
              SizedBox(height: 10),
              _searchListField(),
              SizedBox(height: 10),
              _selectedChannelLabel(underlineStyle),
              SizedBox(height: 10),
              _listChannel(_treeViewTheme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _listChannel(TreeViewTheme _treeViewTheme) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.all(10),
        child: TreeView(
          controller: _treeViewController,
          allowParentSelect: false,
          supportParentDoubleTap: false,
          onExpansionChanged: (key, expanded) => _expandNode(key, expanded),
          onNodeTap: (key) {
            debugPrint('Selected: $key');
            setState(() {
              _selectedNode = key;
              _treeViewController =
                  _treeViewController.copyWith(selectedKey: key);

              if (key == 'Flutter/Web') {
                navigateToChannelPage();
              }
              if (key == 'Flutter/BR') {
                navigateToChannelPage();
              }
              if (key == 'Flutter/Help') {
                navigateToChannelPage();
              }
              if (key == 'Forum/Startup') {
                navigateToChannelPage();
              }
              if (key == 'Ivenstimento/Startup') {
                navigateToChannelPage();
              }
              if (key == 'Flutter Brasil Community') {
                navigateToChannelPage();
              }
            });
          },
          theme: _treeViewTheme,
        ),
      ),
    );
  }

  void navigateToChannelPage() => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChannelPage(),
        ),
      );

  Text _selectedChannelLabel(TextStyle underlineStyle()) => Text(
        'Selecione a sala abaixo para participar',
        style: underlineStyle(),
      );

  _expandNode(String key, bool expanded) {
    String msg = '${expanded ? "Expanded" : "Collapsed"}: $key';
    debugPrint(msg);
    Node node = _treeViewController.getNode(key);
    if (node != null) {
      List<Node> updated;
      if (key != null) {
        updated = _treeViewController.updateNode(
          key,
          node.copyWith(
              expanded: expanded,
              icon: NodeIcon(
                codePoint: expanded
                    ? Icons.folder_open.codePoint
                    : Icons.folder.codePoint,
                color: "yellow600",
              )),
        );
      } else {
        updated = _treeViewController.updateNode(
            key, node.copyWith(expanded: expanded));
      }
      setState(() {
        if (key != null)
          _treeViewController = _treeViewController.copyWith(children: updated);
      });
    }
  }
}

Widget _iconLogout() => ClipOval(
      child: Material(
        color: Colors.black,
        child: InkWell(
          splashColor: Colors.red,
          child: SizedBox(
              height: 30,
              width: 30,
              child: Icon(
                Icons.power_settings_new,
                color: Colors.white,
              )),
          onTap: () {},
        ),
      ),
    );

Widget _userName() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Olá Nelson Jr',
          style: TextStyle(fontSize: 16),
        ),
        Text(
          'Bem vindo(a)!',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ],
    );

class ModContainer extends StatelessWidget {
  final ExpanderModifier modifier;

  const ModContainer(this.modifier, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double _borderWidth = 0;
    BoxShape _shapeBorder = BoxShape.rectangle;
    Color _backColor = Colors.red;
    Color _backAltColor = Colors.red.shade700;
    switch (modifier) {
      case ExpanderModifier.none:
        break;
      case ExpanderModifier.circleFilled:
        _shapeBorder = BoxShape.circle;
        _backColor = _backAltColor;
        break;
      case ExpanderModifier.circleOutlined:
        _borderWidth = 1;
        _shapeBorder = BoxShape.circle;
        break;
      case ExpanderModifier.squareFilled:
        _backColor = _backAltColor;
        break;
      case ExpanderModifier.squareOutlined:
        _borderWidth = 1;
        break;
    }
    return Container(
      decoration: BoxDecoration(
        shape: _shapeBorder,
        border: _borderWidth == 0
            ? null
            : Border.all(
                width: _borderWidth,
                color: _backAltColor,
              ),
        color: _backColor,
      ),
      width: 15,
      height: 15,
    );
  }
}
