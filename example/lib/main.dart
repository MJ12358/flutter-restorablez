import 'package:flutter/material.dart';
import 'package:flutter_restorablez/flutter_restorablez.dart';

/// To run the example app, clone/fork the repo!

void main() {
  runApp(const Main());
}

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Restorablez Example',
      theme: ThemeData(
        primaryColor: Colors.blue,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Restorablez Example'),
        ),
        body: SafeArea(
          child: PageView(
            controller: _pageController,
            children: const <Widget>[
              _ScollPage(),
              _TabBarPage(),
              Center(child: Text('Page 3')),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScollPage extends StatelessWidget {
  const _ScollPage();

  @override
  Widget build(BuildContext context) {
    return RestorableScroll(
      id: 'example-scroll',
      builder: (BuildContext context, ScrollController controller) {
        return ListView.builder(
          controller: controller,
          itemCount: 200,
          itemBuilder: (_, int index) {
            return ListTile(
              title: Text('Item $index'),
            );
          },
        );
      },
    );
  }
}

class _TabBarPage extends StatelessWidget {
  const _TabBarPage();

  @override
  Widget build(BuildContext context) {
    return const RestorableTabBar(
      id: 'example-tab-bar',
      tabs: <Tab>[
        Tab(text: 'Tab 1'),
        Tab(text: 'Tab 2'),
        Tab(text: 'Tab 3'),
      ],
    );
  }
}
