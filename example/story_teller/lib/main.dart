import 'package:flutter/material.dart';
import 'package:scrollytell/scrollytell.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Life In Images',
      home: HomePage(),
    );
  }
}

List<Widget> panelList;

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Image> images;

  @override
  void initState() {
    images = [];
    images.add(Image.asset(
      "assets/1.jpeg",
      fit: BoxFit.cover,
      height: double.infinity,
      width: double.infinity,
      alignment: Alignment.center,
    ));
    images.add(Image.asset(
      "assets/2.jpeg",
      fit: BoxFit.cover,
      height: double.infinity,
      width: double.infinity,
      alignment: Alignment.center,
    ));
    images.add(Image.asset(
      "assets/3.jpeg",
      fit: BoxFit.cover,
      height: double.infinity,
      width: double.infinity,
      alignment: Alignment.center,
    ));
    images.add(Image.asset(
      "assets/4.jpeg",
      fit: BoxFit.cover,
      height: double.infinity,
      width: double.infinity,
      alignment: Alignment.center,
    ));
    images.add(Image.asset(
      "assets/12.jpeg",
      fit: BoxFit.cover,
      height: double.infinity,
      width: double.infinity,
      alignment: Alignment.center,
    ));

    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    images.forEach((image) => precacheImage(image.image, context));
  }

  @override
  Widget build(BuildContext context) {
    buildPanelList(context);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Center(
              child: Text(
            "Life in images",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: "ProductSans"),
          )),
        ),
        body: ScrollyWidget(
          showDebugConsole: true,
          initialOverlayWidget: Center(
            child: Opacity(
              opacity: 0.5,
              child: images[0]
            ),
          ),
          guidelinePosition: GuidelinePosition.center,
          panels: panelList,
          panelStartCallback: (activePanelIndex, func) {
            var overlaywidget;

            switch (activePanelIndex) {
              case 2:
                overlaywidget =
                    Opacity(opacity: 0.5, child: Center(child: images[0]));
                break;
              case 3:
                overlaywidget =
                    Opacity(opacity: 0.5, child: Center(child: images[1]));
                break;
              case 4:
                overlaywidget =
                    Opacity(opacity: 0.5, child: Center(child: images[2]));
                break;
              case 5:
                overlaywidget =
                    Opacity(opacity: 0.5, child: Center(child: images[3]));
                break;
              case 6:
                overlaywidget =
                    Opacity(opacity: 0.5, child: Center(child: images[4]));
                break;
              default:
                overlaywidget =
                    Opacity(opacity: 0.5, child: Center(child: images[5]));
                break;
            }
            func(overlaywidget);
          },
          panelEndCallback: (activePanelIndex, func) {},
          panelProgressCallback: (activePanelIndex, progress, func) {},
        ));
  }
}

buildPanelList(context) {
  panelList = [];

  //Adding a fake panel as explained in the usage tips
  panelList.add(Container(
    height: MediaQuery.of(context).size.height * 0.42,
  ));
  panelList.add(MuskWidget('Elon Musk'));
  panelList.add(MuskWidget(
      'In 1995, Mr. Musk launched his first million-dollar company with his brother'));
  panelList.add(MuskWidget(
      'In 1999, Musk Zip2 to compaq and start X.com which later became paypal'));
  panelList
      .add(MuskWidget('In 2002, He poured \$100 million into founding SpaceX'));
  panelList.add(MuskWidget(
      'In Dec 2016, He was ranked 21st on Forbes Most Influential People List'));
}

class MuskWidget extends StatelessWidget {
  MuskWidget(this.text);
  final text;
  final style = TextStyle(
      color: Colors.black,
      fontSize: 26,
      fontWeight: FontWeight.bold,
      fontFamily: "ProductSans");

  @override
  Widget build(BuildContext context) {
    final _screenHeight = MediaQuery.of(context).size.height * 0.8;
    return Center(
        child: Container(
            height: _screenHeight * .8,
            child: Text(
              text,
              style: style,
              textAlign: TextAlign.center,
            )));
  }
}
