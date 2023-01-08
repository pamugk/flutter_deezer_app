import 'dart:math';

import 'package:flutter/material.dart';

class Carousel extends StatefulWidget {
  final List<Widget> children;
  final double spacing;
  final Text title;
  final VoidCallback? onNavigate;

  const Carousel(
      {super.key,
      required this.children,
      required this.title,
      this.spacing = 0,
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
          final countOfElements = max(constraints.maxWidth ~/ (250 + widget.spacing), 1);
          final cutOffElements = shiftedChildren.take(countOfElements).toList();
          return Column(
            children: <Widget>[
              Row(children: <Widget>[
                widget.title,
                if (widget.onNavigate != null)
                  IconButton(
                    icon: const Icon(Icons.navigate_next),
                    tooltip: 'Перейти',
                    onPressed: widget.onNavigate,
                  ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.navigate_before),
                  onPressed: _offset == 0 ? null : () {
                    setState((){
                      _offset = max(_offset - countOfElements, 0);
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.navigate_next),
                  onPressed: _offset + countOfElements >= widget.children.length
                    ? null
                    : () {
                      setState((){
                        _offset += countOfElements;
                      });
                    },
                ),
              ]),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [for (var element in cutOffElements) Padding(padding: EdgeInsets.only(left: widget.spacing, top: 24.0), child: element)]),
            ],
          );
      },
    );
  }
}
