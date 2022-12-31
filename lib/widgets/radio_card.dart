import 'package:flutter/material.dart';

import '../models/playable.dart' as playable;

class RadioCard extends StatelessWidget {
  final GestureTapCallback? onTap;
  final playable.Radio radio;
  const RadioCard({super.key, required this.radio, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
        child: InkWell(
            onTap: onTap,
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              Image.network(radio.pictureMedium, height: 250.0, width: 250.0),
              Text(radio.title),
            ])));
  }
}
