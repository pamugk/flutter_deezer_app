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

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool _completedSearch = false;
  late String _query;

  late Future<FullSearchResponse> _searchResponseFuture;

  late Future<PartialSearchResponse<playable.AlbumShort>> _albumsFuture;
  late Future<PartialSearchResponse<playable.Artist>> _artistsFuture;
  late Future<PartialSearchResponse<playable.Playlist>> _playlistsFuture;
  late Future<PartialSearchResponse<playable.Radio>> _radiosFuture;
  late Future<PartialSearchResponse<playable.TrackShort>> _tracksFuture;
  late Future<PartialSearchResponse<UserShort>> _usersFuture;

  @override
  Widget build(BuildContext context) {
    return _completedSearch
        ? FutureBuilder<FullSearchResponse>(
            future: _searchResponseFuture,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final overview = snapshot.data!;
                final tabs = [
                  if (overview.tracks.total > 0) 'Треки',
                  if (overview.albums.total > 0) 'Альбомы',
                  if (overview.artists.total > 0) 'Исполнители',
                  if (overview.playlists.total > 0) 'Плейлисты',
                  if (overview.radios.total > 0) 'Миксы',
                  if (overview.users.total > 0) 'Профили',
                ];
                return DefaultTabController(
                    length: 1 + tabs.length,
                    child: Scaffold(
                        appBar: AppBar(
                          title: Text('Результаты поиска по запросу "$_query"'),
                          bottom: TabBar(
                            tabs: <Widget>[
                              const Tab(
                                text: 'Все',
                              ),
                              ...[for (var tab in tabs) Tab(text: tab)]
                            ],
                          ),
                          actions: <Widget>[
                            IconButton(
                              icon: const Icon(Icons.search),
                              tooltip: 'Поиск',
                              onPressed: () {
                                setState(() {
                                  _completedSearch = false;
                                });
                              },
                            ),
                          ],
                        ),
                        body: TabBarView(
                          children: <Widget>[
                            tabs.isEmpty
                                ? const Center(
                                    child: Text('Ничего не найдено :('))
                                : SingleChildScrollView(
                                    child: Column(children: <Widget>[
                                    if (overview.tracks.total > 0) ...[
                                      const Text('Треки'),
                                      Table(
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
                                        children: snapshot.data!.tracks.data
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
                                      )
                                    ],
                                    if (overview.albums.total > 0) ...[
                                      const Text('Альбомы'),
                                      Wrap(
                                          spacing: 8.0,
                                          runSpacing: 4.0,
                                          children: snapshot.data!.albums.data
                                              .map((album) => AlbumCard(
                                                  album: album,
                                                  onTap: () {
                                                    Navigator.pushNamed(
                                                        context, '/album',
                                                        arguments: album.id);
                                                  }))
                                              .toList())
                                    ],
                                    if (overview.artists.total > 0) ...[
                                      const Text('Исполнители'),
                                      Wrap(
                                          spacing: 8.0,
                                          runSpacing: 4.0,
                                          children: snapshot.data!.artists.data
                                              .map((artist) => ArtistCard(
                                                  artist: artist,
                                                  onTap: () {
                                                    Navigator.pushNamed(
                                                        context, '/artists',
                                                        arguments: artist.id);
                                                  }))
                                              .toList())
                                    ],
                                    if (overview.playlists.total > 0) ...[
                                      const Text('Плейлисты'),
                                      Wrap(
                                          spacing: 8.0,
                                          runSpacing: 4.0,
                                          children: snapshot
                                              .data!.playlists.data
                                              .map((playlist) => PlaylistCard(
                                                  playlist: playlist,
                                                  onTap: () {
                                                    Navigator.pushNamed(
                                                        context, '/playlist',
                                                        arguments: playlist.id);
                                                  }))
                                              .toList())
                                    ],
                                    if (overview.radios.total > 0) ...[
                                      const Text('Миксы'),
                                      Wrap(
                                          spacing: 8.0,
                                          runSpacing: 4.0,
                                          children: snapshot.data!.radios.data
                                              .map((radio) => RadioCard(
                                                  radio: radio, onTap: () {}))
                                              .toList())
                                    ],
                                    if (overview.users.total > 0) ...[
                                      const Text('Пользователи'),
                                      Wrap(
                                          spacing: 8.0,
                                          runSpacing: 4.0,
                                          children: snapshot.data!.users.data
                                              .map((user) => UserCard(
                                                  user: user,
                                                  onTap: () {
                                                    Navigator.pushNamed(
                                                        context, '/user',
                                                        arguments: user.id);
                                                  }))
                                              .toList())
                                    ],
                                  ])),
                            if (overview.tracks.total > 0)
                              FutureBuilder<
                                      PartialSearchResponse<
                                          playable.TrackShort>>(
                                  future: _tracksFuture,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return SingleChildScrollView(
                                          child: Table(
                                              border: TableBorder.all(),
                                              columnWidths: const <int,
                                                  TableColumnWidth>{
                                                0: IntrinsicColumnWidth(),
                                                1: FixedColumnWidth(56),
                                                5: IntrinsicColumnWidth(),
                                                6: IntrinsicColumnWidth(),
                                              },
                                              defaultVerticalAlignment:
                                                  TableCellVerticalAlignment
                                                      .middle,
                                              children: [
                                                for (var track
                                                    in snapshot.data!.data)
                                                  TableRow(children: [
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
                                                  ])
                                              ]));
                                    } else if (snapshot.hasError) {
                                      return Text('${snapshot.error}');
                                    }
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  }),
                            if (overview.albums.total > 0)
                              FutureBuilder<
                                      PartialSearchResponse<
                                          playable.AlbumShort>>(
                                  future: _albumsFuture,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return SingleChildScrollView(
                                          child: Wrap(
                                              spacing: 8.0,
                                              runSpacing: 4.0,
                                              children: [
                                            for (var album
                                                in snapshot.data!.data)
                                              AlbumCard(
                                                  album: album,
                                                  onTap: () {
                                                    Navigator.pushNamed(
                                                        context, '/album',
                                                        arguments: album.id);
                                                  })
                                          ]));
                                    } else if (snapshot.hasError) {
                                      return Text('${snapshot.error}');
                                    }
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  }),
                            if (overview.artists.total > 0)
                              FutureBuilder<
                                      PartialSearchResponse<playable.Artist>>(
                                  future: _artistsFuture,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return SingleChildScrollView(
                                          child: Wrap(
                                              spacing: 8.0,
                                              runSpacing: 4.0,
                                              children: [
                                            for (var artist
                                                in snapshot.data!.data)
                                              ArtistCard(
                                                  artist: artist,
                                                  onTap: () {
                                                    Navigator.pushNamed(
                                                        context, '/artist',
                                                        arguments: artist.id);
                                                  })
                                          ]));
                                    } else if (snapshot.hasError) {
                                      return Text('${snapshot.error}');
                                    }
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  }),
                            if (overview.playlists.total > 0)
                              FutureBuilder<
                                      PartialSearchResponse<playable.Playlist>>(
                                  future: _playlistsFuture,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return SingleChildScrollView(
                                          child: Wrap(
                                              spacing: 8.0,
                                              runSpacing: 4.0,
                                              children: [
                                            for (var playlist
                                                in snapshot.data!.data)
                                              PlaylistCard(
                                                  playlist: playlist,
                                                  onTap: () {
                                                    Navigator.pushNamed(
                                                        context, '/playlist',
                                                        arguments: playlist.id);
                                                  })
                                          ]));
                                    } else if (snapshot.hasError) {
                                      return Text('${snapshot.error}');
                                    }
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  }),
                            if (overview.radios.total > 0)
                              FutureBuilder<
                                      PartialSearchResponse<playable.Radio>>(
                                  future: _radiosFuture,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return SingleChildScrollView(
                                          child: Wrap(
                                              spacing: 8.0,
                                              runSpacing: 4.0,
                                              children: [
                                            for (var radio
                                                in snapshot.data!.data)
                                              RadioCard(
                                                  radio: radio, onTap: () {})
                                          ]));
                                    } else if (snapshot.hasError) {
                                      return Text('${snapshot.error}');
                                    }
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  }),
                            if (overview.users.total > 0)
                              FutureBuilder<PartialSearchResponse<UserShort>>(
                                  future: _usersFuture,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return SingleChildScrollView(
                                          child: Wrap(
                                              spacing: 8.0,
                                              runSpacing: 4.0,
                                              children: [
                                            for (var user
                                                in snapshot.data!.data)
                                              UserCard(
                                                  user: user,
                                                  onTap: () {
                                                    Navigator.pushNamed(
                                                        context, '/user',
                                                        arguments: user.id);
                                                  })
                                          ]));
                                    } else if (snapshot.hasError) {
                                      return Text('${snapshot.error}');
                                    }
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  }),
                          ],
                        ),
                        drawer: const AppDrawer(),
                        bottomSheet: const Player()));
              } else if (snapshot.hasError) {
                return Scaffold(
                    appBar: AppBar(
                      title: const Text('Ошибка!'),
                      actions: const <Widget>[],
                    ),
                    body: Center(child: Text('${snapshot.error}')),
                    drawer: const AppDrawer(),
                    bottomSheet: const Player());
              }

              return Scaffold(
                  appBar: AppBar(
                    title: Text('Поиск по запросу "$_query"...'),
                    actions: const <Widget>[],
                  ),
                  body: const Center(child: CircularProgressIndicator()),
                  drawer: const AppDrawer(),
                  bottomSheet: const Player());
            })
        : Scaffold(
            appBar: AppBar(
              title: TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Трек, альбом, исполнитель...',
                  icon: Icon(Icons.search),
                ),
                onSubmitted: (query) {
                  if (query.trim().isNotEmpty) {
                    _searchResponseFuture = search(query);
                    _albumsFuture = searchAlbums(query);
                    _artistsFuture = searchArtists(query);
                    _playlistsFuture = searchPlaylists(query);
                    _radiosFuture = searchRadios(query);
                    _tracksFuture = searchTracks(query);
                    _usersFuture = searchUsers(query);
                    setState(() {
                      _query = query;
                      _completedSearch = true;
                    });
                  }
                },
                textInputAction: TextInputAction.search,
              ),
              actions: const <Widget>[],
            ),
            body: const Center(child: Text('Нечего предложить')),
            drawer: const AppDrawer(),
            bottomSheet: const Player());
  }
}
