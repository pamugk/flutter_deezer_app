import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'track_cell.dart';
import 'track_column.dart';
import '../models/playable.dart';
import '../navigation/artist_arguments.dart';
import '../utils/duration.dart';

class TrackTable extends StatefulWidget {
  final Set<TrackColumn> columns;
  final Widget title;
  final List<TrackShort> tracks;

  const TrackTable(
      {super.key,
      required this.columns,
      required this.tracks,
      required this.title});

  @override
  State<TrackTable> createState() => _TrackTableState();
}

class _TrackTableState extends State<TrackTable> {
  Set<int> _selectedRows = {};

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      widget.title,
      DataTable(
          onSelectAll: (bool? selected) {
            if (selected != null) {
              if (selected) {
                setState(() {
                  _selectedRows = widget.tracks
                      .where((track) => track.readable)
                      .map((track) => track.id)
                      .toSet();
                });
              } else {
                setState(() {
                  _selectedRows = {};
                });
              }
            }
          },
          columns: <DataColumn>[
            if (widget.columns.contains(TrackColumn.track))
              DataColumn(
                label: Expanded(
                  child: Text(
                    AppLocalizations.of(context)!.track,
                  ),
                ),
              ),
            if (widget.columns.contains(TrackColumn.artist))
              DataColumn(
                label: Expanded(
                  child: Text(
                    AppLocalizations.of(context)!.artist,
                  ),
                ),
              ),
            if (widget.columns.contains(TrackColumn.album))
              DataColumn(
                label: Expanded(
                  child: Text(
                    AppLocalizations.of(context)!.album,
                  ),
                ),
              ),
            if (widget.columns.contains(TrackColumn.duration))
              DataColumn(
                label: const Icon(
                  Icons.access_time,
                ),
                tooltip: AppLocalizations.of(context)!.duration,
              ),
          ],
          rows: [
            for (var track in widget.tracks)
              DataRow(
                  onSelectChanged: track.readable
                      ? (bool? selected) {
                          if (selected != null) {
                            if (selected) {
                              if (_selectedRows.add(track.id)) {
                                setState(() {});
                              }
                            } else {
                              if (_selectedRows.remove(track.id)) {
                                setState(() {});
                              }
                            }
                          }
                        }
                      : null,
                  selected: _selectedRows.contains(track.id),
                  cells: <DataCell>[
                    if (widget.columns.contains(TrackColumn.track))
                      DataCell(TrackCell(track: track)),
                    if (widget.columns.contains(TrackColumn.artist))
                      DataCell(
                          Tooltip(
                              message: track.artist.name,
                              child: ConstrainedBox(
                                  constraints: const BoxConstraints(maxWidth: 215.0),
                                  child: Text(track.artist.name,
                                      overflow: TextOverflow.ellipsis))),
                          onTap: () {
                        Navigator.pushNamed(context, '/artist',
                            arguments: ArtistArguments(track.artist.id));
                      }),
                    if (widget.columns.contains(TrackColumn.album))
                      DataCell(
                          Tooltip(
                              message: track.album!.title,
                              child: ConstrainedBox(
                                  constraints: const BoxConstraints(maxWidth: 215.0),
                                  child: Text(track.album!.title,
                                      overflow: TextOverflow.ellipsis))),
                          onTap: () {
                        Navigator.pushNamed(context, '/album',
                            arguments: track.album!.id);
                      }),
                    if (widget.columns.contains(TrackColumn.duration))
                      DataCell(Text(formatDuration(track.duration))),
                  ])
          ])
    ]);
  }
}
