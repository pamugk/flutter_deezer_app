import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/playable.dart';
import '../models/search.dart';
import '../navigation/artist_arguments.dart';
import '../utils/duration.dart';

class PaginatedTrackTable extends StatefulWidget {
  final Future<PartialSearchResponse<TrackShort>> Function(int, int) loader;
  final Widget Function(int) titleBuilder;

  const PaginatedTrackTable(
      {super.key, required this.loader, required this.titleBuilder});

  @override
  State<PaginatedTrackTable> createState() => _PaginatedTrackTableState();
}

class _TrackTableDataSource extends DataTableSource {
  final BuildContext context;
  final PartialSearchResponse<TrackShort> data;
  final int pageSize;

  @override
  bool isRowCountApproximate = false;

  @override
  int rowCount;

  @override
  int selectedRowCount = 0;

  _TrackTableDataSource(this.context, this.data, this.pageSize)
      : rowCount = data.total;

  @override
  DataRow? getRow(int index) {
    final internalIndex = index % pageSize;
    if (internalIndex >= data.data.length) {
      return null;
    }
    final track = data.data[internalIndex];
    return DataRow(cells: <DataCell>[
      DataCell(Row(children: [
        Image.network(track.album!.coverSmall, height: 56.0, width: 56.0),
        Text(track.title)
      ])),
      DataCell(Text(track.artist.name), onTap: () {
        Navigator.pushNamed(context, '/artist',
            arguments: ArtistArguments(track.artist.id));
      }),
      DataCell(Text(track.album!.title), onTap: () {
        Navigator.pushNamed(context, '/album', arguments: track.album!.id);
      }),
      DataCell(Text(formatDuration(track.duration))),
    ]);
  }
}

class _PaginatedTrackTableState extends State<PaginatedTrackTable> {
  int _page = 0;
  final int _pageSize = 25;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PartialSearchResponse<TrackShort>>(
        future: widget.loader(_page, _pageSize),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final tracks = snapshot.data!;
            final datasource =
                _TrackTableDataSource(context, tracks, _pageSize);
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
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        AppLocalizations.of(context)!.track,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        AppLocalizations.of(context)!.artist,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        AppLocalizations.of(context)!.album,
                      ),
                    ),
                  ),
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
