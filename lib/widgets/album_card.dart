import 'package:flutter/material.dart';

import '../models/playable.dart';

class AlbumCard extends StatelessWidget {
  final AlbumShort album;
  final GestureTapCallback? onTap;
  const AlbumCard({super.key, required this.album, this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 250.0,
        child: Card(
            child: InkWell(
                onTap: onTap,
                child:
                    Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                  Image.network(album.coverMedium, height: 250.0, width: 250.0),
                  Text(album.title),
                  //Text(album.artist.name)
                ]))));
  }
}
