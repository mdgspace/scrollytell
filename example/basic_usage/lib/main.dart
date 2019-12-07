import 'package:flutter/material.dart';
import 'package:scrollytell/scrollytell.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Basic-App',
      home: MyHomePage(title: 'Home Page'),
    );
  }
}

List<Widget> panelList = [];

List<Widget> generatePanelList() {
  List<Widget> list = [];
  for (int i = 0; i < 20; i++) {

    list.add(Center(
      child: Column(
        children: <Widget>[
          Container(
            height: (100 * ((i + 1) % 9) + 100).toDouble(),
            child: Center(child: Text('Panel ${i + 1}')),
            color: (i % 2 == 0) ? Colors.blue : Colors.orange,
          ),
        ],
      ),
    ));
  }
  return list;
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    panelList = generatePanelList();

    Widget _scrollyWidget = ScrollyWidget(
      showDebugConsole: true,
      guidelinePosition: GuidelinePosition.center,
      opacity: 0.5,
      panels: panelList,
      panelProgressCallback: (activePanelNumber, progress, func) {
        Widget overlayWidget;
        double rad = (progress <= 0.5) ? progress * 200 : 200 - progress * 200;

        Color color;
        switch (activePanelNumber) {
          case 1:
            {
              color = Colors.purple;
              break;
            }
          case 2:
            {
              color = Colors.green;
              break;
            }
          case 3:
            {
              color = Colors.red;
              break;
            }
          case 4:
            {
              color = Colors.pink;
              break;
            }
          case 5:
            {
              color = Colors.purple;
              break;
            }
          case 6:
            {
              color = Colors.limeAccent;
              break;
            }
          case 7:
            {
              color = Colors.green;
              break;
            }
          case 8:
            {
              color = Colors.purple;
              break;
            }
          case 9:
            {
              color = Colors.green;
              break;
            }
          case 10:
            {
              color = Colors.red;
              break;
            }
          case 11:
            {
              color = Colors.pink;
              break;
            }
          case 12:
            {
              color = Colors.purple;
              break;
            }
          case 13:
            {
              color = Colors.limeAccent;
              break;
            }
          case 14:
            {
              color = Colors.green;
              break;
            }
        }

        overlayWidget = Center(
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(rad),
              ),
              color: color,
            ),
          ),
        );

        func(overlayWidget);
      },
      panelStartCallback: (activePanelNumber, func) {
        print('panel start callback $activePanelNumber');
      },
      panelEndCallback: (endingPanelNumber, func) {
        print('panel end callback $endingPanelNumber');
      },
      lastPanelForceComplete: true,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[
          Container(
            child: Text('Example for understanding basic usage'),
          ),
          Expanded(
            child: _scrollyWidget,
          ),
        ],
      ),
    );
  }
}
