import 'package:flutter/material.dart';

import '../models/playable.dart';

class PlaylistCard extends StatelessWidget {
  final GestureTapCallback? onTap;
  final Playlist playlist;
  const PlaylistCard({super.key, required this.playlist, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
        child: InkWell(
            onTap: onTap,
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              Image.network(playlist.pictureMedium,
                  height: 250.0, width: 250.0),
              Text(playlist.title),
              Text('Треков: ${playlist.trackCount}')
            ])));
  }
}
