library scrollytell;

import 'dart:math';

import 'package:flutter/material.dart';

// Using ScrollController instead of ScrollNotification - https://api.flutter.dev/flutter/widgets/ScrollNotification-class.html

class ScrollyWidget extends StatefulWidget {
  ScrollyWidget(
      {@required this.panels,
      this.panelStartCallback,
      this.panelEndCallback,
      this.panelProgressCallback});

  final VoidCallback panelStartCallback;
  final VoidCallback panelEndCallback;
  final VoidCallback panelProgressCallback;
  final List<Widget> panels;

  @override
  _ScrollyWidgetState createState() => _ScrollyWidgetState(panels);
}

class _ScrollyWidgetState extends State<ScrollyWidget> {
  _ScrollyWidgetState(panels)
      : this.keys = new List.generate(
            panels.length, (_) => new GlobalKey<_PanelWidgetState>());

  // User controls the overlay widget state through the callbacks
  Widget overLayWidget;

  // Index of active panel
  int activePanelIndex;

  // progress indicator [0,1]
  double progress;

  // Scroll controller
  ScrollController _scrollController;

  // panel height, Using Map to maintain proper mapping(panelNumber, panelHeight) at all the time
  Map<int, double> _panelHeights;
  List<double> _panelPrefixHeights;

  int _heightFillIndex;

  final keys;

  // Scroll Listener
  // Todo: Temporarily manipulating the overlayWidget in the scrollListener, add the wrapper later

  void _scrollListener() {
    //TODO: (IMP) change to variable height implementation using panelPrefixHeights
    if (_heightFillIndex != -1) {
      double filled = 0.0;
      for (int i = 0; i < _heightFillIndex; i++) {
        filled += _panelHeights[i];
      }
      if (_scrollController.offset >= filled) {
        _getHeight();
      }
    }
    int i = 0;
    var current_offset = _scrollController.offset;
    while (current_offset >= _panelPrefixHeights[i]) {
      i++;
    }

    var progress_offset = current_offset - _panelPrefixHeights[i - 1];

    setState(() {
      activePanelIndex = i;
      progress = progress_offset / _panelPrefixHeights[i];
    });
    print('panel index: $activePanelIndex ,progress : $progress ');
  }

  @override
  void initState() {
    // Scroll Controller and Listener
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);

    //initializing the list,
    _panelHeights = new Map();

    //convert panels
//    _statefulPanels = convertToStatefulPanel(widget.panels);

    //Call after render
    WidgetsBinding.instance.addPostFrameCallback((_) => _getHeight());

    // TODO:: Temporary(to be changed later): Initializing overlayWidget in initState()
    overLayWidget = Opacity(
      opacity: 0.7,
      child:
          Container(padding: EdgeInsets.all(16), child: Text('OverlayWidget')),
    );

    //initializing active panel index to 1 and progress to 0
    activePanelIndex = 1;
    progress = 0.0;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // The stack paints its children in order with the first child being at the bottom.
    return Stack(
      children: <Widget>[
        CustomScrollView(
          controller: _scrollController,
          //TODO: Provide flexibility to directly input sliverList
          slivers: <Widget>[
            SliverList(
              delegate:
                  SliverChildBuilderDelegate((BuildContext context, int index) {
                return PanelWidget(
                  key: keys[index],
                  rawPanel: widget.panels[index],
                );
              }, childCount: widget.panels.length),
            )
          ],
        ),
        overLayWidget
      ],
    );
  }

  void _getHeight() {
    final List<State> states = List.generate(
        widget.panels.length, (index) => keys[index].currentState);

    final List<RenderBox> boxes = List.generate(widget.panels.length,
        (index) => states[index]?.context?.findRenderObject());

    setState(() {
      _panelHeights = List.generate(widget.panels.length, (index) {
        if (_panelHeights[index] == null) {
          return boxes[index]?.size?.height;
        } else {
          return _panelHeights[index];
        }
      }).asMap();
    });

    final nullIndex = getNullIndex();

    setState(() {
      _heightFillIndex = nullIndex;
    });

    calculatePanelPrefixHeight();
  }

  getNullIndex() {
    for (var i = 0; i < _panelHeights.length; i++) {
      if (_panelHeights[i] == null) {
        return i;
      }
    }

    return -1;
  }

  void calculatePanelPrefixHeight() {
    List<double> pph = List.generate(widget.panels.length, (_) => 0.0);

    for (var i = 1; i < _panelHeights.length; i++) {
      assert(_panelHeights[i] != null);
      pph[i] = pph[i - 1] + _panelHeights[i];
      pph[0] = 0.0;
      for (int i = 1; i < widget.panels.length; i++) {
        if (_panelHeights[i - 1] != null) {
          pph[i] = pph[i - 1] + _panelHeights[i - 1];
        } else {
          pph[i] = pph[i - 1];
        }
      }

      setState(() {
        _panelPrefixHeights = pph;
      });

      print("Panel Prefix height: $_panelPrefixHeights");
    }
  }
}

class PanelWidget extends StatefulWidget {
  PanelWidget({Key key, Widget rawPanel})
      : rawPanel = rawPanel,
        super(key: key);

  final Widget rawPanel;

  @override
  _PanelWidgetState createState() => _PanelWidgetState();
}

class _PanelWidgetState extends State<PanelWidget> {
  @override
  Widget build(BuildContext context) {
    return widget.rawPanel;
  }
}
