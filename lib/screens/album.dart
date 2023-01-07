import 'package:flutter/material.dart';

import '../models/playable.dart';
import '../models/search.dart';
import '../providers/deezer.dart';
import '../utils/duration.dart';
import '../widgets/album_card.dart';
import '../widgets/artist_card.dart';
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
  void initState() {
    super.initState();
    _albumFuture = getAlbum(94352652);
    _albumFuture.then((Album album) {
      _discographyFuture = getArtistAlbums(album.artist.id, 0, 10);
      _relatedArtistsFuture = getArtistRelated(album.artist.id, 0, 10);
    });
    _tracksFuture = getAlbumTracks(94352652);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Альбом"), actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.search),
          tooltip: 'Поиск',
          onPressed: () {
            Navigator.pushNamed(context, '/search');
          },
        ),
      ]),
      body: FutureBuilder<Album>(
          future: _albumFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var album = snapshot.data!;
              return SingleChildScrollView(
                  child: Column(children: <Widget>[
                Row(children: <Widget>[
                  Image.network(album.coverMedium, height: 250.0, width: 250.0),
                  Column(children: <Widget>[
                    Text(album.title),
                    Text(album.artist.name),
                    Row(children: <Widget>[
                      Text('${album.releaseDate}'),
                      Text(formatDuration(album.duration)),
                      Text('${album.rating ?? 0}'),
                      Text('${album.fanCount}'),
                    ]),
                  ]),
                ]),
                const Text('Треки'),
                FutureBuilder<List<Track>>(
                    future: _tracksFuture,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Table(
                          border: TableBorder.all(),
                          columnWidths: const <int, TableColumnWidth>{
                            0: IntrinsicColumnWidth(),
                            2: IntrinsicColumnWidth(),
                            3: IntrinsicColumnWidth(),
                          },
                          defaultVerticalAlignment:
                              TableCellVerticalAlignment.middle,
                          children: snapshot.data!
                              .map((track) => TableRow(children: [
                                    Text('${track.position}'),
                                    Text(track.title),
                                    Text(formatDuration(track.duration)),
                                    Text('${track.rank}'),
                                  ]))
                              .toList(),
                        );
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      }
                      return const Center(child: CircularProgressIndicator());
                    }),
                const Text('Дискография'),
                FutureBuilder<PartialSearchResponse<AlbumShort>>(
                    future: _discographyFuture,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Wrap(
                            spacing: 8.0,
                            runSpacing: 4.0,
                            children: snapshot.data!.data
                                .map((album) => AlbumCard(
                                    album: album,
                                    onTap: () {
                                      Navigator.pushNamed(context, '/album',
                                          arguments: album.id);
                                    }))
                                .toList());
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      }
                      return const Center(child: CircularProgressIndicator());
                    }),
                const Text('Похожие исполнители'),
                FutureBuilder<PartialSearchResponse<Artist>>(
                    future: _relatedArtistsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Wrap(
                            spacing: 8.0,
                            runSpacing: 4.0,
                            children: snapshot.data!.data
                                .map((artist) => ArtistCard(
                                    artist: artist,
                                    onTap: () {
                                      Navigator.pushNamed(context, '/artist',
                                          arguments: artist.id);
                                    }))
                                .toList());
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      }
                      return const Center(child: CircularProgressIndicator());
                    }),
              ]));
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return const Center(child: CircularProgressIndicator());
          }),
      drawer: const AppDrawer(),
      bottomSheet: const Player(),
    );
  }
}
