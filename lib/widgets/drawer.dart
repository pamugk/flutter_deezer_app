import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Drawer build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: const <Widget>[
          DrawerHeader(
            child: Image(
                image: AssetImage('assets/images/Colored_Full_Black@2x.png')),
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
  }
}
