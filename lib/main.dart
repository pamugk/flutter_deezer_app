import 'package:flutter/material.dart';

import 'screens/album.dart';
import 'screens/artist.dart';
import 'screens/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Deezer',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const HomePage(),
      routes: {
        '/album': (context) => const AlbumPage(),
        '/artist': (context) => const ArtistPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
