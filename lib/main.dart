import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'screens/album.dart';
import 'screens/artist.dart';
import 'screens/home.dart';
import 'screens/playlist.dart';
import 'screens/search.dart';
import 'screens/user.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Deezer',
      theme: ThemeData(
        useMaterial3: true,
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const HomePage(),
      routes: {
        '/album': (context) => const AlbumPage(),
        '/artist': (context) => const ArtistPage(),
        '/search': (context) => const SearchPage(),
        '/playlist': (context) => const PlaylistPage(),
        '/user': (context) => const UserPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
