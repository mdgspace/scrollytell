library scrollytell;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// Using ScrollController instead of ScrollNotification - https://api.flutter.dev/flutter/widgets/ScrollNotification-class.html

enum GuidelinePosition { top, center, bottom }

class ScrollyWidget extends StatefulWidget {
  ScrollyWidget({
    @required this.panels,
    this.panelStartCallback,
    this.panelEndCallback,
    this.panelProgressCallback,
    this.lastPanelForceComplete = false,
    this.opacity = 1,
    this.initialOverlayWidget,
    this.guidelinePosition = GuidelinePosition.top,
    this.showDebugConsole = false,
    this.stickyChartIndex,
  })  : assert(panels != null, "The list of panels cannot be null."),
        assert(
            panelStartCallback != null ||
                panelEndCallback != null ||
                panelProgressCallback != null,
            "At least one of the panelStartCallback, panelProgressCallback, panelEndCallback must be non-null.");

  /// Called When Panel top coincides with guideline.
  ///
  /// panelStartCallback: (activePanelNumber, func){}
  ///
  /// At least one of the panelStartCallback, panelProgressCallback, panelEndCallback must be non-null.
  final Function(num, Function) panelStartCallback;

  /// Called When Panel is about to end w.r.t. guideline.
  ///
  /// panelEndCallback: (endingPanelNumber, func){}
  ///
  /// At least one of the panelStartCallback, panelProgressCallback, panelEndCallback must be non-null.
  final Function(num, Function) panelEndCallback;

  /// Called every frame (when scroll offest changes)
  ///
  /// panelProgressCallback: (activePanelNumber, progress, func){}
  ///
  /// At least one of the panelStartCallback, panelProgressCallback, panelEndCallback must be non-null.
  final Function(num, double, Function) panelProgressCallback;

  /// Must be Non-null.
  /// The list of panels form a scrolling sequence.
  final List<Widget> panels;

  ///Set to true if the last panel hits bottom of the screen hence prohibiting the scroll and want to enable complete scroll.
  final bool lastPanelForceComplete;

  ///Opacity of each panel in the panel list.
  final double opacity;

  ///Overlay widget when scrolling has not started.
  final Widget initialOverlayWidget;

  ///[GuidelinePosition.top, GuidelinePosition.center, GuidelinePosition.bottom]
  ///
  /// Guideline is an imaginary reference line.
  /// When the panel's top coincide with the guideline we say panel has been 'started' or the panel is 'active' and [panelStartCallback] is called.
  /// Similarily when panel's bottom touch guideline we say panel is ended and [panelEndCallback] is called.
  /// You can choose the guidelinePosition to be either at ScrollyWidget's top, center, bottom.
  final GuidelinePosition guidelinePosition;

  ///Set true to show debug console [activePanelIndex, progress] and debug-line (guideline)
  final showDebugConsole;

  ///Use when [guidelinePosition == GuidelinePosition.center]
  ///
  ///Index of the panel which will be docked at the center
  ///when its middle coincides with the guideline.
  final int stickyChartIndex;

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

  final _stackKey = GlobalKey();

  double _offsetBias;

  bool _stickyVisibility;

