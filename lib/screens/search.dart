import 'package:flutter/material.dart';

import '../models/search.dart';
import '../providers/deezer.dart';
import '../utils/duration.dart';
import '../widgets/album_card.dart';
import '../widgets/artist_card.dart';
import '../widgets/playlist_card.dart';
import '../widgets/radio_card.dart';
import '../widgets/user_card.dart';

enum Destination {
  album,
  artist,
  playlist,
  radio,
  user,
}

class SearchPageOutput {
  final int id;
  final Destination destination;
  const SearchPageOutput(this.id, this.destination);
}

class SearchPageDelegate extends SearchDelegate<SearchPageOutput> {
  Future<FullSearchResponse>? _searchResponseFuture;
  final TabController _tabController;

  SearchPageDelegate(TickerProvider tickerProvider)
      : _tabController = TabController(vsync: tickerProvider, length: 7),
        super(searchFieldLabel: 'Поиск');

  @override
  List<Widget>? buildActions(BuildContext context) {
    return null;
  }

  @override
  PreferredSizeWidget? buildBottom(BuildContext context) {
    return _searchResponseFuture == null
        ? null
        : TabBar(
            tabs: const <Widget>[
              Tab(
                text: 'Все',
              ),
              Tab(
                text: 'Треки',
              ),
              Tab(
                text: 'Альбомы',
              ),
              Tab(
                text: 'Исполнители',
              ),
              Tab(
                text: 'Плейлисты',
              ),
              Tab(
                text: 'Миксы',
              ),
              Tab(
                text: 'Профили',
              ),
            ],
            controller: _tabController,
          );
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<FullSearchResponse>(
      future: _searchResponseFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return TabBarView(
            controller: _tabController,
            children: <Widget>[
              SingleChildScrollView(
                  child: Column(children: <Widget>[
                const Text('Треки'),
                Table(
                  border: TableBorder.all(),
                  columnWidths: const <int, TableColumnWidth>{
                    0: IntrinsicColumnWidth(),
                    1: FixedColumnWidth(56),
                    5: IntrinsicColumnWidth(),
                    6: IntrinsicColumnWidth(),
                  },
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: snapshot.data!.tracks.data
                      .take(5)
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
                ),
                const Text('Альбомы'),
                Wrap(
                    spacing: 8.0,
                    runSpacing: 4.0,
                    children: snapshot.data!.albums.data
                        .take(5)
                        .map((album) => AlbumCard(
                            album: album,
                            onTap: () {
                              close(
                                  context,
                                  SearchPageOutput(
                                      album.id, Destination.album));
                            }))
                        .toList()),
                const Text('Исполнители'),
                Wrap(
                    spacing: 8.0,
                    runSpacing: 4.0,
                    children: snapshot.data!.artists.data
                        .take(5)
                        .map((artist) => ArtistCard(
                            artist: artist,
                            onTap: () {
                              close(
                                  context,
                                  SearchPageOutput(
                                      artist.id, Destination.artist));
                            }))
                        .toList()),
                const Text('Плейлисты'),
                Wrap(
                    spacing: 8.0,
                    runSpacing: 4.0,
                    children: snapshot.data!.playlists.data
                        .take(5)
                        .map((playlist) => PlaylistCard(
                            playlist: playlist,
                            onTap: () {
                              close(
                                  context,
                                  SearchPageOutput(
                                      playlist.id, Destination.playlist));
                            }))
                        .toList()),
                const Text('Миксы'),
                Wrap(
                    spacing: 8.0,
                    runSpacing: 4.0,
                    children: snapshot.data!.radios.data
                        .take(5)
                        .map((radio) => RadioCard(
                            radio: radio,
                            onTap: () {
                              close(
                                  context,
                                  SearchPageOutput(
                                      radio.id, Destination.radio));
                            }))
                        .toList()),
                const Text('Пользователи'),
                Wrap(
                    spacing: 8.0,
                    runSpacing: 4.0,
                    children: snapshot.data!.users.data
                        .take(5)
                        .map((user) => UserCard(
                            user: user,
                            onTap: () {
                              close(context,
                                  SearchPageOutput(user.id, Destination.user));
                            }))
                        .toList()),
              ])),
              Center(
                child: Text('Список треков: ${snapshot.data!.tracks.total}: '),
              ),
              Center(
                child: Text('Список альбомов: ${snapshot.data!.albums.total}'),
              ),
              Center(
                child: Text(
                    'Список исполнителей: ${snapshot.data!.artists.total}'),
              ),
              Center(
                child: Text(
                    'Список плейлистов: ${snapshot.data!.playlists.total}'),
              ),
              Center(
                child: Text('Список миксов: ${snapshot.data!.radios.total}'),
              ),
              Center(
                child:
                    Text('Список пользователей: ${snapshot.data!.users.total}'),
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return const Center(child: Text('Нечего предложить'));
  }

  @override
  void showResults(BuildContext context) {
    _searchResponseFuture = search(query);
    super.showResults(context);
  }
}
