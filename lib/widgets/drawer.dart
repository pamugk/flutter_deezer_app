import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Drawer build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            child: Image(
                image: AssetImage('assets/images/Colored_Full_Black@2x.png')),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: Text(AppLocalizations.of(context)!.home),
          ),
          ListTile(
            leading: const Icon(Icons.explore),
            title: Text(AppLocalizations.of(context)!.explore),
          ),
        ],
      ),
    );
  }
}
