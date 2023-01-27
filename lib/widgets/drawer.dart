import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  int _getCurrentDestinationIndex(BuildContext context) {
    switch (ModalRoute.of(context)?.settings?.name) {
      case '/':
        return 0;
      default:
        return -1;
    }
  }

  void _onDestinationSelected(BuildContext context, int destination) {
    switch (destination) {
      case 0:
        Navigator.pushNamed(context, '/');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final logo = Theme.of(context)!.brightness == Brightness.light
      ? const AssetImage('assets/images/Colored_Full_Black@2x.png')
      : const AssetImage('assets/images/Colored_Full_White@2x.png');
    final selectedIndex = _getCurrentDestinationIndex(context);
    return NavigationDrawer(
      onDestinationSelected: (destination) {
        _onDestinationSelected(context, destination);
      },
      selectedIndex: selectedIndex,
      children: <Widget>[
        DrawerHeader(child: Image(image: logo)),
        NavigationDrawerDestination(
          icon: const Icon(Icons.home),
          label: Text(AppLocalizations.of(context)!.home),
        ),
        NavigationDrawerDestination(
          icon: const Icon(Icons.explore),
          label: Text(AppLocalizations.of(context)!.explore),
        ),
      ],
    );
  }
}
