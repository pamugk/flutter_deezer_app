import 'package:flutter/material.dart';

import '../models/search.dart';

class DataGrid<T> extends StatefulWidget {
  final Widget Function(BuildContext, T) itemBuilder;
  final Future<PartialSearchResponse<T>> Function(int, int) loader;
  final Widget Function(int) titleBuilder;
  final Widget placeholder;

  const DataGrid({
    super.key,
    required this.itemBuilder,
    required this.loader,
    required this.titleBuilder,
    required this.placeholder,
  });

  @override
  State<DataGrid<T>> createState() => _DataGridState();
}

class _DataGridState<T> extends State<DataGrid<T>> {
  int _page = 0;
  final int _pageSize = 25;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        setState(() {
          _page++;
        });
      } else if (_page > 0 &&
          _scrollController.position.pixels ==
              _scrollController.position.minScrollExtent) {
        setState(() {
          _page--;
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PartialSearchResponse<T>>(
        future: widget.loader(_page, _pageSize),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final response = snapshot.data!;
            return response.total == 0
                ? widget.placeholder
                : GridView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(24.0),
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 282.0,
                            mainAxisSpacing: 24.0,
                            crossAxisSpacing: 34.0,
                            mainAxisExtent: 332.0),
                    itemCount: response.data.length,
                    itemBuilder: (itemContext, idx) {
                      return widget.itemBuilder(
                          itemContext, response.data[idx]);
                    },
                  );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return const Center(child: CircularProgressIndicator());
        });
  }
}
