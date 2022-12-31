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
              switch (searchResult.destination) {
                case Destination.album:
                  break;
                case Destination.artist:
                  break;
                case Destination.playlist:
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
