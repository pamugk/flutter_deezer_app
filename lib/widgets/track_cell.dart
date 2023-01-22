import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
            if (showPlayIcon)
              const Icon(
                Icons.play_circle_filled,
                color: Colors.white,
              ),
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

  Future<void> _problemDialogBuilder(BuildContext context) {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(AppLocalizations.of(context)!.reportProblem),
            content: Form(
              key: _formKey,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    FormField<bool>(
                      builder: (state) => CheckboxListTile(
                        onChanged: state.didChange,
                        title:
                            Text(AppLocalizations.of(context)!.problemArtist),
                        value: state.value!,
                      ),
                      initialValue: false,
                    ),
                    FormField<bool>(
                      builder: (state) => CheckboxListTile(
                        onChanged: state.didChange,
                        title: Text(AppLocalizations.of(context)!.problemSound),
                        value: state.value!,
                      ),
                      initialValue: false,
                    ),
                    FormField<bool>(
                      builder: (state) => CheckboxListTile(
                        onChanged: state.didChange,
                        title: Text(
                            AppLocalizations.of(context)!.problemSuspicious),
                        value: state.value!,
                      ),
                      initialValue: false,
                    ),
                    FormField<bool>(
                      builder: (state) => CheckboxListTile(
                        onChanged: state.didChange,
                        title: Text(AppLocalizations.of(context)!.problemOther),
                        value: state.value!,
                      ),
                      initialValue: false,
                    ),
                    TextField(
                      decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!
                              .problemOtherComment),
                      enabled: false,
                    ),
                  ]),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: Text(AppLocalizations.of(context)!.cancel),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(AppLocalizations.of(context)!.submit),
              ),
            ],
          );
        });
  }

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
            onTap: () => _problemDialogBuilder(context),
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
            onTap: () => _problemDialogBuilder(context),
            title: Text(AppLocalizations.of(context)!.reportProblem)),
      ),
    ];
    return PopupMenuButton(
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
