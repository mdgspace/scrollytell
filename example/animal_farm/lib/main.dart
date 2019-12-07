import 'package:flutter/material.dart';
import 'package:scrollytell/scrollytell.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Widget> panelList = [];

  @override
  void initState() {
    panelList.add(
      Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 32.0, 0.0, 32.0),
                child: Text(
                  'Animal Farm',
                  style: TextStyle(fontSize: 56),
                ),
              ),
            ),
            Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Mr. Jones of the Manor Farm,had locked the hen-houses for ,'
                  'the night but was too drunk to remember to shut the '
                  'pop-holes.\nWith the ring of light from his lantern dancing'
                  ' from side to side, her lurched accross the yard, kicked off'
                  ' his boots at the back door, drew himself a last back door,'
                  ' drew himself a last glass of beer from the barrel in the , '
                  'scullery, and made his way up to bed, where Mrs. Jones was'
                  ' already snoring.',
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 400,
            ),
          ],
        ),
      ),
    );
    panelList.add(
      Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              color: Colors.blue.withOpacity(0.8),
              child: Text(
                'Panel 2',
                style: TextStyle(
                  fontSize: 28,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              color: Colors.grey.withOpacity(0.5),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'As Soon as the light in the bedroom went out there was a stirring and a fluttering all through the farm buildings.',
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 400,
            ),
            Container(
              color: Colors.grey.withOpacity(0.5),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Word had gone round during the day that old Major, the prize Middle White boar, had a strange dream on the previous night and wished to communicate it to the other animals.',
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 400,
            ),
          ],
        ),
      ),
    );
    panelList.add(
      Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              color: Colors.blue.withOpacity(0.8),
              child: Text(
                'Panel 3',
                style: TextStyle(
                  fontSize: 28,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              color: Colors.grey.withOpacity(0.5),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'It had been agreed that they should all meet in the big barn as soon as Mr. Jones was safely out of the way',
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 400,
            ),
            Container(
              color: Colors.grey.withOpacity(0.5),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Old Major(so he was always called, through the name under which he had been exhibited was Willingdon Beauty) was so highly regarded on the farm that everyone was quite ready to lose an hour\'s sleep in order to hear what he had to say.',
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 400,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget overlayWidget;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ScrollyWidget(
        initialOverlayWidget: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.pinkAccent,
        ),
//        showDebugConsole: true,
        guidelinePosition: GuidelinePosition.center,
        opacity: 0.3,
        panels: panelList,
        panelStartCallback: (activePanelNumber, func) {},
        panelEndCallback: (activePanelNumber, func) {},
        panelProgressCallback: (activePanelNumber, progress, func) {
          var _size = 0.0;

          if (activePanelNumber != 1) {
            if (progress <= 0.5) {
              _size = 100 + progress * 100;
            } else {
              _size = 200 - progress * 100;
            }
          }

          Color color;
          if (activePanelNumber == 1) {
            color = Colors.pinkAccent;
          }
          if (activePanelNumber == 2) {
            color = Colors.lightBlue;
          }
          if (activePanelNumber == 3) {
            color = Colors.redAccent;
          }
          overlayWidget = Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: color,
            child: Center(
              child: Container(
                height: _size,
                width: _size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white),
                ),
              ),
            ),
          );
          func(overlayWidget);
        },
      ),
    );
  }
}
