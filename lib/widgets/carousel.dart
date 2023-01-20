import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Carousel extends StatefulWidget {
  final List<Widget> children;
  final Text title;
  final VoidCallback? onNavigate;

  const Carousel(
      {super.key,
      required this.children,
      required this.title,
      this.onNavigate});

  @override
  State<Carousel> createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  int _offset = 0;

  @override
  Widget build(BuildContext context) {
    final shiftedChildren = widget.children.skip(_offset).toList();
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final countOfElements = max(constraints.maxWidth ~/ 284, 1);
        final cutOffElements = shiftedChildren.take(countOfElements).toList();
        return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: <Widget>[
                Row(children: <Widget>[
                  widget.title,
                  if (widget.onNavigate != null)
                    IconButton(
                      icon: const Icon(Icons.navigate_next),
                      tooltip: AppLocalizations.of(context)!.navigate,
                      onPressed: widget.onNavigate,
                    ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.navigate_before),
                    onPressed: _offset == 0
                        ? null
                        : () {
                            setState(() {
                              _offset = max(_offset - countOfElements, 0);
                            });
                          },
                  ),
                  IconButton(
                    icon: const Icon(Icons.navigate_next),
                    onPressed:
                        _offset + countOfElements >= widget.children.length
                            ? null
                            : () {
                                setState(() {
                                  _offset += countOfElements;
                                });
                              },
                  ),
                ]),
                Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: cutOffElements),
              ],
            ));
      },
    );
  }
}
