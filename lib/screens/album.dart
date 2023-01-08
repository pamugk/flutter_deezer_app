import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../models/playable.dart';
import '../models/search.dart';
import '../navigation/artist_arguments.dart';
import '../providers/deezer.dart';
import '../utils/duration.dart';
import '../widgets/album_card.dart';
import '../widgets/artist_card.dart';
import '../widgets/carousel.dart';
import '../widgets/drawer.dart';
import '../widgets/player.dart';

class AlbumPage extends StatefulWidget {
  const AlbumPage({super.key});

  @override
  State<AlbumPage> createState() => _AlbumPageState();
}

class _AlbumPageState extends State<AlbumPage> with TickerProviderStateMixin {
  late Future<Album> _albumFuture;
  late Future<PartialSearchResponse<AlbumShort>> _discographyFuture;
  late Future<PartialSearchResponse<Artist>> _relatedArtistsFuture;
  late Future<List<Track>> _tracksFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final id = ModalRoute.of(context)!.settings.arguments as int;
    _albumFuture = getAlbum(id);
    _albumFuture.then((Album album) {
      _tracksFuture = getAlbumTracks(id, 0, album.trackCount);
      _discographyFuture = getArtistAlbums(album.artist.id, 0, 10);
      _relatedArtistsFuture = getArtistRelated(album.artist.id, 0, 10);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Album>(
        future: _albumFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final album = snapshot.data!;
            return Scaffold(
              appBar: AppBar(title: Text(album.title), actions: <Widget>[
                IconButton(
                    icon: const Icon(Icons.play_circle),
                    tooltip: 'Воспроизвести',
                    onPressed: () {}),
                const IconButton(
                    icon: Icon(Icons.favorite_border),
                    tooltip: 'Добавить в избранное',
                    onPressed: null),
                IconButton(
                  icon: const Icon(Icons.search),
                  tooltip: 'Поиск',
                  onPressed: () {
                    Navigator.pushNamed(context, '/search');
                  },
                ),
              ]),
              body: SingleChildScrollView(
                  child: Column(children: <Widget>[
                Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Image.network(album.coverMedium,
                          height: 250.0, width: 250.0),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            if (album.explicitLyrics) const Text('EXPLICIT'),
                            Row(children: [
                              CircleAvatar(
                                backgroundImage:
                                    NetworkImage(album.artist.pictureSmall),
                              ),
                              Text(album.artist.name),
                            ]),
                            Row(children: <Widget>[
                              Text('треков: ${album.trackCount}'),
                              Text(formatDuration(album.duration)),
                              Text('${album.releaseDate}'),
                              Text('фанатов: ${album.fanCount}'),
                            ]),
                          ]),
                    ]),
                FutureBuilder<List<Track>>(
                    future: _tracksFuture,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final tracks = groupBy(snapshot.data!, (Track track) {
                          return track.diskNumber;
                        });
                        return DataTable(
                          columns: const <DataColumn>[
                            DataColumn(
                              label: Expanded(
                                child: Text(
                                  'Трек',
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Icon(
                                Icons.access_time,
                              ),
                              tooltip: 'Длительность',
                            ),
                          ],
                          rows: tracks.length == 1
                              ? [
                                  for (var track in tracks[1]!)
                                    DataRow(
                                        onSelectChanged: (bool? selected) {},
                                        cells: <DataCell>[
                                          DataCell(Text(
                                              '${track.position}. ${track.title}')),
                                          DataCell(Text(
                                              formatDuration(track.duration))),
                                        ])
                                ]
                              : [
                                  for (var disk in tracks.entries) ...[
                                    DataRow(cells: <DataCell>[
                                      DataCell(Text('CD №${disk.key}')),
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
                                              DataCell(Text(formatDuration(
                                                  track.duration))),
                                            ])
                                    ]
                                  ]
                                ],
                        );
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      }
                      return const Center(child: CircularProgressIndicator());
                    }),
                if (album.label != null) Text(album.label!),
                FutureBuilder<PartialSearchResponse<AlbumShort>>(
                    future: _discographyFuture,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Carousel(
                            spacing: 24.0,
                            title: const Text('Дискография'),
                            onNavigate: () {
                              Navigator.pushNamed(context, '/artist',
                                  arguments: ArtistArguments(album.artist.id));
                            },
                            children: [
                              for (var album in snapshot.data!.data)
                                AlbumCard(
                                    album: album,
                                    onTap: () {
                                      Navigator.pushNamed(context, '/album',
                                          arguments: album.id);
                                    })
                            ]);
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      }
                      return const Center(child: CircularProgressIndicator());
                    }),
                FutureBuilder<PartialSearchResponse<Artist>>(
                    future: _relatedArtistsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Carousel(
                            spacing: 24.0,
                            title: const Text('Похожие исполнители'),
                            onNavigate: () {
                              Navigator.pushNamed(context, '/artist',
                                  arguments:
                                      ArtistArguments(album.artist.id, 2));
                            },
                            children: [
                              for (var artist in snapshot.data!.data)
                                ArtistCard(
                                    artist: artist,
                                    onTap: () {
                                      Navigator.pushNamed(context, '/artist',
                                          arguments:
                                              ArtistArguments(artist.id));
                                    })
                            ]);
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      }
                      return const Center(child: CircularProgressIndicator());
                    }),
              ])),
              drawer: const AppDrawer(),
              bottomSheet: const Player(),
            );
          } else if (snapshot.hasError) {
            return Scaffold(
                appBar: AppBar(title: const Text('Ошибка!')),
                body: Center(child: Text('${snapshot.error}')));
          }
          return Scaffold(
              appBar: AppBar(title: const Text("Идёт загрузка...")),
              body: const Center(child: CircularProgressIndicator()),
              drawer: const AppDrawer(),
              bottomSheet: const Player());
        });
  }
}
