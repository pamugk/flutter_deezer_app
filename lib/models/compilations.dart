include 'domain.dart';
include 'search.dart';

class Chart {
    int id;
    SearchResponse<Track> tracks;
    SearchResponse<Album> albums;
    SearchResponse<Artist> artists;
    SearchResponse<Playlist> playlists;
}

class Editorial {
    int id;
    String name;
    String picture;
    String picture_small;
    String picture_medium;
    String picture_big;
    String picture_xl;
}
