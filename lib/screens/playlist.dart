import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/playable.dart';
import '../providers/deezer.dart';
import '../utils/duration.dart';
import '../widgets/drawer.dart';
import '../widgets/player.dart';
import '../widgets/track_table.dart';

class PlaylistPage extends StatefulWidget {
  const PlaylistPage({super.key});

  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

bool _checkTrack(TrackShort track, String searchText) {
  final normalizedSearchText = searchText.toLowerCase();
  return track.title.toLowerCase().contains(normalizedSearchText) ||
      track.album!.title.toLowerCase().contains(normalizedSearchText) ||
      track.artist.name.toLowerCase().contains(normalizedSearchText);
}

class _PlaylistPageState extends State<PlaylistPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  String _searchText = '';

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)!.settings.arguments as int;
    return FutureBuilder<Playlist>(
        future: getPlaylist(id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final playlist = snapshot.data!;
            final lastUpdated = playlist.tracks
                ?.map((track) => track.added)
                .reduce((date, otherDate) =>
                    date.isAfter(otherDate) ? date : otherDate);
            return Scaffold(
                key: _scaffoldKey,
                appBar: AppBar(
                  title: InkWell(
                      onTap: () {
                        _scaffoldKey.currentState!.openEndDrawer();
                      },
                      child: Row(children: [
                        Image.network(playlist.pictureSmall,
                            height: 56.0, width: 56.0),
                        Text(playlist.title),
                      ])),
                  actions: <Widget>[
                    IconButton(
                        icon: const Icon(Icons.play_circle),
                        tooltip: AppLocalizations.of(context)!.play,
                        onPressed: () {}),
                    IconButton(
                        icon: const Icon(Icons.favorite_border),
                        tooltip: AppLocalizations.of(context)!.addToFavorite,
                        onPressed: null),
                    IconButton(
                      icon: const Icon(Icons.search),
                      tooltip: AppLocalizations.of(context)!.search,
                      onPressed: () {
                        Navigator.pushNamed(context, '/search');
                      },
                    ),
                  ],
                ),
                body: SizedBox.expand(
                    child: Padding(
                        padding: const EdgeInsets.only(bottom: 100.0),
                        child: SingleChildScrollView(
                            child: TrackTable(
                          placeholder: Center(
                              child: Text(
                                  AppLocalizations.of(context)!.nothingFound)),
                          title: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: 0.4,
                              child: TextField(
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  hintText:
                                      AppLocalizations.of(context)!.search,
                                  prefix: const Icon(Icons.search),
                                ),
                                onChanged: (text) {
                                  setState(() {
                                    _searchText = text;
                                  });
                                },
                              )),
                          tracks: [
                            for (var track in playlist.tracks!)
                              if (_checkTrack(track, _searchText)) track
                          ],
                        )))),
                drawer: const AppDrawer(),
                endDrawer: Drawer(
                    child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(playlist.pictureMedium,
                          height: 250.0, width: 250.0),
                      if (playlist.description != null)
                        Text(playlist.description!),
                      Text(AppLocalizations.of(context)!
                          .durationValue(formatDuration(playlist.duration!))),
                      Text(AppLocalizations.of(context)!
                          .tracksCount(playlist.trackCount ?? 0)),
                      Text(AppLocalizations.of(context)!
                          .fansCount(playlist.fanCount ?? 0)),
                      if (playlist.creationDate != null)
                        Text(AppLocalizations.of(context)!
                            .playlistCreated(playlist.creationDate!)),
                      if (lastUpdated != null)
                        Text(AppLocalizations.of(context)!
                            .playlistCreated(lastUpdated)),
                    ],
                  ),
                )),
                bottomSheet: const Player());
          }
          return snapshot.hasError
              ? Scaffold(
                  appBar:
                      AppBar(title: Text(AppLocalizations.of(context)!.error)),
                  body: Center(child: Text('${snapshot.error}')),
                  drawer: const AppDrawer(),
                  bottomSheet: const Player())
              : Scaffold(
                  appBar: AppBar(
                      title: Text(AppLocalizations.of(context)!.loading)),
                  body: const Center(child: CircularProgressIndicator()),
                  drawer: const AppDrawer(),
                  bottomSheet: const Player());
        });
  }
}
