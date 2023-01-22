import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'problem_dialog.dart';
import '../models/playable.dart';

class _HoverableCover extends StatefulWidget {
  final String imageUrl;

  const _HoverableCover({required this.imageUrl});

  @override
  State<_HoverableCover> createState() => _HoverableCoverState();
}

class _HoverableCoverState extends State<_HoverableCover> {
  bool showPlayIcon = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onHover: (hovered) {
          setState(() {
            showPlayIcon = hovered;
          });
        },
        onTap: () => null,
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Image.network(widget.imageUrl, height: 56.0, width: 56.0),
            if (showPlayIcon) const Icon(Icons.play_circle),
          ],
        ));
  }
}

class _TrackInfoPopup extends StatefulWidget {
  final int id;
  final bool readable;

  const _TrackInfoPopup({required this.id, required this.readable});

  @override
  State<_TrackInfoPopup> createState() => _TrackInfoPopupState();
}

class _TrackInfoPopupState extends State<_TrackInfoPopup> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final addToPlaylistItems = [
      PopupMenuItem(
          child: ListTile(
        leading: const Icon(Icons.navigate_before),
        title: Text(AppLocalizations.of(context)!.back),
      )),
      const PopupMenuItem(child: PopupMenuDivider()),
    ];
    final creditsItems = [
      PopupMenuItem(
          child: ListTile(
        leading: const Icon(Icons.navigate_before),
        title: Text(AppLocalizations.of(context)!.back),
      )),
      const PopupMenuItem(child: PopupMenuDivider()),
    ];

    final activeTrackItems = [
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
            leading: const Icon(Icons.radio),
            title: Text(AppLocalizations.of(context)!.launchTrackMix)),
      ),
      PopupMenuItem(
        child: ListTile(
            leading: const Icon(Icons.do_not_disturb),
            title: Text(AppLocalizations.of(context)!.doNotRecommend)),
      ),
      PopupMenuItem(
          child: PopupMenuButton(
              itemBuilder: (innerContext) => addToPlaylistItems,
              child: ListTile(
                leading: const Icon(Icons.playlist_add),
                title: Text(AppLocalizations.of(context)!.addToPlaylistAction),
                trailing: const Icon(Icons.navigate_next),
              ))),
      PopupMenuItem(
        child: ListTile(
            leading: const Icon(Icons.share),
            title: Text(AppLocalizations.of(context)!.share)),
      ),
      PopupMenuItem(
          child: PopupMenuButton(
              itemBuilder: (innerContext) => creditsItems,
              child: ListTile(
                leading: const Icon(Icons.people_outline),
                title: Text(AppLocalizations.of(context)!.seeCredits),
                trailing: const Icon(Icons.navigate_next),
              ))),
      PopupMenuItem(
        child: ListTile(
            leading: const Icon(Icons.report_problem),
            onTap: () => problemDialogBuilder(context, _formKey),
            title: Text(AppLocalizations.of(context)!.reportProblem)),
      ),
    ];
    final inactiveTrackItems = [
      PopupMenuItem(
        child: ListTile(
            leading: const Icon(Icons.radio),
            title: Text(AppLocalizations.of(context)!.launchTrackMix)),
      ),
      PopupMenuItem(
        child: ListTile(
            leading: const Icon(Icons.do_not_disturb),
            title: Text(AppLocalizations.of(context)!.doNotRecommend)),
      ),
      PopupMenuItem(
        child: ListTile(
            leading: const Icon(Icons.share),
            title: Text(AppLocalizations.of(context)!.share)),
      ),
      PopupMenuItem(
          child: PopupMenuButton(
              itemBuilder: (innerContext) => creditsItems,
              child: ListTile(
                leading: const Icon(Icons.people_outline),
                title: Text(AppLocalizations.of(context)!.seeCredits),
                trailing: const Icon(Icons.navigate_next),
              ))),
      PopupMenuItem(
        child: ListTile(
            leading: const Icon(Icons.report_problem),
            onTap: () => problemDialogBuilder(context, _formKey),
            title: Text(AppLocalizations.of(context)!.reportProblem)),
      ),
    ];
    return PopupMenuButton(
        icon: const Icon(
          Icons.more_horiz,
        ),
        itemBuilder: (innerContext) =>
            widget.readable ? activeTrackItems : inactiveTrackItems);
  }
}

class TrackCell extends StatelessWidget {
  final TrackShort track;

  const TrackCell({super.key, required this.track});

  @override
  Widget build(BuildContext context) {
    return track.readable
        ? Row(children: [
            _HoverableCover(imageUrl: track.album!.coverSmall),
            Tooltip(
                message: track.title,
                child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 215.0),
                    child: Text(
                      track.title,
                      overflow: TextOverflow.ellipsis,
                    ))),
            if (track.explicitLyrics)
              const Tooltip(
                child: Icon(Icons.explicit),
                message: 'EXPLICIT',
              ),
            const Spacer(),
            IconButton(
                icon: const Icon(Icons.lyrics),
                tooltip: AppLocalizations.of(context)!.playWithLyrics,
                onPressed: () {}),
            IconButton(
                icon: const Icon(Icons.favorite_border),
                tooltip: AppLocalizations.of(context)!.addToFavorite,
                onPressed: () {}),
            _TrackInfoPopup(id: track.id, readable: track.readable),
          ])
        : Opacity(
            opacity: 0.5,
            child: Row(children: [
              Image.network(track.album!.coverSmall, height: 56.0, width: 56.0),
              Tooltip(
                  message: AppLocalizations.of(context)!.trackNotAvailable,
                  child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 215.0),
                      child: Text(
                        track.title,
                        overflow: TextOverflow.ellipsis,
                      ))),
              if (track.explicitLyrics)
                const Tooltip(
                  child: Icon(Icons.explicit),
                  message: 'EXPLICIT',
                ),
              const Spacer(),
              _TrackInfoPopup(id: track.id, readable: track.readable),
            ]));
  }
}
