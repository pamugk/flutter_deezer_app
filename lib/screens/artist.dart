import 'package:flutter/material.dart';

import '../models/playable.dart';
import '../navigation/artist_arguments.dart';
import '../providers/deezer.dart';
import '../widgets/album_card.dart';
import '../widgets/artist_card.dart';
import '../widgets/data_grid.dart';
import '../widgets/drawer.dart';
import '../widgets/paginated_track_table.dart';
import '../widgets/player.dart';
import '../widgets/playlist_card.dart';

class ArtistPage extends StatefulWidget {
  const ArtistPage({super.key});

  @override
  State<ArtistPage> createState() => _ArtistPageState();
}

class _ArtistPageState extends State<ArtistPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)!.settings.arguments as ArtistArguments;
    return FutureBuilder<Artist>(
        future: getArtist(arguments.id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final artist = snapshot.data!;
            return DefaultTabController(
                initialIndex: arguments.section,
                length: 5,
                child: Scaffold(
                    key: _scaffoldKey,
                    appBar: AppBar(
                      title: InkWell(
                      onTap: () {
                        _scaffoldKey.currentState!.openEndDrawer();
                      },
                      child: Row(children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(artist.pictureSmall),
                        ),
                        Text(artist.name),
                      ])),
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
                    body: Padding(
                        padding: const EdgeInsets.only(bottom: 100.0),
                        child: TabBarView(children: <Widget>[
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
                              return getArtistAlbums(
                                  arguments.id, page, pageSize);
                            },
                            titleBuilder: (total) {
                              return Text('Альбомов в дискографии: $total');
                            },
                          ),
                          SingleChildScrollView(
                              child: PaginatedTrackTable(
                            loader: (int page, int pageSize) {
                              return getArtistTopTracks(
                                  arguments.id, page, pageSize);
                            },
                            titleBuilder: (int trackCount) {
                              return Text('Популярных треков: $trackCount');
                            },
                          )),
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
                              return getArtistRelated(
                                  arguments.id, page, pageSize);
                            },
                            titleBuilder: (total) {
                              return Text('Похожих исполнителей: $total');
                            },
                          ),
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
                              return getArtistPlaylists(
                                  arguments.id, page, pageSize);
                            },
                            titleBuilder: (total) {
                              return Text('Плейлистов: $total');
                            },
                          ),
                          const Center(child: Text('Тут комментарии')),
                        ])),
                    drawer: const AppDrawer(),
                    endDrawer: Drawer(
                      child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.network(artist.pictureMedium,
                              height: 250.0, width: 250.0),
                          Text('Поклонников: ${artist.fanCount ?? 0}'),
                        ],
                      ),
                    )),
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
