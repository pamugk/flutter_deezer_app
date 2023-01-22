import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/playable.dart';

class ArtistCard extends StatefulWidget {
  final Artist artist;
  final GestureTapCallback? onTap;
  const ArtistCard({super.key, required this.artist, this.onTap});

  @override
  State<ArtistCard> createState() => _ArtistCardState();
}

class _ArtistCardState extends State<ArtistCard> {
  bool active = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 282.0,
        child: Card(
            child: InkWell(
                onHover: (hovered) {
                  setState(() {
                    active = hovered;
                  });
                },
                onTap: widget.onTap,
                child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(mainAxisSize: MainAxisSize.min, children: <
                        Widget>[
                      Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        children: [
                          Opacity(
                              opacity: active ? 0.75 : 1.0,
                              child: CircleAvatar(
                                backgroundImage:
                                    NetworkImage(widget.artist.pictureMedium),
                                radius: 125.0,
                              )),
                          if (active)
                            Row(mainAxisSize: MainAxisSize.min, children: [
                              Material(
                                  color: Colors.transparent,
                                  child: Center(
                                      child: Ink(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white,
                                          ),
                                          child: IconButton(
                                              icon:
                                                  const Icon(Icons.play_circle),
                                              tooltip:
                                                  AppLocalizations.of(context)!
                                                      .mix,
                                              onPressed: () {})))),
                              Material(
                                  color: Colors.transparent,
                                  child: Center(
                                      child: Ink(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white,
                                          ),
                                          child: IconButton(
                                              icon: const Icon(
                                                  Icons.favorite_border),
                                              tooltip:
                                                  AppLocalizations.of(context)!
                                                      .addToFavorite,
                                              onPressed: null)))),
                            ])
                        ],
                      ),
                      Tooltip(
                          message: widget.artist.name,
                          child: Text(widget.artist.name,
                              overflow: TextOverflow.ellipsis)),
                      Text(AppLocalizations.of(context)!
                          .fansCount(widget.artist.fanCount ?? 0)),
                    ])))));
  }
}
