import 'package:flutter/material.dart';

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
      routes: <String, WidgetBuilder>{
        '/search': (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Поиск'),
              bottom: const TabBar(
                tabs: <Widget>[
                  Tab(
                    icon: Icon(Icons.cloud_outlined),
                  ),
                  Tab(
                    icon: Icon(Icons.beach_access_sharp),
                  ),
                  Tab(
                    icon: Icon(Icons.brightness_5_sharp),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
