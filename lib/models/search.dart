import 'domain.dart';

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

    const SearchResponse({this.data});
}

class PartialSearchResponse<T> : SearchResponse<T> {
    final int total;
    final String? prev, next;

    const PartialSearchResponse({super.data, this.total, this.prev, this.next});
}
