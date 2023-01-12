import 'package:flutter/material.dart';

import '../models/playable.dart';
import '../navigation/artist_arguments.dart';
import '../utils/duration.dart';

class TrackTable extends StatefulWidget {
  final Widget title;
  final List<TrackShort> tracks;

  const TrackTable({super.key, required this.tracks, required this.title});

  @override
  State<TrackTable> createState() => _TrackTableState();
}

class _TrackTableState extends State<TrackTable> {
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      widget.title,
      DataTable(columns: const <DataColumn>[
        DataColumn(
          label: Expanded(
            child: Text(
              'Трек',
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              'Исполнитель',
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              'Альбом',
            ),
          ),
        ),
        DataColumn(
          label: Icon(
            Icons.access_time,
          ),
          tooltip: 'Длительность',
        ),
      ], rows: [
        for (var track in widget.tracks)
          DataRow(onSelectChanged: (bool? selected) {}, cells: <DataCell>[
            DataCell(Row(children: [
              Image.network(track.album!.coverSmall, height: 56.0, width: 56.0),
              Text(track.title)
            ])),
            DataCell(Text(track.artist.name), onTap: () {
              Navigator.pushNamed(context, '/artist',
                  arguments: ArtistArguments(track.artist.id));
            }),
            DataCell(Text(track.album!.title), onTap: () {
              Navigator.pushNamed(context, '/album',
                  arguments: track.album!.id);
            }),
            DataCell(Text(formatDuration(track.duration))),
          ])
      ])
    ]);
  }
}
