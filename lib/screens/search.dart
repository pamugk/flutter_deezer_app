import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/playable.dart';
import '../models/search.dart';
import '../models/user.dart';
import '../navigation/artist_arguments.dart';
import '../providers/deezer.dart';
import '../widgets/album_card.dart';
import '../widgets/artist_card.dart';
import '../widgets/data_grid.dart';
import '../widgets/drawer.dart';
import '../widgets/paginated_track_table.dart';
import '../widgets/player.dart';
import '../widgets/playlist_card.dart';
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

  @override
  Widget build(BuildContext context) {
    return _completedSearch
        ? FutureBuilder<FullSearchResponse>(
            future: _searchResponseFuture,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final overview = snapshot.data!;
                final tabs = [
                  if (overview.tracks.total > 0)
                    AppLocalizations.of(context)!.tracks,
                  if (overview.albums.total > 0)
                    AppLocalizations.of(context)!.albums,
                  if (overview.artists.total > 0)
                    AppLocalizations.of(context)!.artists,
                  if (overview.playlists.total > 0)
                    AppLocalizations.of(context)!.playlists,
                  if (overview.users.total > 0)
                    AppLocalizations.of(context)!.users,
                ];
                return DefaultTabController(
                    length: 1 + tabs.length,
                    child: Scaffold(
                        appBar: AppBar(
                          title: Text(AppLocalizations.of(context)!
                              .searchResult(_query)),
                          bottom: TabBar(
                            tabs: <Widget>[
                              Tab(
                                text: AppLocalizations.of(context)!.all,
                              ),
                              ...[for (var tab in tabs) Tab(text: tab)]
                            ],
                          ),
                          actions: <Widget>[
                            IconButton(
                              icon: const Icon(Icons.search),
                              tooltip: AppLocalizations.of(context)!.search,
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
                                    ? Center(
                                        child: Text(
                                            AppLocalizations.of(context)!
                                                .nothingFound))
                                    : SingleChildScrollView(
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                            if (overview.tracks.total > 0)
                                              TrackTable(
                                                title: Text(AppLocalizations.of(
                                                        context)!
                                                    .tracks),
                                                tracks: overview.tracks.data,
                                              ),
                                            if (overview.albums.total > 0)
                                              Section(
                                                  onNavigate: () {},
                                                  title: Text(
                                                      AppLocalizations.of(
                                                              context)!
                                                          .albums),
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
                                                  title: Text(
                                                      AppLocalizations.of(
                                                              context)!
                                                          .artists),
                                                  children: [
                                                    for (var artist in overview
                                                        .artists.data)
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
                                                  title: Text(
                                                      AppLocalizations.of(
                                                              context)!
                                                          .playlists),
                                                  children: [
                                                    for (var playlist
                                                        in overview
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
                                            if (overview.users.total > 0)
                                              Section(
                                                  onNavigate: () {},
                                                  title: Text(
                                                      AppLocalizations.of(
                                                              context)!
                                                          .users),
                                                  children: [
                                                    for (var user
                                                        in overview.users.data)
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
                                    loader: (page, pageSize) {
                                      return searchTracks(
                                          _query, page, pageSize);
                                    },
                                    titleBuilder: (total) {
                                      return Text(AppLocalizations.of(context)!
                                          .tracksCount(total));
                                    },
                                  )),
                                if (overview.albums.total > 0)
                                  DataGrid<AlbumShort>(
                                    itemBuilder: (itemContext, album) {
                                      return AlbumCard(
                                          album: album,
                                          onTap: () {
                                            Navigator.pushNamed(
                                                itemContext, '/album',
                                                arguments: album.id);
                                          });
                                    },
                                    loader: (page, pageSize) {
                                      return searchAlbums(
                                          _query, page, pageSize);
                                    },
                                    placeholder: Center(
                                        child: Text(
                                            AppLocalizations.of(context)!
                                                .nothingFound)),
                                    titleBuilder: (total) {
                                      return Text(AppLocalizations.of(context)!
                                          .albumsCount(total));
                                    },
                                  ),
                                if (overview.artists.total > 0)
                                  DataGrid<Artist>(
                                    itemBuilder: (itemContext, artist) {
                                      return ArtistCard(
                                          artist: artist,
                                          onTap: () {
                                            Navigator.pushNamed(
                                                itemContext, '/artist',
                                                arguments:
                                                    ArtistArguments(artist.id));
                                          });
                                    },
                                    loader: (page, pageSize) {
                                      return searchArtists(
                                          _query, page, pageSize);
                                    },
                                    placeholder: Center(
                                        child: Text(
                                            AppLocalizations.of(context)!
                                                .nothingFound)),
                                    titleBuilder: (total) {
                                      return Text(AppLocalizations.of(context)!
                                          .artistsCount(total));
                                    },
                                  ),
                                if (overview.playlists.total > 0)
                                  DataGrid<Playlist>(
                                    itemBuilder: (itemContext, playlist) {
                                      return PlaylistCard(
                                          playlist: playlist,
                                          onTap: () {
                                            Navigator.pushNamed(
                                                itemContext, '/playlist',
                                                arguments: playlist.id);
                                          });
                                    },
                                    loader: (page, pageSize) {
                                      return searchPlaylists(
                                          _query, page, pageSize);
                                    },
                                    placeholder: Center(
                                        child: Text(
                                            AppLocalizations.of(context)!
                                                .nothingFound)),
                                    titleBuilder: (total) {
                                      return Text(AppLocalizations.of(context)!
                                          .playlistsCount(total));
                                    },
                                  ),
                                if (overview.users.total > 0)
                                  DataGrid<UserShort>(
                                    itemBuilder: (itemContext, user) {
                                      return UserCard(
                                          user: user,
                                          onTap: () {
                                            Navigator.pushNamed(
                                                itemContext, '/user',
                                                arguments: user.id);
                                          });
                                    },
                                    loader: (page, pageSize) {
                                      return searchUsers(
                                          _query, page, pageSize);
                                    },
                                    placeholder: Center(
                                        child: Text(
                                            AppLocalizations.of(context)!
                                                .nothingFound)),
                                    titleBuilder: (total) {
                                      return Text(AppLocalizations.of(context)!
                                          .usersCount(total));
                                    },
                                  ),
                              ],
                            )),
                        drawer: const AppDrawer(),
                        bottomSheet: const Player()));
              } else if (snapshot.hasError) {
                return Scaffold(
                    appBar: AppBar(
                      title: Text(AppLocalizations.of(context)!.error),
                      actions: const <Widget>[],
                    ),
                    body: Center(child: Text('${snapshot.error}')),
                    drawer: const AppDrawer(),
                    bottomSheet: const Player());
              }

              return Scaffold(
                  appBar: AppBar(
                    title: Text(
                        AppLocalizations.of(context)!.searchProcessing(_query)),
                    actions: const <Widget>[],
                  ),
                  body: const Center(child: CircularProgressIndicator()),
                  drawer: const AppDrawer(),
                  bottomSheet: const Player());
            })
        : Scaffold(
            appBar: AppBar(
              title: TextField(
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: AppLocalizations.of(context)!.search,
                  icon: const Icon(Icons.search),
                ),
                onSubmitted: (query) {
                  if (query.trim().isNotEmpty) {
                    _searchResponseFuture = search(query);
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
            body: const Center(child: Text('')),
            drawer: const AppDrawer(),
            bottomSheet: const Player());
  }
}
