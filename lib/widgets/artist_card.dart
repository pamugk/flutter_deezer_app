import 'package:flutter/material.dart';

import '../models/playable.dart';

class ArtistCard extends StatelessWidget {
  final Artist artist;
  const ArtistCard({super.key, required this.artist});

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      Image.network(artist.pictureMedium, height: 250.0, width: 250.0),
      Text(artist.name),
      Text('Слушателей: ${artist.fanCount ?? 0}'),
    ]));
  }
}
