import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/playable.dart';
import '../navigation/artist_arguments.dart';
import '../providers/deezer.dart';
import '../utils/duration.dart';
import '../widgets/drawer.dart';
import '../widgets/player.dart';
import '../widgets/track_cell.dart';

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
  Set<int> _selectedRows = {};
  int? _sortColumnIdx;
  bool _sortOrderAsc = true;

  void _onSort(int columnIndex, bool asc) {
    if (_sortColumnIdx == columnIndex && !_sortOrderAsc) {
      setState(() {
        _sortOrderAsc = true;
        _sortColumnIdx = null;
      });
    } else {
      setState(() {
        _sortOrderAsc = asc;
        _sortColumnIdx = columnIndex;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)!.settings.arguments as int;
    return FutureBuilder<Playlist>(
        future: getPlaylist(id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final locale = Localizations.localeOf(context);
            final playlist = snapshot.data!;
            final lastUpdated = playlist.tracks
                ?.map((track) => track.added)
                .reduce((date, otherDate) =>
                    date.isAfter(otherDate) ? date : otherDate);
            final filteredTracks = [
              for (var track in playlist.tracks!)
                if (_checkTrack(track, _searchText)) track
            ];
            if (_sortColumnIdx != null) {
              switch (_sortColumnIdx) {
                case 0:
                  filteredTracks.sort(_sortOrderAsc
                      ? (a, b) => a.title.compareTo(b.title)
                      : (a, b) => b.title.compareTo(a.title));
                  break;
                case 1:
                  filteredTracks.sort(_sortOrderAsc
                      ? (a, b) => a.artist.name.compareTo(b.artist.name)
                      : (a, b) => b.artist.name.compareTo(a.artist.name));
                  break;
                case 2:
                  filteredTracks.sort(_sortOrderAsc
                      ? (a, b) => a.album!.title.compareTo(b.album!.title)
                      : (a, b) => b.album!.title.compareTo(a.album!.title));
                  break;
                case 3:
                  filteredTracks.sort(_sortOrderAsc
                      ? (a, b) => a.added.compareTo(b.added)
                      : (a, b) => b.added.compareTo(a.added));
                  break;
                case 4:
                  filteredTracks.sort(_sortOrderAsc
                      ? (a, b) => a.duration.compareTo(b.duration)
                      : (a, b) => b.duration.compareTo(a.duration));
                  break;
              }
            }
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
                    PopupMenuButton(
                        icon: const Icon(
                          Icons.more_horiz,
                        ),
                        itemBuilder: (innerContext) => [
                              PopupMenuItem(
                                child: ListTile(
                                    leading: const Icon(Icons.queue_play_next),
                                    title: Text(AppLocalizations.of(context)!
                                        .listenNext)),
                              ),
                              PopupMenuItem(
                                child: ListTile(
                                    leading: const Icon(Icons.add_to_queue),
                                    title: Text(AppLocalizations.of(context)!
                                        .addToQueue)),
                              ),
                              PopupMenuItem(
                                child: ListTile(
                                    leading: const Icon(Icons.share),
                                    title: Text(
                                        AppLocalizations.of(innerContext)!
                                            .share)),
                              ),
                              if (playlist.user != null ||
                                  playlist.creator != null)
                                PopupMenuItem(
                                  child: ListTile(
                                      leading: const Icon(Icons.people_outline),
                                      onTap: () {
                                        Navigator.pushNamed(context, '/user',
                                            arguments: playlist.user != null
                                                ? playlist.user!.id
                                                : playlist.creator!.id);
                                      },
                                      title: Text(AppLocalizations.of(context)!
                                          .userProfile)),
                                ),
                            ]),
                  ],
                ),
                body: SizedBox.expand(
                    child: Padding(
                        padding: const EdgeInsets.only(bottom: 100.0),
                        child: SingleChildScrollView(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                              FractionallySizedBox(
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
                              DataTable(
                                  onSelectAll: (bool? selected) {
                                    if (selected != null) {
                                      if (selected) {
                                        setState(() {
                                          _selectedRows = playlist.tracks!
                                              .where((track) => track.readable)
                                              .map((track) => track.id)
                                              .toSet();
                                        });
                                      } else {
                                        setState(() {
                                          _selectedRows = {};
                                        });
                                      }
                                    }
                                  },
                                  sortAscending: _sortOrderAsc,
                                  sortColumnIndex: _sortColumnIdx,
                                  columns: <DataColumn>[
                                    DataColumn(
                                      label: Expanded(
                                        child: Text(
                                          AppLocalizations.of(context)!.track,
                                        ),
                                      ),
                                      onSort: _onSort,
                                    ),
                                    DataColumn(
                                      label: Expanded(
                                        child: Text(
                                          AppLocalizations.of(context)!.artist,
                                        ),
                                      ),
                                      onSort: _onSort,
                                    ),
                                    DataColumn(
                                      label: Expanded(
                                        child: Text(
                                          AppLocalizations.of(context)!.album,
                                        ),
                                      ),
                                      onSort: _onSort,
                                    ),
                                    DataColumn(
                                      label: Text(
                                        AppLocalizations.of(context)!.added,
                                      ),
                                      onSort: _onSort,
                                    ),
                                    DataColumn(
                                      label: const Icon(
                                        Icons.access_time,
                                      ),
                                      onSort: _onSort,
                                      tooltip: AppLocalizations.of(context)!
                                          .duration,
                                    ),
                                  ],
                                  rows: [
                                    for (var track in filteredTracks)
                                      DataRow(
                                          onSelectChanged: track.readable
                                              ? (bool? selected) {
                                                  if (selected != null) {
                                                    if (selected) {
                                                      if (_selectedRows
                                                          .add(track.id)) {
                                                        setState(() {});
                                                      }
                                                    } else {
                                                      if (_selectedRows
                                                          .remove(track.id)) {
                                                        setState(() {});
                                                      }
                                                    }
                                                  }
                                                }
                                              : null,
                                          selected:
                                              _selectedRows.contains(track.id),
                                          cells: <DataCell>[
                                            DataCell(TrackCell(track: track)),
                                            DataCell(
                                                Tooltip(
                                                    message: track.artist.name,
                                                    child: ConstrainedBox(
                                                        constraints:
                                                            const BoxConstraints(
                                                                maxWidth:
                                                                    215.0),
                                                        child: Text(
                                                            track.artist.name,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis))),
                                                onTap: () {
                                              Navigator.pushNamed(
                                                  context, '/artist',
                                                  arguments: ArtistArguments(
                                                      track.artist.id));
                                            }),
                                            DataCell(
                                                Tooltip(
                                                    message: track.album!.title,
                                                    child: ConstrainedBox(
                                                        constraints:
                                                            const BoxConstraints(
                                                                maxWidth:
                                                                    215.0),
                                                        child: Text(
                                                            track.album!.title,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis))),
                                                onTap: () {
                                              Navigator.pushNamed(
                                                  context, '/album',
                                                  arguments: track.album!.id);
                                            }),
                                            DataCell(Text(DateFormat.yMd(
                                                    locale.toLanguageTag())
                                                .format(track.added))),
                                            DataCell(Text(formatDuration(
                                                track.duration))),
                                          ])
                                  ]),
                              if (filteredTracks.isEmpty)
                                Center(
                                    child: Text(AppLocalizations.of(context)!
                                        .nothingFound))
                            ])))),
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
