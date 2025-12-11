import 'package:flutter/material.dart';
import 'package:flutter_restorablez/flutter_restorablez.dart';

class ScollPage extends StatelessWidget {
  const ScollPage({super.key});

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
