import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'image_dialog.dart';
import 'problem_dialog.dart';
import '../models/playable.dart';

class AlbumCard extends StatefulWidget {
  final AlbumShort album;
  final GestureTapCallback? onTap;
  const AlbumCard({super.key, required this.album, this.onTap});

  @override
  State<AlbumCard> createState() => _AlbumCardState();
}

class _AlbumCardState extends State<AlbumCard> {
  bool active = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
                child:
                    Padding(
    padding: EdgeInsets.all(16.0),
    child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                  Stack(
                    alignment: AlignmentDirectional.bottomStart,
                    children: [
                      Image.network(widget.album.coverMedium, height: 250.0, opacity: AlwaysStoppedAnimation(active ? 0.75 : 1.0), width: 250.0),
                      Row(
                        children: [
                          Material(
                          color: Colors.transparent,
                          child: Center(
                            child: Ink(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.play_circle),
                              tooltip: AppLocalizations.of(context)!.play,
                              onPressed: () {})))),
                          if (active)
                            ...[
                              Material(
                                color: Colors.transparent,
                                child: Center(
                                  child: Ink(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                  ),
                                  child: IconButton(
                                    icon: const Icon(Icons.favorite_border),
                                    tooltip: AppLocalizations.of(context)!.addToFavorite,
                                    onPressed: null)))),
                              Material(
                                color: Colors.transparent,
                                child: Center(
                                  child: Ink(
                                  decoration: BoxDecoration(
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
                                        leading: const Icon(Icons.queue_play_next),
                                        title: Text(AppLocalizations.of(context)!.listenNext)),
                                  ),
                                  PopupMenuItem(
                                    child: ListTile(
                                        leading: const Icon(Icons.add_to_queue),
                                        title: Text(AppLocalizations.of(context)!.addToQueue)),
                                  ),
                                  PopupMenuItem(
                                    child: ListTile(
                                        leading: const Icon(Icons.share),
                                        title: Text(AppLocalizations.of(context)!.share)),
                                  ),
                                  PopupMenuItem(
                                    child: ListTile(
                                        leading: const Icon(Icons.preview),
                                        onTap: () => showDialog<void>(
                                          context: context,
                                          builder: (BuildContext context) => imageDialogBuilder(context, widget.album.coverXl!, widget.album.title)),
                                        title: Text(AppLocalizations.of(context)!.zoomCover)),
                                  ),
                                  PopupMenuItem(
                                    child: ListTile(
                                        leading: const Icon(Icons.report_problem),
                                        onTap: () => problemDialogBuilder(context, _formKey),
                                        title: Text(AppLocalizations.of(context)!.reportProblem))),
                                ]
                              )))),
                            ]
                        ]
                      ),
                  ]),
                  Tooltip(
                    message: widget.album.title,
                    child: Text(widget.album.title, overflow: TextOverflow.ellipsis)
                  ),
                  //Text(widget.album.artist.name)
                ])))));
  }
}
