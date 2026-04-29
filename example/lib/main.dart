import 'package:flutter/material.dart';
import 'package:flutter_restorablez/flutter_restorablez.dart';
import 'package:flutter_restorablez_example/pages/scroll_page.dart';
import 'package:flutter_restorablez_example/pages/tab_bar_page.dart';

/// To run the example app, clone/fork the repo!

void main() {
  runApp(Main());
}

class Main extends StatelessWidget {
  Main({super.key});

  final GlobalKey<RestorableBottomNavigationBarState> _bottomNavKey =
      GlobalKey<RestorableBottomNavigationBarState>();
  final GlobalKey<RestorableNavigationRailState> _sideNavKey =
      GlobalKey<RestorableNavigationRailState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Restorablez Example',
      theme: ThemeData(
        useMaterial3: false,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Restorablez Example'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                _bottomNavKey.currentState?.reset();
                _sideNavKey.currentState?.reset();
              },
            ),
          ],
        ),
        body: SafeArea(
          child: _Body(
            bottomNavKey: _bottomNavKey,
            sideNavKey: _sideNavKey,
          ),
        ),
      ),
    );
  }
}

class _Body extends StatefulWidget {
  const _Body({
    required this.bottomNavKey,
    required this.sideNavKey,
  });

  final GlobalKey<RestorableBottomNavigationBarState> bottomNavKey;
  final GlobalKey<RestorableNavigationRailState> sideNavKey;

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
    return OrientationBuilder(
      builder: (_, Orientation orientation) {
        switch (orientation) {
          case Orientation.portrait:
            return _Portrait(
              navKey: widget.bottomNavKey,
              controller: _pageController,
              items: _items,
              onPageChanged: _onPageChanged,
              pageView: _pageView,
            );
          case Orientation.landscape:
            return _Landscape(
              navKey: widget.sideNavKey,
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
    required this.navKey,
    required this.controller,
    required this.items,
    required this.onPageChanged,
    required this.pageView,
  });

  final GlobalKey<RestorableBottomNavigationBarState> navKey;
  final PageController controller;
  final List<(IconData, String)> items;
  final ValueChanged<int> onPageChanged;
  final Widget pageView;

  List<BottomNavigationBarItem> get _navItems => items
      .map(
        ((IconData, String) item) => BottomNavigationBarItem(
          icon: Icon(item.$1),
          label: item.$2,
        ),
      )
      .toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: RestorableBottomNavigationBar(
        id: 'navigation',
        key: navKey,
        controller: controller,
        items: _navItems,
        onTap: onPageChanged,
      ),
      body: pageView,
    );
  }
}

class _Landscape extends StatelessWidget {
  const _Landscape({
    required this.navKey,
    required this.controller,
    required this.items,
    required this.onPageChanged,
    required this.pageView,
  });

  final GlobalKey<RestorableNavigationRailState> navKey;
  final PageController controller;
  final List<(IconData, String)> items;
  final ValueChanged<int> onPageChanged;
  final Widget pageView;

  List<NavigationRailDestination> get _navItems => items
      .map(
        ((IconData, String) item) => NavigationRailDestination(
          icon: Icon(item.$1),
          label: Text(item.$2),
        ),
      )
      .toList();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        RestorableNavigationRail(
          id: 'navigation',
          key: navKey,
          controller: controller,
          destinations: _navItems,
          onDestinationSelected: onPageChanged,
        ),
        const VerticalDivider(thickness: 1, width: 1),
        Expanded(child: pageView),
      ],
    );
  }
}
