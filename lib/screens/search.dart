import 'package:flutter/material.dart';

import '../widgets/drawer.dart';

class SearchPageDelegate extends SearchDelegate {
  final TabController _tabController;

  SearchPageDelegate(TickerProvider tickerProvider)
    : _tabController = TabController(vsync: tickerProvider, length: 7),
      super(searchFieldLabel: 'Поиск');

  @override
  List<Widget>? buildActions(BuildContext context) {
    return null;
  }

  @override
  PreferredSizeWidget? buildBottom(BuildContext context) {
    return true ? null : TabBar(
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
            controller: _tabController,
          );
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    return TabBarView(
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
          controller: _tabController,
        );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return const Center(child: Text('Нечего предложить'));
  }
}
