import 'package:flutter/material.dart';

import '../widgets/drawer.dart';
import '../widgets/player.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Главная"),
      ),
      drawer: const AppDrawer(),
      bottomSheet: const Player(),
    );
  }
}
