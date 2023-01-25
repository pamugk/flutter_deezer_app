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
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: MaterialColor(0xFFDB343D, {
            50: Color(0xFFFCEBEE),
            100: Color(0xFFF7CCD3),
            200: Color(0xFFE7999C),
            300: Color(0xFFDB7176),
            400: Color(0xFFE45156),
            500: Color(0xFFEF5466),
            600: Color(0xFFDB343D),
            700: Color(0xFFCA2A36),
            800: Color(0xFFBE2730),
            900: Color(0xFFB12424),
          }),
          errorColor: Color(0xFFDF3C3C)),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontFamily: 'Roboto'),
          bodyMedium: TextStyle(fontFamily: 'Roboto'),
          bodySmall: TextStyle(fontFamily: 'Roboto'),
          displayLarge: TextStyle(fontFamily: 'MabryDeezer'),
          displayMedium: TextStyle(fontFamily: 'MabryDeezer'),
          displaySmall: TextStyle(fontFamily: 'MabryDeezer'),
          headlineLarge: TextStyle(fontFamily: 'MabryDeezer'),
          headlineMedium: TextStyle(fontFamily: 'MabryDeezer'),
          headlineSmall: TextStyle(fontFamily: 'MabryDeezer'),
          labelLarge: TextStyle(fontFamily: 'Roboto'),
          labelMedium: TextStyle(fontFamily: 'Roboto'),
          labelSmall: TextStyle(fontFamily: 'Roboto'),
          titleLarge: TextStyle(fontFamily: 'MabryDeezer'),
          titleMedium: TextStyle(fontFamily: 'MabryDeezer'),
          titleSmall: TextStyle(fontFamily: 'MabryDeezer'),
        ),
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