  void _scrollListener() {
    if (_heightFillIndex != -1) {
      double filled = 0.0;
      for (int i = 0; i < _heightFillIndex; i++) {
        filled += _panelHeights[i];
      }
      if (_scrollController.offset + _offsetBias >= filled) {
        _getHeight();
      }
    }
    int i = 0;
//    var currentOffset = _scrollController.offset;
    var currentOffset = _scrollController.offset + _offsetBias;
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
//    print('panel index: $_activePanelIndex ,progress : $_progress ');

    if (previousPanelIndex != _activePanelIndex &&
        widget.panelStartCallback != null) {
      widget.panelStartCallback(_activePanelIndex,
          (newOverlay) => {this.setState(() => _overLayWidget = newOverlay)});
    }

    // Dart do not have tuple or pair class so returning list of two num element here
    if (widget.panelProgressCallback != null) {
      widget.panelProgressCallback(_activePanelIndex, _progress,
          (newOverlay) => {this.setState(() => _overLayWidget = newOverlay)});
    }

    if (previousPanelIndex == _activePanelIndex &&
        widget.panelEndCallback != null &&
        previousProgress < 0.97 &&
        _progress >= 0.97 &&
        _progress < 1.0) {
      widget.panelEndCallback(_activePanelIndex,
          (newOverlay) => {this.setState(() => _overLayWidget = newOverlay)});
    }

    if (widget.stickyChartIndex != null &&
        _activePanelIndex == 4 &&
        previousProgress < 0.5 &&
        _progress >= 0.5 &&
        _progress < .7) {
      setState(() {
        _overLayWidget = Align(
          alignment: Alignment.center,
          child: widget.panels[widget.stickyChartIndex - 1],
        );
        _stickyVisibility = false;
      });
    }
    if (widget.stickyChartIndex != null &&
        _activePanelIndex == 4 &&
        previousProgress > 0.5 &&
        _progress >= 0.3 &&
        _progress < .5) {
      setState(() {
        _stickyVisibility = true;
        _overLayWidget = Container();
      });
      if (widget.panelProgressCallback != null) {
        widget.panelProgressCallback(_activePanelIndex, _progress,
            (newOverlay) => {this.setState(() => _overLayWidget = newOverlay)});
      }
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
    WidgetsBinding.instance.addPostFrameCallback((_) => _getStackHeight());

    //initializing active panel index to 1 and progress to 0
    _activePanelIndex = 1;
    _progress = 0.0;
    _offsetBias = 0;

    if (widget.initialOverlayWidget != null) {
      _overLayWidget = widget.initialOverlayWidget;
    } else {
      _overLayWidget = Container();
    }

    _stickyVisibility = true;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // The stack paints its children in order with the first child being at the bottom.

    return Stack(
      key: _stackKey,
      children: <Widget>[
        Positioned(
          child: _overLayWidget,
        ),
        CustomScrollView(
          controller: _scrollController,
          //TODO: (Later) Provide flexibility to directly input sliverList
          slivers: <Widget>[
            SliverList(
              delegate:
                  SliverChildBuilderDelegate((BuildContext context, int index) {
                if (widget.stickyChartIndex != null &&
                    index == widget.stickyChartIndex - 1) {
                  return Opacity(
                    opacity: widget.opacity,
                    child: PanelWidget(
                      key: _keys[index],
                      rawPanel: widget.panels[index],
                      visible: _stickyVisibility,
                    ),
                  );
                } else {
                  return Opacity(
                    opacity: widget.opacity,
                    child: PanelWidget(
                      key: _keys[index],
                      rawPanel: widget.panels[index],
                      visible: true,
                    ),
                  );
                }
              }, childCount: widget.panels.length),
            ),
            widget.lastPanelForceComplete
                ? SliverFillRemaining()
                : SliverToBoxAdapter(
                    child: Container(),
                  )
          ],
        ),
        Visibility(
          visible: widget.showDebugConsole,
          child: Align(
            alignment: Alignment.topLeft,
            child: Container(
              color: Colors.grey,
              width: 100,
              child: Text(
                  'active panel : $_activePanelIndex \nprogress : $_progress'),
            ),
          ),
        ),
        Visibility(
          visible: widget.showDebugConsole,
          child: Align(
            alignment: _getAlignment(),
            child: Divider(
              height: 0,
              color: Colors.black87,
              thickness: 1.0,
            ),
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

  _getStackHeight() {
    final context = _stackKey.currentContext;

    double bias;

    switch (widget.guidelinePosition) {
      case GuidelinePosition.top:
        bias = 0;
        break;
      case GuidelinePosition.center:
        bias = context.size.height / 2;
        break;
      case GuidelinePosition.bottom:
        bias = context.size.height;
        break;
      default:
        bias = 0;
        break;
    }

    setState(() {
      _offsetBias = bias;
    });
  }

  _getAlignment() {
    Alignment alignment;
    if (widget.guidelinePosition == GuidelinePosition.bottom) {
      alignment = Alignment.bottomCenter;
    } else if (widget.guidelinePosition == GuidelinePosition.center) {
      alignment = Alignment.center;
    } else {
      alignment = Alignment.topCenter;
    }
    return alignment;
  }
}

class PanelWidget extends StatefulWidget {
  PanelWidget({Key key, Widget rawPanel, bool visible})
      : rawPanel = rawPanel,
        visible = visible,
        super(key: key);

  final Widget rawPanel;
  final bool visible;

  @override
  _PanelWidgetState createState() => _PanelWidgetState();
}

class _PanelWidgetState extends State<PanelWidget> {
  @override
  Widget build(BuildContext context) {
    return widget.visible ? widget.rawPanel : Container();
  }
}
