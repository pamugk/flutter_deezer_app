import 'package:flutter/material.dart';

import '../models/user.dart';

class UserCard extends StatelessWidget {
  final GestureTapCallback? onTap;
  final UserShort user;
  const UserCard({super.key, required this.user, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
        child: InkWell(
            onTap: onTap,
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              Image.network(user.pictureMedium, height: 250.0, width: 250.0),
              Text(user.name),
            ])));
  }
}
