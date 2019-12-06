library scrollytell;

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// Using ScrollController instead of ScrollNotification - https://api.flutter.dev/flutter/widgets/ScrollNotification-class.html

class ScrollyWidget extends StatefulWidget {
  ScrollyWidget({
    @required this.panels,
    @required this.panelStartCallback,
    @required this.panelEndCallback,
    @required this.panelProgressCallback,
    this.lastPanelForceComplete = false,
    this.opacity = 1,
    this.initialOverlayWidget,
    this.shrinkWrapCustomScrollView = false,
    this.scrollPhysicsCustomScrollView
  });

  //callbacks

  final Function(num, Function) panelStartCallback;
  final Function(num, Function) panelEndCallback;
  final Function(num, double, Function) panelProgressCallback;

  //panelList
  final List<Widget> panels;

  //Set to TRUE if the last panel hits bottom of the screen hence prohibiting the scroll and want to enable complete scroll
  final bool lastPanelForceComplete;

  //Overlay opacity
  final double opacity;

  //Initial overlay widget
  final Widget initialOverlayWidget;

  //ShrinkWrap for CustomScrollView
  final bool shrinkWrapCustomScrollView;

  //Scroll Physics for CustomScrollView
  final ScrollPhysics scrollPhysicsCustomScrollView;


  @override
  _ScrollyWidgetState createState() => _ScrollyWidgetState(panels);
}

class _ScrollyWidgetState extends State<ScrollyWidget> {
  _ScrollyWidgetState(panels)
      : this._keys = new List.generate(
            panels.length, (_) => new GlobalKey<_PanelWidgetState>());

  // User controls the overlay widget state through the callbacks
  Widget _overLayWidget;

  // Index of active panel
  int _activePanelIndex;

  // progress indicator [0,1]
  num _progress;

  // Scroll controller
  ScrollController _scrollController;

  // panel height, Using Map to maintain proper mapping(panelNumber, panelHeight) at all the time
  Map<int, double> _panelHeights;
  List<double> _panelPrefixHeights;

  int _heightFillIndex;

  final _keys;


  void _scrollListener() {
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
    var currentOffset = _scrollController.offset;
    while (i < _panelPrefixHeights.length - 1 &&
        currentOffset >= _panelPrefixHeights[i]) {
      i++;
    }

    var progressOffset = currentOffset - _panelPrefixHeights[i - 1];
    var previousPanelIndex = _activePanelIndex ?? -1;
    var previousProgress = _progress;

    // taking four digit after decimal for precision
    // if we take lesser than this the the callback is called several time on
    // same progress

    setState(() {
      _activePanelIndex = i;
      _progress = i == 0
          ? num.parse(
              (progressOffset / _panelPrefixHeights[i]).toStringAsFixed(4))
          : num.parse((progressOffset /
                  (_panelPrefixHeights[i] - _panelPrefixHeights[i - 1]))
              .toStringAsFixed(4));
    });
    print('panel index: $_activePanelIndex ,progress : $_progress ');

    if (previousPanelIndex != _activePanelIndex) {
      widget.panelStartCallback(_activePanelIndex,
          (newOverlay) => {this.setState(() => _overLayWidget = newOverlay)});
    }

    // Dart do not have tuple or pair class so returning list of two num element here
    widget.panelProgressCallback(_activePanelIndex, _progress,
        (newOverlay) => {this.setState(() => _overLayWidget = newOverlay)});


    if (previousPanelIndex == _activePanelIndex &&
        previousProgress < 0.97 &&
        _progress >= 0.97 &&
        _progress < 1.0) {
      widget.panelEndCallback(_activePanelIndex,
          (newOverlay) => {this.setState(() => _overLayWidget = newOverlay)});
    }
  }

  @override
  void initState() {
    // Scroll Controller and Listener
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);

    //initializing the list,
    _panelHeights = new Map();

    //Call after render
    WidgetsBinding.instance.addPostFrameCallback((_) => _getHeight());

    //initializing active panel index to 1 and progress to 0
    _activePanelIndex = 1;
    _progress = 0.0;

    if (widget.initialOverlayWidget != null) {
      _overLayWidget = widget.initialOverlayWidget;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // The stack paints its children in order with the first child being at the bottom.

    return Stack(
      children: <Widget>[
        CustomScrollView(
          shrinkWrap: widget.shrinkWrapCustomScrollView,
          controller: _scrollController,
          physics: widget.scrollPhysicsCustomScrollView,
          //TODO: (Later) Provide flexibility to directly input sliverList
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                return PanelWidget(
                  key: _keys[index],
                  rawPanel: widget.panels[index],
                );
              }, childCount: widget.panels.length),
            ),
            widget.lastPanelForceComplete
                ? SliverFillRemaining()
                : SliverToBoxAdapter(
                    child: Container(),
                  )
          ],
        ),
        Opacity(
          opacity: widget.opacity,
          child: IgnorePointer(
            child: _overLayWidget,
            ignoring: true,
          ),
        )
      ],
    );
  }

  void _getHeight() {
    final List<State> states = List.generate(
        widget.panels.length, (index) => _keys[index].currentState);

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

    final nullIndex = _getNullIndex();

    setState(() {
      _heightFillIndex = nullIndex;
    });

    _calculatePanelPrefixHeight();
  }

  _getNullIndex() {
    for (var i = 0; i < _panelHeights.length; i++) {
      if (_panelHeights[i] == null) {
        return i;
      }
    }

    return -1;
  }

  void _calculatePanelPrefixHeight() {
    List<double> pph = List.generate(widget.panels.length + 1, (_) => 0.0);
    pph[0] = 0.0;
    for (int i = 1; i <= widget.panels.length; i++) {
      if (_panelHeights[i - 1] != null) {
        pph[i] = pph[i - 1] + _panelHeights[i - 1];
      } else {
        pph[i] = pph[i - 1];
      }
    }
    setState(() {
      _panelPrefixHeights = pph;
    });
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
