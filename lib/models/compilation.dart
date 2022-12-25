import 'playable.dart';

class Chart {
  final int id;
  final List<Track> tracks;
  final List<Album> albums;
  final List<Artist> artists;
  final List<Playlist> playlists;

  const Chart(this.id, this.tracks, this.albums, this.artists, this.playlists);

  Chart.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        tracks = json['tracks'] != null &&
                json['tracks'] is Map<String, dynamic>
            ? [for (var track in json['tracks']['data']) Track.fromJson(track)]
            : null,
        albums = json['albums'] != null &&
                json['albums'] is Map<String, dynamic>
            ? [for (var album in json['albums']['data']) Album.fromJson(album)]
            : null,
        artists =
            json['artists'] != null && json['artists'] is Map<String, dynamic>
                ? [
                    for (var artist in json['artists']['data'])
                      Artist.fromJson(artist)
                  ]
                : null,
        playlists = json['playlists'] != null &&
                json['playlists'] is Map<String, dynamic>
            ? [
                for (var playlist in json['playlists']['data'])
                  Playlist.fromJson(playlist)
              ]
            : null;
}

class Editorial {
  final int id;
  final String name;
  final String picture, pictureSmall, pictureMedium, pictureBig, pictureXl;

  const Editorial(this.id, this.name, this.picture, this.pictureSmall,
      this.pictureMedium, this.pictureBig, this.pictureXl);

  Editorial.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        picture = json['picture'],
        pictureSmall = json['picture_small'],
        pictureMedium = json['picture_medium'],
        pictureBig = json['picture_big'],
        pictureXl = json['picture_xl'];
}
