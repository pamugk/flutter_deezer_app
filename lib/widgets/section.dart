import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Section extends StatelessWidget {
  final List<Widget> children;
  final VoidCallback? onNavigate;
  final Text title;

  const Section(
      {super.key,
      required this.children,
      required this.title,
      this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(24.0),
        child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          final countOfElements = max((constraints.maxWidth - 48) ~/ 282, 1);
          final cutOffElements = children.take(countOfElements).toList();
          return Column(
            children: <Widget>[
              Row(children: <Widget>[
                title,
                if (onNavigate != null)
                  IconButton(
                    icon: const Icon(Icons.navigate_next),
                    tooltip: AppLocalizations.of(context)!.navigate,
                    onPressed: onNavigate,
                  ),
              ]),
              Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: cutOffElements),
            ],
          );
        }));
  }
}
