import 'package:flutter/material.dart';

import '../models/playable.dart';
import '../providers/deezer.dart';
import '../utils/duration.dart';
import '../widgets/drawer.dart';
import '../widgets/player.dart';

class PlaylistPage extends StatefulWidget {
  const PlaylistPage({super.key});

  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  String _searchText = "";
  late Future<Playlist> _playlistFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final id = ModalRoute.of(context)!.settings.arguments as int;
    _playlistFuture = getPlaylist(id);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Playlist>(
        future: _playlistFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final playlist = snapshot.data!;
            return Scaffold(
                appBar: AppBar(
                  title: Text(playlist.title),
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
                ),
                body: SingleChildScrollView(
                    child: Column(children: <Widget>[
                  const Text('Треки'),
                  TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Трек, альбом, исполнитель...',
                      icon: Icon(Icons.search),
                    ),
                    onChanged: (text) {
                      setState(() {
                        _searchText = text.toLowerCase();
                      });
                    },
                  ),
                  Table(
                    border: TableBorder.all(),
                    columnWidths: const <int, TableColumnWidth>{
                      0: IntrinsicColumnWidth(),
                      1: FixedColumnWidth(56),
                      5: IntrinsicColumnWidth(),
                      6: IntrinsicColumnWidth(),
                    },
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: playlist.tracks!
                        .where((track) =>
                            track.title.toLowerCase().contains(_searchText) ||
                            track.album!.title
                                .toLowerCase()
                                .contains(_searchText) ||
                            track.artist.name
                                .toLowerCase()
                                .contains(_searchText))
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
                  const Text('Комментарии'),
                ])),
                drawer: const AppDrawer(),
                bottomSheet: const Player());
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
