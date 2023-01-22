import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'track_cell.dart';
import 'track_column.dart';
import '../models/playable.dart';
import '../models/search.dart';
import '../navigation/artist_arguments.dart';
import '../utils/duration.dart';

class PaginatedTrackTable extends StatefulWidget {
  final Set<TrackColumn> columns;
  final Future<PartialSearchResponse<TrackShort>> Function(int, int) loader;
  final Widget Function(int) titleBuilder;

  const PaginatedTrackTable(
      {super.key,
      required this.columns,
      required this.loader,
      required this.titleBuilder});

  @override
  State<PaginatedTrackTable> createState() => _PaginatedTrackTableState();
}

class _TrackTableDataSource extends DataTableSource {
  final Set<TrackColumn> columns;
  final BuildContext context;
  final PartialSearchResponse<TrackShort> data;
  final void Function(int, bool?) onSelected;
  final int pageSize;
  final Set<int> selectedRows;

  @override
  bool isRowCountApproximate = false;

  @override
  int rowCount;

  @override
  int selectedRowCount = 0;

  _TrackTableDataSource(
      {required this.columns,
      required this.context,
      required this.data,
      required this.onSelected,
      required this.pageSize,
      required this.selectedRows})
      : rowCount = data.total;

  @override
  DataRow? getRow(int index) {
    final internalIndex = index % pageSize;
    if (internalIndex >= data.data.length) {
      return null;
    }
    final track = data.data[internalIndex];
    return DataRow(
        onSelectChanged: track.readable
            ? (selected) {
                onSelected(track.id, selected);
              }
            : null,
        selected: selectedRows.contains(track.id),
        cells: <DataCell>[
          if (columns.contains(TrackColumn.track))
            DataCell(TrackCell(track: track)),
          if (columns.contains(TrackColumn.artist))
            DataCell(
                Tooltip(
                    message: track.artist.name,
                    child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 215.0),
                        child: Text(track.artist.name,
                            overflow: TextOverflow.ellipsis))), onTap: () {
              Navigator.pushNamed(context, '/artist',
                  arguments: ArtistArguments(track.artist.id));
            }),
          if (columns.contains(TrackColumn.album))
            DataCell(
                Tooltip(
                    message: track.album!.title,
                    child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 215.0),
                        child: Text(track.album!.title,
                            overflow: TextOverflow.ellipsis))), onTap: () {
              Navigator.pushNamed(context, '/album',
                  arguments: track.album!.id);
            }),
          if (columns.contains(TrackColumn.duration))
            DataCell(Text(formatDuration(track.duration))),
        ]);
  }
}

class _PaginatedTrackTableState extends State<PaginatedTrackTable> {
  int _page = 0;
  final int _pageSize = 25;
  final Set<int> _selectedRows = {};

  void _onSelected(int trackId, bool? selected) {
    if (selected != null) {
      if (selected) {
        if (_selectedRows.add(trackId)) {
          setState(() {});
        }
      } else {
        if (_selectedRows.remove(trackId)) {
          setState(() {});
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PartialSearchResponse<TrackShort>>(
        future: widget.loader(_page, _pageSize),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final tracks = snapshot.data!;
            final datasource = _TrackTableDataSource(
                columns: widget.columns,
                context: context,
                data: tracks,
                onSelected: _onSelected,
                pageSize: _pageSize,
                selectedRows: _selectedRows);
            return PaginatedDataTable(
                availableRowsPerPage: [_pageSize],
                header: widget.titleBuilder(tracks.total),
                onPageChanged: (newPage) {
                  setState(() {
                    _page = newPage;
                  });
                },
                rowsPerPage: _pageSize,
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
                source: datasource);
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return const Center(child: CircularProgressIndicator());
        });
  }
}
