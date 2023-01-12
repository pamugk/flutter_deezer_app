import 'package:flutter/material.dart';

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
  late Future<PartialSearchResponse<TrackShort>> _tracksFuture;

  @override
  void initState() {
    super.initState();
    _tracksFuture = widget.loader(_page, _pageSize);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PartialSearchResponse<TrackShort>>(
        future: _tracksFuture,
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
                      _tracksFuture = widget.loader(newPage, _pageSize);
                        _page = newPage;
                      });
                    },
                    rowsPerPage: _pageSize,
                    columns: const <DataColumn>[
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
                    ],
                    source: datasource);
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return const Center(child: CircularProgressIndicator());
        });
  }
}
