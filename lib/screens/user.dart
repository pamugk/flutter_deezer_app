import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/playable.dart';
import '../models/search.dart';
import '../models/user.dart';
import '../navigation/artist_arguments.dart';
import '../providers/deezer.dart';
import '../widgets/album_card.dart';
import '../widgets/artist_card.dart';
import '../widgets/carousel.dart';
import '../widgets/data_grid.dart';
import '../widgets/drawer.dart';
import '../widgets/paginated_track_table.dart';
import '../widgets/player.dart';
import '../widgets/playlist_card.dart';
import '../widgets/track_columns.dart';
import '../widgets/track_table.dart';
import '../widgets/user_card.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 7);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)!.settings.arguments as int;
    return FutureBuilder<UserShort>(
        future: getUser(id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final entity = snapshot.data!;
            return Scaffold(
                key: _scaffoldKey,
                appBar: AppBar(
                  title: InkWell(
                      onTap: () {
                        _scaffoldKey.currentState!.openEndDrawer();
                      },
                      child: Row(children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(entity.pictureSmall!),
                        ),
                        Text(entity.name),
                      ])),
                  actions: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.search),
                      tooltip: AppLocalizations.of(context)!.search,
                      onPressed: () {
                        Navigator.pushNamed(context, '/search');
                      },
                    ),
                  ],
                  bottom: TabBar(
                    controller: _tabController,
                    tabs: <Widget>[
                      Tab(text: AppLocalizations.of(context)!.highlights),
                      Tab(text: AppLocalizations.of(context)!.favoriteTracks),
                      Tab(text: AppLocalizations.of(context)!.playlists),
                      Tab(text: AppLocalizations.of(context)!.albums),
                      Tab(text: AppLocalizations.of(context)!.artists),
                      Tab(text: AppLocalizations.of(context)!.followings),
                      Tab(text: AppLocalizations.of(context)!.followers),
                    ],
                  ),
                ),
                body: Padding(
                    padding: const EdgeInsets.only(bottom: 100.0),
                    child: TabBarView(controller: _tabController, children: <
                        Widget>[
                      FutureBuilder<UserHighlights>(
                          future: getUserHighlights(id),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final highlights = snapshot.data!;
                              return SingleChildScrollView(
                                  child: Column(children: <Widget>[
                                if (highlights.tracks.total > 0)
                                  TrackTable(
                                    columns: const {
                                      TrackColumn.track,
                                      TrackColumn.artist,
                                      TrackColumn.album,
                                      TrackColumn.duration
                                    },
                                    title: Row(children: <Widget>[
                                      Text(AppLocalizations.of(context)!
                                          .favoriteTracks),
                                      IconButton(
                                        icon: const Icon(Icons.navigate_next),
                                        tooltip: AppLocalizations.of(context)!
                                            .navigate,
                                        onPressed: () {
                                          _tabController.animateTo(1);
                                        },
                                      ),
                                    ]),
                                    tracks: highlights.tracks.data,
                                  ),
                                if (highlights.playlists.total > 0)
                                  Carousel(
                                      onNavigate: () {
                                        _tabController.animateTo(2);
                                      },
                                      title: Text(AppLocalizations.of(context)!
                                          .playlists),
                                      children: [
                                        for (var playlist
                                            in highlights.playlists.data)
                                          PlaylistCard(
                                              playlist: playlist,
                                              onTap: () {
                                                Navigator.pushNamed(
                                                    context, '/playlist',
                                                    arguments: playlist.id);
                                              })
                                      ]),
                                if (highlights.albums.total > 0)
                                  Carousel(
                                      onNavigate: () {
                                        _tabController.animateTo(4);
                                      },
                                      title: Text(
                                          AppLocalizations.of(context)!.albums),
                                      children: [
                                        for (var album
                                            in highlights.albums.data)
                                          AlbumCard(
                                              album: album,
                                              onTap: () {
                                                Navigator.pushNamed(
                                                    context, '/album',
                                                    arguments: album.id);
                                              })
                                      ]),
                                if (highlights.artists.total > 0)
                                  Carousel(
                                      onNavigate: () {
                                        _tabController.animateTo(5);
                                      },
                                      title: Text(AppLocalizations.of(context)!
                                          .artists),
                                      children: [
                                        for (var artist
                                            in highlights.artists.data)
                                          ArtistCard(
                                              artist: artist,
                                              onTap: () {
                                                Navigator.pushNamed(
                                                    context, '/artist',
                                                    arguments: ArtistArguments(
                                                        artist.id));
                                              })
                                      ]),
                                if (highlights.followings.total > 0)
                                  Carousel(
                                      onNavigate: () {
                                        _tabController.animateTo(6);
                                      },
                                      title: Text(AppLocalizations.of(context)!
                                          .followings),
                                      children: [
                                        for (var user
                                            in highlights.followings.data)
                                          UserCard(
                                              user: user,
                                              onTap: () {
                                                Navigator.pushNamed(
                                                    context, '/user',
                                                    arguments: user.id);
                                              })
                                      ]),
                                if (highlights.followers.total > 0)
                                  Carousel(
                                      onNavigate: () {
                                        _tabController.animateTo(7);
                                      },
                                      title: Text(AppLocalizations.of(context)!
                                          .followers),
                                      children: [
                                        for (var user
                                            in highlights.followers.data)
                                          UserCard(
                                              user: user,
                                              onTap: () {
                                                Navigator.pushNamed(
                                                    context, '/user',
                                                    arguments: user.id);
                                              })
                                      ]),
                              ]));
                            } else if (snapshot.hasError) {
                              return Text('${snapshot.error}');
                            }
                            return const Center(
                                child: CircularProgressIndicator());
                          }),
                      SingleChildScrollView(
                          child: PaginatedTrackTable(
                        columns: const {
                          TrackColumn.track,
                          TrackColumn.artist,
                          TrackColumn.album,
                          TrackColumn.duration
                        },
                        loader: (int page, int pageSize) {
                          return getUserTracks(id, page, pageSize);
                        },
                        titleBuilder: (int trackCount) {
                          return Text(AppLocalizations.of(context)!
                              .tracksCount(trackCount));
                        },
                      )),
                      DataGrid<Playlist>(
                        itemBuilder: (itemContext, playlist) {
                          return PlaylistCard(
                              playlist: playlist,
                              onTap: () {
                                Navigator.pushNamed(itemContext, '/playlist',
                                    arguments: playlist.id);
                              });
                        },
                        loader: (page, pageSize) {
                          return getUserPlaylists(id, page, pageSize);
                        },
                        placeholder: Center(
                            child: Text(
                                AppLocalizations.of(context)!.noPlaylists)),
                        titleBuilder: (total) {
                          return Text(AppLocalizations.of(context)!
                              .playlistsCount(total));
                        },
                      ),
                      DataGrid<AlbumShort>(
                        itemBuilder: (itemContext, album) {
                          return AlbumCard(
                              album: album,
                              onTap: () {
                                Navigator.pushNamed(itemContext, '/album',
                                    arguments: album.id);
                              });
                        },
                        loader: (page, pageSize) {
                          return getUserAlbums(id, page, pageSize);
                        },
                        placeholder: Center(
                            child: Text(AppLocalizations.of(context)!
                                .noFavoriteAlbums)),
                        titleBuilder: (total) {
                          return Text(
                              AppLocalizations.of(context)!.albumsCount(total));
                        },
                      ),
                      DataGrid<Artist>(
                        itemBuilder: (itemContext, artist) {
                          return ArtistCard(
                              artist: artist,
                              onTap: () {
                                Navigator.pushNamed(itemContext, '/artist',
                                    arguments: ArtistArguments(artist.id));
                              });
                        },
                        loader: (page, pageSize) {
                          return getUserArtists(id, page, pageSize);
                        },
                        placeholder: Center(
                            child: Text(AppLocalizations.of(context)!
                                .noFavoriteArtists)),
                        titleBuilder: (total) {
                          return Text(AppLocalizations.of(context)!
                              .artistsCount(total));
                        },
                      ),
                      DataGrid<UserShort>(
                        itemBuilder: (itemContext, user) {
                          return UserCard(
                              user: user,
                              onTap: () {
                                Navigator.pushNamed(itemContext, '/user',
                                    arguments: user.id);
                              });
                        },
                        loader: (page, pageSize) {
                          return getUserFollowings(id, page, pageSize);
                        },
                        placeholder: Center(
                            child: Text(
                                AppLocalizations.of(context)!.noFollowings)),
                        titleBuilder: (total) {
                          return Text(AppLocalizations.of(context)!
                              .followingsCount(total));
                        },
                      ),
                      DataGrid<UserShort>(
                        itemBuilder: (itemContext, user) {
                          return UserCard(
                              user: user,
                              onTap: () {
                                Navigator.pushNamed(itemContext, '/user',
                                    arguments: user.id);
                              });
                        },
                        loader: (page, pageSize) {
                          return getUserFollowers(id, page, pageSize);
                        },
                        placeholder: Center(
                            child: Text(
                                AppLocalizations.of(context)!.noFollowers)),
                        titleBuilder: (total) {
                          return Text(AppLocalizations.of(context)!
                              .followersCount(total));
                        },
                      ),
                    ])),
                drawer: const AppDrawer(),
                endDrawer: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Drawer(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.network(entity.pictureMedium!,
                              height: 250.0, width: 250.0),
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
