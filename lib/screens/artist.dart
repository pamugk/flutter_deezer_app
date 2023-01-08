import 'package:flutter/material.dart';

import '../models/playable.dart';
import '../models/search.dart';
import '../navigation/artist_arguments.dart';
import '../providers/deezer.dart';
import '../utils/duration.dart';
import '../widgets/album_card.dart';
import '../widgets/artist_card.dart';
import '../widgets/drawer.dart';
import '../widgets/player.dart';
import '../widgets/playlist_card.dart';

class ArtistPage extends StatefulWidget {
  const ArtistPage({super.key});

  @override
  State<ArtistPage> createState() => _ArtistPageState();
}

class _ArtistPageState extends State<ArtistPage> {
  late Future<Artist> _artistFuture;
  late Future<PartialSearchResponse<AlbumShort>> _discographyFuture;
  late Future<PartialSearchResponse<Playlist>> _playlistsFuture;
  late Future<PartialSearchResponse<TrackShort>> _popularTracksFuture;
  late Future<PartialSearchResponse<Artist>> _relatedArtistsFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final arguments =
        ModalRoute.of(context)!.settings.arguments as ArtistArguments;
    _artistFuture = getArtist(arguments.id);
    _discographyFuture = getArtistAlbums(arguments.id);
    _playlistsFuture = getArtistPlaylists(arguments.id);
    _popularTracksFuture = getArtistTopTracks(arguments.id);
    _relatedArtistsFuture = getArtistRelated(arguments.id);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Artist>(
        future: _artistFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final artist = snapshot.data!;
            final arguments =
                ModalRoute.of(context)!.settings.arguments as ArtistArguments;
            return DefaultTabController(
                initialIndex: arguments.section,
                length: 5,
                child: Scaffold(
                    appBar: AppBar(
                      title: Text(artist.name),
                      actions: <Widget>[
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
                      ],
                      bottom: const TabBar(
                        tabs: <Widget>[
                          Tab(text: 'Дискография'),
                          Tab(text: 'Популярные треки'),
                          Tab(text: 'Похожие исполнители'),
                          Tab(text: 'Плейлисты'),
                          Tab(text: 'Комментарии'),
                        ],
                      ),
                    ),
                    body: TabBarView(children: <Widget>[
                      FutureBuilder<PartialSearchResponse<AlbumShort>>(
                          future: _discographyFuture,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return SingleChildScrollView(
                                  child: Wrap(
                                      spacing: 8.0,
                                      runSpacing: 4.0,
                                      children: snapshot.data!.data
                                          .map((album) => AlbumCard(
                                              album: album,
                                              onTap: () {
                                                Navigator.pushNamed(
                                                    context, '/album',
                                                    arguments: album.id);
                                              }))
                                          .toList()));
                            } else if (snapshot.hasError) {
                              return Center(child: Text('${snapshot.error}'));
                            }
                            return const Center(
                                child: CircularProgressIndicator());
                          }),
                      FutureBuilder<PartialSearchResponse<TrackShort>>(
                          future: _popularTracksFuture,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Table(
                                border: TableBorder.all(),
                                columnWidths: const <int, TableColumnWidth>{
                                  0: IntrinsicColumnWidth(),
                                  3: IntrinsicColumnWidth(),
                                  4: IntrinsicColumnWidth(),
                                },
                                defaultVerticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                children: snapshot.data!.data
                                    .map((track) => TableRow(children: [
                                          const Text('0'),
                                          Text(track.title),
                                          Text(track.album!.title),
                                          Text(formatDuration(track.duration)),
                                          Text('${track.rank}'),
                                        ]))
                                    .toList(),
                              );
                            } else if (snapshot.hasError) {
                              return Center(child: Text('${snapshot.error}'));
                            }
                            return const Center(
                                child: CircularProgressIndicator());
                          }),
                      FutureBuilder<PartialSearchResponse<Artist>>(
                          future: _relatedArtistsFuture,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return SingleChildScrollView(
                                  child: Wrap(
                                      spacing: 8.0,
                                      runSpacing: 4.0,
                                      children: snapshot.data!.data
                                          .map((artist) => ArtistCard(
                                              artist: artist,
                                              onTap: () {
                                                Navigator.pushNamed(
                                                    context, '/artist',
                                                    arguments: ArtistArguments(
                                                        artist.id));
                                              }))
                                          .toList()));
                            } else if (snapshot.hasError) {
                              return Center(child: Text('${snapshot.error}'));
                            }
                            return const Center(
                                child: CircularProgressIndicator());
                          }),
                      FutureBuilder<PartialSearchResponse<Playlist>>(
                          future: _playlistsFuture,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return SingleChildScrollView(
                                  child: Wrap(
                                      spacing: 8.0,
                                      runSpacing: 4.0,
                                      children: snapshot.data!.data
                                          .map((playlist) => PlaylistCard(
                                              playlist: playlist,
                                              onTap: () {
                                                Navigator.pushNamed(
                                                    context, '/playlist',
                                                    arguments: playlist.id);
                                              }))
                                          .toList()));
                            } else if (snapshot.hasError) {
                              return Center(child: Text('${snapshot.error}'));
                            }
                            return const Center(
                                child: CircularProgressIndicator());
                          }),
                      const Center(child: Text('Тут комментарии')),
                    ]),
                    drawer: const AppDrawer(),
                    bottomSheet: const Player()));
          }
          return snapshot.hasError
              ? Scaffold(
                  appBar: AppBar(title: const Text("Ошибка!")),
                  body: Center(child: Text('${snapshot.error}')),
                  drawer: const AppDrawer(),
                  bottomSheet: const Player())
              : Scaffold(
                  appBar: AppBar(title: const Text("Идёт загрузка...")),
                  body: const Center(child: CircularProgressIndicator()),
                  drawer: const AppDrawer(),
                  bottomSheet: const Player());
        });
  }
}
