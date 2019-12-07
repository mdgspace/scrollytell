# ✨ Scrollytell Flutter



A flutter package to implement **ScrollyTelling** in your flutter app. Using ScrollyTell you can have the background changing dynamically as you scroll. ScrollyTell provides a mechanism to fully control this behaviour.

## 🎖 Installing

```yaml
dependencies:
  scrollytell: ^1.0.1
```

### ⚡️ Import

```dart
import 'package:scrollytell/scrollytell.dart';
```
## Props

| props  | type  | default value | Description |
| :------------ |:---------------:| :------------:| :------------:|
| panels (required)      | List Widget |       | A list of panel widgets |
| panelStartCallback (required)     | Function(num, Function)      |  | Called on start of new panel |
| panelEndCallback (required) | Function(num, Function)        | |Called on end of existing panel |
| panelProgressCallback (required) | Function(num, double, Function) |  |Called every frame |
| opacity | double | 1 | Set opacity of overlayWidget |
| lastPanelForceComplete | bool | false | Set true if the last panel hits bottom of the screen and can't be scrolled through |
| initialOverlayWidget | Widget | none | Overlay widget before start of scrolling |
| guidelinePosition | GuidelinePosition | GuidelinePosition.top | Set position of guideline |
| stickyChartIndex | int | null | The panel of corresponding index will dock at center when scrolled past the center |
| showDebugConsole | bool | false | show debug console and debug line |


## 🎮 How To Use

#### Declare a List of Widgets
```dart
List<Widget> panelList = [Text('Hello Scrollytell'), Text('Hello Flutter')];
```
#### Declare an Overlay Widget
```dart
Widget overlayWidget;
```
#### Declare a ScrollyWidget
```dart
Widget _scrollyWidget = ScrollyWidget(
		   showDebugConsole: true,
  	           guidelinePosition: GuidelinePosition.center,
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

#### Now Wrap it in either Expanded, Flexible or Container
> Option 1 : Wrap in Expanded for covering the remaining screen.
```dart
Expanded(child: _scrollyWidget)
```
> Option 2 : Wrap in Flexible
```dart
Flexible(child: _scrollyWidget)
```
> Option 3 : Wrap in container to give it desired size.
```dart
Container(height: 500, width: 300, child: _scrollyWidget)
```
#### OR Use it directly as body of Scaffold.
```dart
Scaffold(body: _scrollyWidget)
```

For more info, refer to the `basic_usage` app in the example.

## 🚀 Showcase

<table>
  <tr>
    <td align="center">
      <img src="https://raw.githubusercontent.com/mdg-iitr/scrollytell/master/screenshots/BasicUsage.gif" width="300px">
    </td>
  </tr>
</table>


## 🐛 Bugs/Requests

If you encounter any problems feel free to open an issue. If you feel the library is
missing a feature, please raise a issue(label:enhancement) on Github and we will look into it.
Pull requests are most welcome.

## 🤝 Guidelines for Contributors

If you want to contribute to improve this library, please read our [guidelines](https://github.com/mdg-iitr/scrollytell/blob/master/CONTRIBUTING.md). Feel free to open an [issue](https://github.com/mdg-iitr/scrollytell/issues).


## ⭐️ License

MIT License
[view license](https://github.com/mdg-iitr/scrollytell/blob/master/LICENSE)

This project draws inspiration from [@google](https://github.com/google)'s [Scrollytell](https://github.com/google/scrollytell).
