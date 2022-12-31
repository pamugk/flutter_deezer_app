import 'playable.dart';
import 'user.dart';

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

class FullSearchResponse {
  final SearchResponse<Album> albums;
  final SearchResponse<Artist> artists;
  final SearchResponse<Playlist> playlists;
  final SearchResponse<Radio> radios;
  final SearchResponse<TrackShort> tracks;
  final SearchResponse<UserShort> users;

  const FullSearchResponse(this.albums, this.artists, this.playlists,
      this.radios, this.tracks, this.users);
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
