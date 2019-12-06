library scrollytell;

import 'package:flutter/material.dart';

// Using ScrollController instead of ScrollNotification - https://api.flutter.dev/flutter/widgets/ScrollNotification-class.html

class ScrollyWidget extends StatefulWidget {
  ScrollyWidget({this.panels});
  List<Widget> panels;

  @override
  _ScrollyWidgetState createState() => _ScrollyWidgetState();
}

class _ScrollyWidgetState extends State<ScrollyWidget> {
  // User controls the overlay widget state through the callbacks
  Widget overLayWidget;

  // Index of active panel
  int activePanelIndex;

  // progress indicator [0,1]
  double progress;

  // Scroll controller
  ScrollController _scrollController;

  _scrollListener(){
    print("Scroll Offset ${_scrollController.offset}");
  }

  @override
  void initState() {

    // Scroll Controller and Listener
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);


    // TODO:: Temporary(to be changed later): Initializing overlayWidget in initState()
    overLayWidget = Opacity(
      opacity: 0.7,
      child:
      Container(padding: EdgeInsets.all(16), child: Text('OverlayWidget')),
    );
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
            SliverList(delegate: SliverChildListDelegate(
                widget.panels
            ),)
          ],
        ),
        overLayWidget
      ],
    );
  }
}