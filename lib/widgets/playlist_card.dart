import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/playable.dart';

class PlaylistCard extends StatefulWidget {
  final GestureTapCallback? onTap;
  final Playlist playlist;
  const PlaylistCard({super.key, required this.playlist, this.onTap});

  @override
  State<PlaylistCard> createState() => _PlaylistCardState();
}

class _PlaylistCardState extends State<PlaylistCard> {
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
                    padding: const EdgeInsets.all(16.0),
                    child: Column(mainAxisSize: MainAxisSize.min, children: <
                        Widget>[
                      Stack(
                          alignment: AlignmentDirectional.bottomStart,
                          children: [
                            Image.network(widget.playlist.pictureMedium,
                                height: 250.0,
                                opacity:
                                    AlwaysStoppedAnimation(active ? 0.75 : 1.0),
                                width: 250.0),
                          ]),
                      Row(children: [
                        Material(
                            color: Colors.transparent,
                            child: Center(
                                child: Ink(
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                    child: IconButton(
                                        icon: const Icon(Icons.play_circle),
                                        tooltip:
                                            AppLocalizations.of(context)!.play,
                                        onPressed: () {})))),
                        if (active) ...[
                          Material(
                              color: Colors.transparent,
                              child: Center(
                                  child: Ink(
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                      ),
                                      child: IconButton(
                                          icon:
                                              const Icon(Icons.favorite_border),
                                          tooltip: AppLocalizations.of(context)!
                                              .addToFavorite,
                                          onPressed: null)))),
                          Material(
                              color: Colors.transparent,
                              child: Center(
                                  child: Ink(
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                      ),
                                      child: PopupMenuButton(
                                          icon: const Icon(
                                            Icons.more_horiz,
                                          ),
                                          itemBuilder: (innerContext) => [
                                                PopupMenuItem(
                                                  child: ListTile(
                                                      leading: const Icon(Icons
                                                          .queue_play_next),
                                                      title: Text(
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .listenNext)),
                                                ),
                                                PopupMenuItem(
                                                  child: ListTile(
                                                      leading: const Icon(
                                                          Icons.add_to_queue),
                                                      title: Text(
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .addToQueue)),
                                                ),
                                                PopupMenuItem(
                                                  child: ListTile(
                                                      leading: const Icon(
                                                          Icons.share),
                                                      title: Text(
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .share)),
                                                ),
                                                if (widget.playlist.user !=
                                                    null)
                                                  PopupMenuItem(
                                                    child: ListTile(
                                                        leading: const Icon(Icons
                                                            .people_outline),
                                                        onTap: () {
                                                          Navigator.pushNamed(
                                                              context, '/user',
                                                              arguments: widget
                                                                  .playlist
                                                                  .user!
                                                                  .id);
                                                        },
                                                        title: Text(
                                                            AppLocalizations.of(
                                                                    context)!
                                                                .userProfile)),
                                                  ),
                                              ])))),
                        ]
                      ]),
                      Tooltip(
                          message: widget.playlist.title,
                          child: Text(widget.playlist.title,
                              overflow: TextOverflow.ellipsis)),
                      if (widget.playlist.trackCount != null)
                        Text(AppLocalizations.of(context)!
                            .tracksCount(widget.playlist.trackCount!))
                    ])))));
  }
}
