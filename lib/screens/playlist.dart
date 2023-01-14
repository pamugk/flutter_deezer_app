import 'package:flutter/material.dart';

import '../models/playable.dart';
import '../providers/deezer.dart';
import '../widgets/drawer.dart';
import '../widgets/player.dart';
import '../widgets/track_table.dart';

class PlaylistPage extends StatefulWidget {
  const PlaylistPage({super.key});

  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

bool _checkTrack(TrackShort track, String searchText) {
  final normalizedSearchText = searchText.toLowerCase();
  return track.title.toLowerCase().contains(normalizedSearchText) ||
      track.album!.title.toLowerCase().contains(normalizedSearchText) ||
      track.artist.name.toLowerCase().contains(normalizedSearchText);
}

class _PlaylistPageState extends State<PlaylistPage> {
  String _searchText = "";

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)!.settings.arguments as int;
    return FutureBuilder<Playlist>(
        future: getPlaylist(id),
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
                body: Padding(
                    padding: const EdgeInsets.only(bottom: 100.0),
                    child: SingleChildScrollView(
                        child: TrackTable(
                      placeholder: Center(
                          child: Text('Нет результатов для "$_searchText"')),
                      title: TextField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Поиск',
                          prefix: Icon(Icons.search),
                        ),
                        onChanged: (text) {
                          setState(() {
                            _searchText = text;
                          });
                        },
                      ),
                      tracks: [
                        for (var track in playlist.tracks!)
                          if (_checkTrack(track, _searchText)) track
                      ],
                    ))),
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
