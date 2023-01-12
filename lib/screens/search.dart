import 'package:flutter/material.dart';

import '../models/playable.dart' as playable;
import '../models/search.dart';
import '../models/user.dart';
import '../navigation/artist_arguments.dart';
import '../providers/deezer.dart';
import '../widgets/album_card.dart';
import '../widgets/artist_card.dart';
import '../widgets/drawer.dart';
import '../widgets/paginated_track_table.dart';
import '../widgets/player.dart';
import '../widgets/playlist_card.dart';
import '../widgets/radio_card.dart';
import '../widgets/section.dart';
import '../widgets/track_table.dart';
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
                        body: Padding(
                            padding: const EdgeInsets.only(bottom: 100.0),
                            child: TabBarView(
                              children: <Widget>[
                                tabs.isEmpty
                                    ? const Center(
                                        child: Text('Ничего не найдено :('))
                                    : SingleChildScrollView(
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                            if (overview.tracks.total > 0)
                                              TrackTable(
                                                title: const Text('Треки'),
                                                tracks:
                                                    snapshot.data!.tracks.data,
                                              ),
                                            if (overview.albums.total > 0)
                                              Section(
                                                  onNavigate: () {},
                                                  title: const Text('Альбомы'),
                                                  children: [
                                                    for (var album in snapshot
                                                        .data!.albums.data)
                                                      AlbumCard(
                                                          album: album,
                                                          onTap: () {
                                                            Navigator.pushNamed(
                                                                context,
                                                                '/album',
                                                                arguments:
                                                                    album.id);
                                                          })
                                                  ]),
                                            if (overview.artists.total > 0)
                                              Section(
                                                  onNavigate: () {},
                                                  title:
                                                      const Text('Исполнители'),
                                                  children: [
                                                    for (var artist in snapshot
                                                        .data!.artists.data)
                                                      ArtistCard(
                                                          artist: artist,
                                                          onTap: () {
                                                            Navigator.pushNamed(
                                                                context,
                                                                '/artist',
                                                                arguments:
                                                                    ArtistArguments(
                                                                        artist
                                                                            .id));
                                                          })
                                                  ]),
                                            if (overview.playlists.total > 0)
                                              Section(
                                                  onNavigate: () {},
                                                  title:
                                                      const Text('Плейлисты'),
                                                  children: [
                                                    for (var playlist
                                                        in snapshot.data!
                                                            .playlists.data)
                                                      PlaylistCard(
                                                          playlist: playlist,
                                                          onTap: () {
                                                            Navigator.pushNamed(
                                                                context,
                                                                '/playlist',
                                                                arguments:
                                                                    playlist
                                                                        .id);
                                                          })
                                                  ]),
                                            if (overview.radios.total > 0)
                                              Section(
                                                  onNavigate: () {},
                                                  title: const Text('Миксы'),
                                                  children: [
                                                    for (var radio in snapshot
                                                        .data!.radios.data)
                                                      RadioCard(
                                                          radio: radio,
                                                          onTap: () {})
                                                  ]),
                                            if (overview.users.total > 0)
                                              Section(
                                                  onNavigate: () {},
                                                  title: const Text(
                                                      'Пользователи'),
                                                  children: [
                                                    for (var user in snapshot
                                                        .data!.users.data)
                                                      UserCard(
                                                          user: user,
                                                          onTap: () {
                                                            Navigator.pushNamed(
                                                                context,
                                                                '/user',
                                                                arguments:
                                                                    user.id);
                                                          })
                                                  ]),
                                          ])),
                                if (overview.tracks.total > 0)
                                  SingleChildScrollView(
                                      child: PaginatedTrackTable(
                                    loader: (int page, int pageSize) {
                                      return searchTracks(
                                          _query, page, pageSize);
                                    },
                                    titleBuilder: (int trackCount) {
                                      return Text('Треков: $trackCount');
                                    },
                                  )),
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
                                                            arguments:
                                                                album.id);
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
                                          PartialSearchResponse<
                                              playable.Artist>>(
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
                                                            arguments:
                                                                ArtistArguments(
                                                                    artist.id));
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
                                          PartialSearchResponse<
                                              playable.Playlist>>(
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
                                                            context,
                                                            '/playlist',
                                                            arguments:
                                                                playlist.id);
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
                                          PartialSearchResponse<
                                              playable.Radio>>(
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
                                                      radio: radio,
                                                      onTap: () {})
                                              ]));
                                        } else if (snapshot.hasError) {
                                          return Text('${snapshot.error}');
                                        }
                                        return const Center(
                                            child: CircularProgressIndicator());
                                      }),
                                if (overview.users.total > 0)
                                  FutureBuilder<
                                          PartialSearchResponse<UserShort>>(
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
                            )),
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
