import 'package:flutter/material.dart';
import 'package:flutter_restorablez/flutter_restorablez.dart';

class TabBarPage extends StatelessWidget {
  const TabBarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: const RestorableTabBar(
            id: 'example-tab-bar',
            tabs: <Widget>[
              Tab(text: 'Tab 1'),
              Tab(text: 'Tab 2'),
              Tab(text: 'Tab 3'),
            ],
          ),
        ),
        body: const TabBarView(
          children: <Widget>[
            Center(child: Text('Content for Tab 1')),
            Center(child: Text('Content for Tab 2')),
            Center(child: Text('Content for Tab 3')),
          ],
        ),
      ),
    );
  }
}
