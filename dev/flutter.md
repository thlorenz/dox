# Flutter

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Widgets](#widgets)
  - [Scaffold](#scaffold)
  - [Container](#container)
  - [Row/Column](#rowcolumn)
    - [Column](#column)
    - [Row](#row)
    - [Resources](#resources)
  - [Card](#card)
  - [Expanded](#expanded)
  - [Buttons](#buttons)
  - [Various](#various)
- [Material Design](#material-design)
  - [Resources](#resources-1)
- [App Icon](#app-icon)
  - [Resources](#resources-2)
- [Icons](#icons)
- [Custom Fonts](#custom-fonts)
  - [Resources](#resources-3)
  - [Text Baseline](#text-baseline)
- [Themes: Global](#themes-global)
  - [Resources](#resources-4)
- [Themes: Customizing Widgets](#themes-customizing-widgets)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


## Widgets

### Scaffold

```
+----------------+
|     App Bar    |
+----------------+
|                |
|                |
|                |
|    Body        |
|                |
|                |
|                |
+----------------+
```

### Container

- as big as possible without children
- with children shrinks
- _SaveArea_: avoids Nook + Top bar
- height, width are pixels
- margin: _EdgeInsets_
  - inspect via A-Studio.Flutter Inspector
  - inspect via VSCode `Dart: Open DevTools`
- padding: _EdgenInset_

### Row/Column

- center via main/cross axis alignment
  - top/bottom center on row via _main_, left/right via _cross_
  - top/bottom center on column via _cross_, left/right via _main_

#### Column

- takes up all vertical space by default
  - `mainAxisSize: .min|.max`
- `verticalDirection: .up|.down`
- `mainAxisAlignment`: default: `start` (vertical)
  - `.end|.center|.spaceEvenly|.spaceBetween`
- `crossAxisAlignment`: horizontal
- takes up minimal horizontal space
  - add invisible container `width: double.infinity` to stretch it
  - align visible children via _crossAxis_
- SizedBox with hight to add space between two items

#### Row

- same as Column, but main/cross axis reversed

#### Resources

- [layout cheat sheet](https://medium.com/flutter-community/flutter-layout-cheat-sheet-5363348d037e)
- [layout cheat sheet](https://medium.com/jlouage/flutter-row-column-cheat-sheet-78c38d242041)

### Card

- needs to be used iniside _Padding_
- commonly used with _ListTile_

```
+-----------------------------------------+
|         |       title       |           |
| leading --------------------- trailing  |
|               subtitle                  |
+-----------------------------------------+
```

### Expanded

- expands child of roe/column to fill available space
- divided according to `flex` facto
  - relative to `1`, default is `1`
  - may express ratios, i.e. `12:5`

### Buttons

- _FloatingActionButton_: only one per screen
  - extends _RawMaterialButton_ which should be used to customize buttons

```dart
Widget build(BuildContext context) {
  return RawMaterialButton(
    child: Icon(this.icon),
    onPressed: () {},
    elevation: 6,
    constraints: BoxConstraints.tightFor(
      width: 56.0,
      height: 56.0,
    ),
    shape: CircleBorder(),
    fillColor: Color(0xFF4C4F5E),
  );
}
```

### Various

- [Circle Avatar](https://api.flutter.dev/flutter/material/CircleAvatar-class.html)
- [Sized Box](https://api.flutter.dev/flutter/widgets/SizedBox-class.html) with
  [Divider](https://api.flutter.dev/flutter/material/Divider-class.html) child to add separator line

## Material Design

### Resources

- [material design](https://material.io/design/)
- [color picking tools](https://material.io/design/color/the-color-system.html#tools-for-picking-colors)
- [material icons](https://material.io/tools/icons)

## App Icon

- android: `android/app/src/main/res`
- ios: `Runner/Asses.xc/assets`
- Android Studio: select `res` and _Create Image Asset_ to resize/change the app icon

### Resources

- [app icon generator](https://appicon.co/) upload an image, download icons for each mobile
- [free icons download](https://icons8.com/)
- [free vector art download](https://www.vecteezy.com/)

## Icons

- [font awesome icons](https://github.com/brianegan/font_awesome_flutter) to use [font
  awesome](https://fontawesome.com/icons) icon pack

## Custom Fonts

- download from google fonts -> unzip -> drop `.ttf` into project i.e. to a `./fonts` folder
- add to pubspec under `fonts:`

```yaml
fonts:
  - family: Pacifico
    fonts:
      - asset: fonts/Pacifico-Regular.ttf
```

- use `fontFamily: 'Pacifico'`

### Resources

- [google fonts](https://fonts.google.com/) free to use

### Text Baseline

```dart
Row(
  mainAxisAlignment: MainAxisAlignment.center,
  crossAxisAlignment: CrossAxisAlignment.baseline,
  textBaseline: TextBaseline.alphabetic,
  children: <Widget>[
    Text(_height.toString(), style: largeNumberStyle),
    Text('cm', style: labelTextStyle),
  ],
),
```

## Themes: Global

- consistent styling
- `ThemeData theme` widget
- default Flutter light theme
- built in `.dark`
- has properties for specific widgets
  - _Card_ color
  - _FloatingActionButton_ theme
- extend themes via `.copyWith`

```dart
MaterialApp(
  theme: ThemeData.dark().copyWith(
    primaryColor: Color(0xFF0A0E21),
    scaffoldBackgroundColor: Color(0xFF0A0E21),
  )
)
```

### Resources

- [themes cookbook](https://flutter.dev/docs/cookbook/design/themes)

## Themes: Customizing Widgets

- widget specific theme properties provide fine grained control over their appearance
- slider: add `SliderThemeData` by embedding slider inside a `SliderTheme` which has `data:
  SliderThemeData` property
  - extend default theme via `SliderTheme.of(context).copyWith()`

```dart
SliderTheme(
  data: SliderTheme.of(context).copyWith(
    activeTrackColor: Colors.white,
    inactiveTrackColor: Color(0xFF8D8E98),
    thumbColor: Color(0xFFEB1555),
    overlayColor: Color(0x29EB1555),
    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 15),
    overlayShape: RoundSliderOverlayShape(overlayRadius: 30),
    ),
  child: Slider(
    onChanged: (double value) => height = value,
    value: _height.toDouble(),
    min: 120,
    max: 220,
  ),
)
```
