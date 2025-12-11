# Flutter Restorablez

![pub package](https://img.shields.io/pub/v/flutter_restorablez)

Restorable Flutter widgets that automatically save and restore positions for widgets such as scrollables, tab bar and navigation bar.

## Documentation

The [generated documentation](https://pub.dev/documentation/flutter_restorablez/latest) has a great overview of all that is available.

## Features

### RestorableScroll

```dart
RestorableScroll(
  id: 'example-scroll',
  builder: (BuildContext context, ScrollController controller) {
    return ListView.builder(
      controller: controller,
      itemCount: 200,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text('Item $index'),
        );
      },
    );
  },
);
```

### RestorableTabBar

```dart
DefaultTabController(
  length: 3,
  child: Scaffold(
    appBar: AppBar(
      title: 'Example Tab Bar',
    ),
    bottom: RestorableTabBar(
      id: 'example-tab-bar',
      tabs: <Widget>[
        Tab(text: 'Tab 1'),
        Tab(text: 'Tab 2'),
        Tab(text: 'Tab 3'),
      ],
    ),
    body: TabBarView(
      children: <Widget>[
        Text('Child 1'),
        Text('Child 2'),
        Text('Child 3'),
      ],
    ),
  ),
);
```
