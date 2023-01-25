import 'package:flutter/material.dart';

Dialog imageDialogBuilder(BuildContext context, String imageUrl, String title) {
  return Dialog(
      child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(title, style: Theme.of(context).textTheme.titleLarge),
              CloseButton(onPressed: () => Navigator.of(context).pop()),
            ]),
            const SizedBox(height: 8.0),
            Image.network(imageUrl,
                fit: BoxFit.contain,
                height: MediaQuery.of(context).size.height - 120),
          ])));
}
