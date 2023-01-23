import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/playable.dart';
import '../models/search.dart';
import '../navigation/artist_arguments.dart';
import '../providers/deezer.dart';
import '../utils/duration.dart';
import '../widgets/album_card.dart';
import '../widgets/artist_card.dart';
import '../widgets/carousel.dart';
import '../widgets/drawer.dart';
import '../widgets/image_dialog.dart';
import '../widgets/player.dart';
import '../widgets/problem_dialog.dart';

class AlbumPage extends StatefulWidget {
  const AlbumPage({super.key});

  @override
  State<AlbumPage> createState() => _AlbumPageState();
}

class _AlbumPageState extends State<AlbumPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)!.settings.arguments as int;
    return FutureBuilder<Album>(
        future: getAlbum(id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final album = snapshot.data!;
            return Scaffold(
              key: _scaffoldKey,
              appBar: AppBar(
                  title: InkWell(
                      onTap: () {
                        _scaffoldKey.currentState!.openEndDrawer();
                      },
                      child: Row(children: [
                        Image.network(album.coverSmall,
                            height: 56.0, width: 56.0),
                        Text(album.title),
                        if (album.explicitLyrics)
                          const Icon(
                            Icons.explicit,
                          ),
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
                                    title: Text(
                                        AppLocalizations.of(innerContext)!
                                            .listenNext)),
                              ),
                              PopupMenuItem(
                                child: ListTile(
                                    leading: const Icon(Icons.add_to_queue),
                                    title: Text(
                                        AppLocalizations.of(innerContext)!
                                            .addToQueue)),
                              ),
                              PopupMenuItem(
                                child: ListTile(
                                    leading: const Icon(Icons.share),
                                    title: Text(
                                        AppLocalizations.of(innerContext)!
                                            .share)),
                              ),
                              PopupMenuItem(
                                child: ListTile(
                                    leading: const Icon(Icons.preview),
                                    onTap: () => showDialog<void>(
                                        context: innerContext,
                                        builder: (BuildContext context) =>
                                            imageDialogBuilder(context,
                                                album.coverXl!, album.title)),
                                    title: Text(
                                        AppLocalizations.of(innerContext)!
                                            .zoomCover)),
                              ),
                              PopupMenuItem(
                                  child: ListTile(
                                      leading: const Icon(Icons.report_problem),
                                      onTap: () => problemDialogBuilder(
                                          innerContext, _formKey),
                                      title: Text(
                                          AppLocalizations.of(innerContext)!
                                              .reportProblem))),
                            ]),
                  ]),
              body: SizedBox.expand(
                  child: Padding(
                      padding: const EdgeInsets.only(bottom: 100.0),
                      child: SingleChildScrollView(
                          child: Column(children: <Widget>[
                        Text(AppLocalizations.of(context)!
                            .tracksCount(album.trackCount)),
                        FutureBuilder<List<Track>>(
                            future: getAlbumTracks(id, 0, album.trackCount),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                final tracks =
                                    groupBy(snapshot.data!, (Track track) {
                                  return track.diskNumber;
                                });
                                return DataTable(
                                  columns: <DataColumn>[
                                    DataColumn(
                                      label: Expanded(
                                        child: Text(
                                          AppLocalizations.of(context)!.track,
                                        ),
                                      ),
                                    ),
                                    DataColumn(
                                      label: const Icon(
                                        Icons.access_time,
                                      ),
                                      tooltip: AppLocalizations.of(context)!
                                          .duration,
                                    ),
                                  ],
                                  rows: tracks.length == 1
                                      ? [
                                          for (var track in tracks[1]!)
                                            DataRow(
                                                onSelectChanged:
                                                    (bool? selected) {},
                                                cells: <DataCell>[
                                                  DataCell(Text(
                                                      '${track.position}. ${track.title}')),
                                                  DataCell(Text(formatDuration(
                                                      track.duration))),
                                                ])
                                        ]
                                      : [
                                          for (var disk in tracks.entries) ...[
                                            DataRow(cells: <DataCell>[
                                              DataCell(Text(
                                                  AppLocalizations.of(context)!
                                                      .cdNumber(disk.key))),
                                              const DataCell(Text('')),
                                            ]),
                                            ...[
                                              for (var track in disk.value)
                                                DataRow(
                                                    onSelectChanged:
                                                        (bool? selected) {},
                                                    cells: <DataCell>[
                                                      DataCell(Text(
                                                          '${track.position}. ${track.title}')),
                                                      DataCell(Text(
                                                          formatDuration(
                                                              track.duration))),
                                                    ])
                                            ]
                                          ]
                                        ],
                                );
                              } else if (snapshot.hasError) {
                                return Text('${snapshot.error}');
                              }
                              return const Center(
                                  child: CircularProgressIndicator());
                            }),
                        if (album.label != null) Text(album.label!),
                        FutureBuilder<PartialSearchResponse<AlbumShort>>(
                            future: getArtistAlbums(album.artist.id, 0, 10),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Carousel(
                                    title: Text(AppLocalizations.of(context)!
                                        .discography),
                                    onNavigate: () {
                                      Navigator.pushNamed(context, '/artist',
                                          arguments:
                                              ArtistArguments(album.artist.id));
                                    },
                                    children: [
                                      for (var album in snapshot.data!.data)
                                        AlbumCard(
                                            album: album,
                                            onTap: () {
                                              Navigator.pushNamed(
                                                  context, '/album',
                                                  arguments: album.id);
                                            })
                                    ]);
                              } else if (snapshot.hasError) {
                                return Text('${snapshot.error}');
                              }
                              return const Center(
                                  child: CircularProgressIndicator());
                            }),
                        FutureBuilder<PartialSearchResponse<Artist>>(
                            future: getArtistRelated(album.artist.id, 0, 10),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Carousel(
                                    title: Text(AppLocalizations.of(context)!
                                        .similarArtists),
                                    onNavigate: () {
                                      Navigator.pushNamed(context, '/artist',
                                          arguments: ArtistArguments(
                                              album.artist.id, 2));
                                    },
                                    children: [
                                      for (var artist in snapshot.data!.data)
                                        ArtistCard(
                                            artist: artist,
                                            onTap: () {
                                              Navigator.pushNamed(
                                                  context, '/artist',
                                                  arguments: ArtistArguments(
                                                      artist.id));
                                            })
                                    ]);
                              } else if (snapshot.hasError) {
                                return Text('${snapshot.error}');
                              }
                              return const Center(
                                  child: CircularProgressIndicator());
                            }),
                      ])))),
              drawer: const AppDrawer(),
              endDrawer: Drawer(
                  child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(album.coverMedium,
                        height: 250.0, width: 250.0),
                    Text(AppLocalizations.of(context)!
                        .durationValue(formatDuration(album.duration))),
                    Text(AppLocalizations.of(context)!
                        .releaseDate(album.releaseDate)),
                    Text(AppLocalizations.of(context)!
                        .fansCount(album.fanCount)),
                    Row(children: [
                      CircleAvatar(
                        backgroundImage:
                            NetworkImage(album.artist.pictureSmall),
                      ),
                      Text(album.artist.name),
                    ]),
                  ],
                ),
              )),
              bottomSheet: const Player(),
            );
          } else if (snapshot.hasError) {
            return Scaffold(
                appBar:
                    AppBar(title: Text(AppLocalizations.of(context)!.error)),
                body: Center(child: Text('${snapshot.error}')));
          }
          return Scaffold(
              appBar:
                  AppBar(title: Text(AppLocalizations.of(context)!.loading)),
              body: const Center(child: CircularProgressIndicator()),
              drawer: const AppDrawer(),
              bottomSheet: const Player());
        });
  }
}
