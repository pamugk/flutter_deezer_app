import 'package:flutter/material.dart';

import '../widgets/drawer.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 7,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Поиск'),
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(
                text: 'Все',
              ),
              Tab(
                text: 'Треки',
              ),
              Tab(
                text: 'Альбомы',
              ),
              Tab(
                text: 'Исполнители',
              ),
              Tab(
                text: 'Плейлисты',
              ),
              Tab(
                text: 'Миксы',
              ),
              Tab(
                text: 'Профили',
              ),
            ],
          ),
        ),
        drawer: const AppDrawer(),
        body: const TabBarView(
          children: <Widget>[
            Center(
              child: Text("Общие результаты поиска"),
            ),
            Center(
              child: Text("Список треков"),
            ),
            Center(
              child: Text("Список альбомов"),
            ),
            Center(
              child: Text("Список исполнителей"),
            ),
            Center(
              child: Text("Список плейлистов"),
            ),
            Center(
              child: Text("Список миксов"),
            ),
            Center(
              child: Text("Список пользователей"),
            ),
          ],
        ),
      ),
    );
  }
}
