import 'package:flutter/material.dart';

import '../models/playable.dart';

class AlbumCard extends StatelessWidget {
  final Album album;
  final GestureTapCallback? onTap;
  const AlbumCard({super.key, required this.album, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
        child: InkWell(
            onTap: onTap,
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              Image.network(album.coverMedium, height: 250.0, width: 250.0),
              Text(album.title),
              Text(album.artist.name)
            ])));
  }
}
