# ✨ Flutter  Scrollytell


A collection of loading indicators animated with flutter. Inspired by [@google](https://github.com/google)'s [Scrollytell](https://github.com/google/scrollytell).

## 🎖 Installing

```yaml
dependencies:
  
```

### ⚡️ Import

```dart
import 'package:scrollytell/scrollytell.dart';
```

## 🎮 How To Use
#### Declare a List of Widgets
```dart
List<Widget> panelList = [Text('Hello Scrollytell'), Text('Hello Flutter')];
```
#### Declare an Overlay Widget
```dart
Widget overlayWidget;
```
#### Use ScrollyWidget as child or root
```dart
ScrollyWidget(
    height:500,
    width: 300,
    panels: panelList,
    panelStartCallback: (activePanelNumber, func){},
    panelEndCallback: (endingPanelNumber, func){},
    panelProgressCallback: (activePanelNumber, progress, func){
    
        // set properties of overlay widget using activePanelNumber and progress
        
        double rad = (progress <= 0.5) ? progress * 200 : 200 - progress * 200;
        overlayWidget = Center(
            child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                        Radius.circular(rad),
                    ),
                color: Colors.red,
                ),
            ),
        );
        
        // then pass it into the function
        
        func(overlayWidget)
    },
)
```

For more info, please, refer to the `basic_usage` app in the example.

## 🚀 Showcase

<table>
  <tr>
    <td align="center">
      <img src="https://github.com/mdg-iitr/scrollytell/blob/master/screenshots/BasicUsage.gif" width="300px">
    </td>
  </tr>
</table>


## 🐛 Bugs/Requests

If you encounter any problems feel free to open an issue. If you feel the library is
missing a feature, please raise a ticket on Github and I'll look into it.
Pull request are also welcome.

### ❗️ Note

For help getting started with Flutter, view our online [documentation](https://flutter.io/).
For help on editing plugin code, view the [documentation](https://flutter.io/platform-plugins/#edit-code).

## ⭐️ License

