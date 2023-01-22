import 'package:flutter/material.dart';

import '../models/user.dart';

class UserCard extends StatefulWidget {
  final GestureTapCallback? onTap;
  final UserShort user;
  const UserCard({super.key, required this.user, this.onTap});

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  bool active = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 282.0,
        child: Card(
            child: InkWell(
                onHover: (hovered) {
                  setState(() {
                    active = hovered;
                  });
                },
                onTap: widget.onTap,
                child:
                    Padding(
    padding: EdgeInsets.all(16.0),
    child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                  Opacity(
                        opacity: active ? 0.75 : 1.0,
                        child: CircleAvatar(
                    backgroundImage: NetworkImage(widget.user.pictureMedium!),
                    radius: 125.0,
                  )),
                  Tooltip(
                    message: widget.user.name,
                    child: Text(widget.user.name, overflow: TextOverflow.ellipsis)
                  ),
                ])))));
  }
}
