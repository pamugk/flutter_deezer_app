import 'package:flutter/material.dart';

import '../models/playable.dart';

class ArtistCard extends StatelessWidget {
  final Artist artist;
  final GestureTapCallback? onTap;
  const ArtistCard({super.key, required this.artist, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 34.0, top: 24.0),
        child: SizedBox(
            width: 250.0,
            child: Card(
                child: InkWell(
                    onTap: onTap,
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Image.network(artist.pictureMedium,
                              height: 250.0, width: 250.0),
                          Text(artist.name),
                          Text('Слушателей: ${artist.fanCount ?? 0}'),
                        ])))));
  }
}
