import 'package:flutter/material.dart';

import '../models/playable.dart' as playable;

class RadioCard extends StatelessWidget {
  final playable.Radio radio;
  const RadioCard({super.key, required this.radio});

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      Image.network(radio.pictureMedium, height: 250.0, width: 250.0),
      Text(radio.title),
    ]));
  }
}
