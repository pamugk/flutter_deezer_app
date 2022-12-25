enum SearchOrder {
  ranking,
  trackAsc,
  trackDesc,
  artistAsc,
  artistDesc,
  albumAsc,
  albumDesc,
  ratingAsc,
  ratingDesc,
  durationAsc,
  durationDesc
}

class SearchResponse<T> {
  final List<T> data;
  final int total;

  const SearchResponse(this.data, this.total);
}

class PartialSearchResponse<T> extends SearchResponse<T> {
  final String? prev, next;

  const PartialSearchResponse(super.data, super.total, this.prev, this.next);
}
