import 'package:flutter/material.dart';

import 'search.dart';
import '../widgets/drawer.dart';
import '../widgets/player.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Главная"), actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.search),
          tooltip: 'Поиск',
          onPressed: () async {
            final searchResult = await showSearch(
              context: context,
              delegate: SearchPageDelegate(this),
            );
            if (searchResult != null) {
              if (!mounted) return;
              switch (searchResult.destination) {
                case Destination.album:
                  Navigator.pushNamed(context, '/album',
                      arguments: searchResult.id);
                  break;
                case Destination.artist:
                  Navigator.pushNamed(context, '/artist',
                      arguments: searchResult.id);
                  break;
                case Destination.playlist:
                  Navigator.pushNamed(context, '/playlist',
                      arguments: searchResult.id);
                  break;
                case Destination.radio:
                  break;
                case Destination.user:
                  break;
              }
            }
          },
        ),
      ]),
      drawer: const AppDrawer(),
      bottomSheet: const Player(),
    );
  }
}
