import 'package:flutter/material.dart';

import '../models/playable.dart' as playable;
import '../models/search.dart';
import '../models/user.dart';
import '../providers/deezer.dart';
import '../utils/duration.dart';
import '../widgets/album_card.dart';
import '../widgets/artist_card.dart';
import '../widgets/drawer.dart';
import '../widgets/player.dart';
import '../widgets/playlist_card.dart';
import '../widgets/radio_card.dart';
import '../widgets/user_card.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  late Future<UserShort> _userFuture;

  late Future<PartialSearchResponse<playable.AlbumShort>> _userAlbumsFuture;
  late Future<PartialSearchResponse<playable.Artist>> _userArtistsFuture;
  late Future<PartialSearchResponse<UserShort>> _userFollowersFuture;
  late Future<FullSearchResponse> _userHighlightsFuture;
  late Future<PartialSearchResponse<playable.Playlist>> _userPlaylistsFuture;
  late Future<PartialSearchResponse<playable.Radio>> _userRadiosFuture;
  late Future<PartialSearchResponse<playable.TrackShort>> _userTracksFuture;

  @override
  void initState() {
    super.initState();
    _userFuture = getUser(4224801602);

    _userAlbumsFuture = getUserAlbums(4224801602);
    _userArtistsFuture = getUserArtists(4224801602);
    _userFollowersFuture = getUserFollowers(4224801602);
    _userHighlightsFuture = getUserHighlights(4224801602);
    _userPlaylistsFuture = getUserPlaylists(4224801602);
    _userRadiosFuture = getUserRadios(4224801602);
    _userTracksFuture = getUserTracks(4224801602);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserShort>(
        future: _userFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final entity = snapshot.data!;
            return DefaultTabController(
                length: 7,
                child: Scaffold(
                    appBar: AppBar(
                      title: Text(entity.name),
                      actions: <Widget>[
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
                          Tab(text: 'Обзор'),
                          Tab(text: 'Любимые треки'),
                          Tab(text: 'Плейлисты'),
                          Tab(text: 'Миксы'),
                          Tab(text: 'Альбомы'),
                          Tab(text: 'Исполнители'),
                          Tab(text: 'Последователи'),
                        ],
                      ),
                    ),
                    body: TabBarView(children: <Widget>[
                      FutureBuilder<FullSearchResponse>(
                          future: _userHighlightsFuture,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final highlights = snapshot.data!;
                              return SingleChildScrollView(
                                  child: Column(children: <Widget>[
                                const Text('Любимые треки'),
                                highlights.tracks.total == 0
                                    ? const Text('Ничего не найдено')
                                    : Table(
                                        border: TableBorder.all(),
                                        columnWidths: const <int,
                                            TableColumnWidth>{
                                          0: IntrinsicColumnWidth(),
                                          1: FixedColumnWidth(56),
                                          5: IntrinsicColumnWidth(),
                                          6: IntrinsicColumnWidth(),
                                        },
                                        defaultVerticalAlignment:
                                            TableCellVerticalAlignment.middle,
                                        children: highlights.tracks.data
                                            .map((track) => TableRow(children: [
                                                  const Text('1'),
                                                  Image.network(
                                                      track.album!.coverSmall,
                                                      height: 56.0,
                                                      width: 56.0),
                                                  Text(track.title),
                                                  Text(track.artist.name),
                                                  Text(track.album!.title),
                                                  Text(formatDuration(
                                                      track.duration)),
                                                  Text('${track.rank}'),
                                                ]))
                                            .toList(),
                                      ),
                                const Text('Плейлисты'),
                                highlights.playlists.total == 0
                                    ? const Text('Ничего не найдено')
                                    : Wrap(
                                        spacing: 8.0,
                                        runSpacing: 4.0,
                                        children: highlights.playlists.data
                                            .map((playlist) => PlaylistCard(
                                                playlist: playlist,
                                                onTap: () {
                                                  Navigator.pushNamed(
                                                      context, '/playlist',
                                                      arguments: playlist.id);
                                                }))
                                            .toList()),
                                const Text('Миксы'),
                                highlights.radios.total == 0
                                    ? const Text('Ничего не найдено')
                                    : Wrap(
                                        spacing: 8.0,
                                        runSpacing: 4.0,
                                        children: highlights.radios.data
                                            .map((radio) => RadioCard(
                                                radio: radio, onTap: () {}))
                                            .toList()),
                                const Text('Альбомы'),
                                highlights.albums.total == 0
                                    ? const Text('Ничего не найдено')
                                    : Wrap(
                                        spacing: 8.0,
                                        runSpacing: 4.0,
                                        children: highlights.albums.data
                                            .map((album) => AlbumCard(
                                                album: album,
                                                onTap: () {
                                                  Navigator.pushNamed(
                                                      context, '/album',
                                                      arguments: album.id);
                                                }))
                                            .toList()),
                                const Text('Исполнители'),
                                highlights.artists.total == 0
                                    ? const Text('Ничего не найдено')
                                    : Wrap(
                                        spacing: 8.0,
                                        runSpacing: 4.0,
                                        children: highlights.artists.data
                                            .map((artist) => ArtistCard(
                                                artist: artist,
                                                onTap: () {
                                                  Navigator.pushNamed(
                                                      context, '/artist',
                                                      arguments: artist.id);
                                                }))
                                            .toList()),
                                const Text('Последователи'),
                                highlights.users.total == 0
                                    ? const Text('Ничего не найдено')
                                    : Wrap(
                                        spacing: 8.0,
                                        runSpacing: 4.0,
                                        children: highlights.users.data
                                            .map((user) => UserCard(
                                                user: user,
                                                onTap: () {
                                                  Navigator.pushNamed(
                                                      context, '/user',
                                                      arguments: user.id);
                                                }))
                                            .toList()),
                              ]));
                            } else if (snapshot.hasError) {
                              return Text('${snapshot.error}');
                            }
                            return const Center(
                                child: CircularProgressIndicator());
                          }),
                      FutureBuilder<PartialSearchResponse<playable.TrackShort>>(
                          future: _userTracksFuture,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return SingleChildScrollView(
                                  child: Table(
                                border: TableBorder.all(),
                                columnWidths: const <int, TableColumnWidth>{
                                  0: IntrinsicColumnWidth(),
                                  1: FixedColumnWidth(56),
                                  5: IntrinsicColumnWidth(),
                                  6: IntrinsicColumnWidth(),
                                },
                                defaultVerticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                children: snapshot.data!.data
                                    .map((track) => TableRow(children: [
                                          const Text('1'),
                                          Image.network(track.album!.coverSmall,
                                              height: 56.0, width: 56.0),
                                          Text(track.title),
                                          Text(track.artist.name),
                                          Text(track.album!.title),
                                          Text(formatDuration(track.duration)),
                                          Text('${track.rank}'),
                                        ]))
                                    .toList(),
                              ));
                            } else if (snapshot.hasError) {
                              return Text('${snapshot.error}');
                            }
                            return const Center(
                                child: CircularProgressIndicator());
                          }),
                      FutureBuilder<PartialSearchResponse<playable.Playlist>>(
                          future: _userPlaylistsFuture,
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
                              return Text('${snapshot.error}');
                            }
                            return const Center(
                                child: CircularProgressIndicator());
                          }),
                      FutureBuilder<PartialSearchResponse<playable.Radio>>(
                          future: _userRadiosFuture,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return SingleChildScrollView(
                                  child: Wrap(
                                      spacing: 8.0,
                                      runSpacing: 4.0,
                                      children: snapshot.data!.data
                                          .map((radio) => RadioCard(
                                              radio: radio, onTap: () {}))
                                          .toList()));
                            } else if (snapshot.hasError) {
                              return Text('${snapshot.error}');
                            }
                            return const Center(
                                child: CircularProgressIndicator());
                          }),
                      FutureBuilder<PartialSearchResponse<playable.AlbumShort>>(
                          future: _userAlbumsFuture,
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
                              return Text('${snapshot.error}');
                            }
                            return const Center(
                                child: CircularProgressIndicator());
                          }),
                      FutureBuilder<PartialSearchResponse<playable.Artist>>(
                          future: _userArtistsFuture,
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
                                                    arguments: artist.id);
                                              }))
                                          .toList()));
                            } else if (snapshot.hasError) {
                              return Text('${snapshot.error}');
                            }
                            return const Center(
                                child: CircularProgressIndicator());
                          }),
                      FutureBuilder<PartialSearchResponse<UserShort>>(
                          future: _userFollowersFuture,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return SingleChildScrollView(
                                  child: Wrap(
                                      spacing: 8.0,
                                      runSpacing: 4.0,
                                      children: snapshot.data!.data
                                          .map((user) => UserCard(
                                              user: user,
                                              onTap: () {
                                                Navigator.pushNamed(
                                                    context, '/user',
                                                    arguments: user.id);
                                              }))
                                          .toList()));
                            } else if (snapshot.hasError) {
                              return Text('${snapshot.error}');
                            }
                            return const Center(
                                child: CircularProgressIndicator());
                          }),
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
