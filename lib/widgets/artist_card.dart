import 'package:flutter/material.dart';

import '../models/playable.dart';

class ArtistCard extends StatelessWidget {
  final Artist artist;
  final GestureTapCallback? onTap;
  const ArtistCard({super.key, required this.artist, this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 250.0,
        child: Card(
            child: InkWell(
                onTap: onTap,
                child:
                    Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                  Image.network(artist.pictureMedium,
                      height: 250.0, width: 250.0),
                  Text(artist.name),
                  Text('Поклонников: ${artist.fanCount ?? 0}'),
                ]))));
  }
}
