import 'package:flutter/material.dart';

import '../models/playable.dart';

class AlbumCard extends StatelessWidget {
  final Album album;
  const AlbumCard({super.key, required this.album});

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      Image.network(album.coverMedium, height: 250.0, width: 250.0),
      Text(album.title),
      Text(album.artist.name)
    ]));
  }
}
