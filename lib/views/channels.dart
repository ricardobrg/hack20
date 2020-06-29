import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_treeview/tree_view.dart';
import 'package:flutter95/flutter95.dart';
import 'package:hack20/model/channel.dart';
import 'package:hack20/widgets/modContainer.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'chatPage.dart';

class Channels extends StatefulWidget {

  final FirebaseUser user;

  const Channels({Key key, this.user}) : super(key: key);

  @override
  _ChannelsState createState() => _ChannelsState();

}

class _ChannelsState extends State<Channels> {

  String _selectedNode;
  String filterText = '';
  List<Node> _nodes = [];
  TreeViewController _treeViewController;
  bool deepExpanded = true;
  final _filterDispatchesCtrl = TextEditingController();
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

  // TODO connect to backend
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
    _filterDispatchesCtrl.addListener(() {
      setState(() => filterText = _filterDispatchesCtrl.text);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _nodes = createListNode();
    _treeViewController = TreeViewController(
      children: _nodes,
      selectedKey: _selectedNode,
    );
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
          child: TextField95(
            controller: _filterDispatchesCtrl,
          ),
        );

    return Scaffold(
      body: Elevation95(
        child: Container(
          padding: EdgeInsets.only(top:0),
          height: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              WindowHeader95(title: "Channels"),
              _searchListField(),
              _listChannel(_treeViewTheme),
            ],
          ),
        ),
      )
    );
  }

  List<Node> createListNode() {
    List<Node> nodeList = [];
    nodeMapping.forEach((Channel channel) {
      List<Node> nodeChildren = [];
      channel.nodes.forEach((nomeChannel) {
        if (filterText == '' ||
            nomeChannel.toLowerCase().contains(filterText.toLowerCase())) {
          nodeChildren.add(Node(
            label: nomeChannel,
            key: nomeChannel,
            icon: NodeIcon(codePoint: Icons.chat.codePoint, color: "green"),
          ));
        }
      });
      if (nodeChildren.length > 0)
        nodeList.add(
          Node(
              label: channel.name,
              key: channel.name,
              icon: NodeIcon(
                  codePoint: Icons.folder.codePoint, color: "yellow600"),
              children: nodeChildren),
        );
    });
    return nodeList;
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
            setState(() {
              _selectedNode = key;
              _treeViewController =
                  _treeViewController.copyWith(selectedKey: key);
               navigateToChannelPage(key);
            });
          },
          theme: _treeViewTheme,
        ),
      ),
    );
  }

  void navigateToChannelPage(String channel) => Navigator.of(context).push(
    MaterialPageRoute(builder: (context) => ChatPage(channel: channel))
  );

  void _expandNode(String key, bool expanded) {
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