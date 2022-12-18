import 'package:flutter/material.dart';

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
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final drawer = Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: const <Widget>[
          DrawerHeader(
            child: Image(
              image: AssetImage('assets/images/Colored_Full_Black@2x.png')
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Главная'),
          ),
          ListTile(
            leading: Icon(Icons.explore),
            title: Text('Исследуйте'),
          ),
          ListTile(
            leading: Icon(Icons.library_music),
            title: Text('Моя музыка'),
          ),
          ListTile(
            title: Text('Любимые треки'),
          ),
          ListTile(
            title: Text('Плейлисты'),
          ),
          ListTile(
            title: Text('Альбомы'),
          ),
          ListTile(
            title: Text('Исполнители'),
          ),
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Главная"),
      ),
      drawer: size.width < 500 ? drawer : null,
      body: Stack(
        children: <Widget>[
          if (size.width >= 500) drawer,
        ],
      ),
    );
  }
}
