import 'package:flutter/material.dart';
import 'package:flutter_restorablez/flutter_restorablez.dart';
import 'package:flutter_restorablez_example/pages/scroll_page.dart';
import 'package:flutter_restorablez_example/pages/tab_bar_page.dart';

/// To run the example app, clone/fork the repo!

void main() {
  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Restorablez Example',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Restorablez Example'),
        ),
        body: const SafeArea(
          child: _Body(),
        ),
      ),
    );
  }
}

class _Body extends StatefulWidget {
  const _Body();

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  List<(IconData, String)> get _items => const <(IconData, String)>[
        (Icons.mouse, 'Scrollable'),
        (Icons.tab, 'Tab Bar'),
        (Icons.type_specimen, 'Page 3'),
      ];

  Widget get _pageView {
    return PageView(
      clipBehavior: Clip.none,
      controller: _pageController,
      onPageChanged: _onPageChanged,
      physics: const NeverScrollableScrollPhysics(),
      children: const <Widget>[
        ScollPage(),
        TabBarPage(),
        Center(child: Text('Page 3')),
      ],
    );
  }

  void _onPageChanged(int index) {
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: In order for the page view to restore properly
    // the controller needs be involved in the restoration.
    return OrientationBuilder(
      builder: (_, Orientation orientation) {
        switch (orientation) {
          case Orientation.portrait:
            return _Portrait(
              controller: _pageController,
              items: _items,
              onPageChanged: _onPageChanged,
              pageView: _pageView,
            );
          case Orientation.landscape:
            return _Landscape(
              controller: _pageController,
              items: _items,
              onPageChanged: _onPageChanged,
              pageView: _pageView,
            );
        }
      },
    );
  }
}

class _Portrait extends StatelessWidget {
  const _Portrait({
    required this.controller,
    required this.items,
    required this.onPageChanged,
    required this.pageView,
  });

  final PageController controller;
  final List<(IconData, String)> items;
  final ValueChanged<int> onPageChanged;
  final Widget pageView;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: RestorableBottomNavigationBar(
        id: 'navigation',
        controller: controller,
        items: items
            .map(
              ((IconData, String) item) => BottomNavigationBarItem(
                icon: Icon(item.$1),
                label: item.$2,
              ),
            )
            .toList(),
        onTap: onPageChanged,
      ),
      body: pageView,
    );
  }
}

class _Landscape extends StatelessWidget {
  const _Landscape({
    required this.controller,
    required this.items,
    required this.onPageChanged,
    required this.pageView,
  });

  final PageController controller;
  final List<(IconData, String)> items;
  final ValueChanged<int> onPageChanged;
  final Widget pageView;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        RestorableNavigationRail(
          id: 'navigation',
          controller: controller,
          destinations: items
              .map(
                ((IconData, String) item) => NavigationRailDestination(
                  icon: Icon(item.$1),
                  label: Text(item.$2),
                ),
              )
              .toList(),
          onDestinationSelected: onPageChanged,
        ),
        const VerticalDivider(thickness: 1, width: 1),
        Expanded(child: pageView),
      ],
    );
  }
}
