enum SearchOrder {
  RANKING,
  TRACK_ASC,
  TRACK_DESC,
  ARTIST_ASC,
  ARTIST_DESC,
  ALBUM_ASC,
  ALBUM_DESC,
  RATING_ASC,
  RATING_DESC,
  DURATION_ASC,
  DURATION_DESC
}

class SearchResponse<T> {
  final List<T> data;
  final int total;

  const SearchResponse(this.data);
}

class PartialSearchResponse<T> extends SearchResponse<T> {
  final String? prev, next;

  const PartialSearchResponse(super.data, super.total, this.prev, this.next);
}
