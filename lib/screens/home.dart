import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../widgets/drawer.dart';
import '../widgets/player.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.home),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.search),
              tooltip: AppLocalizations.of(context)!.search,
              onPressed: () {
                Navigator.pushNamed(context, '/search');
              },
            ),
          ]),
      drawer: const AppDrawer(),
      bottomSheet: const Player(),
    );
  }
}
