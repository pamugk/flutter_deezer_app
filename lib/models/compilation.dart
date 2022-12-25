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
        tracks = [
          for (var track in json['tracks']['data']) Track.fromJson(track)
        ],
        albums = [
          for (var album in json['albums']['data']) Album.fromJson(album)
        ],
        artists = [
          for (var artist in json['artists']['data']) Artist.fromJson(artist)
        ],
        playlists = [
          for (var playlist in json['playlists']['data'])
            Playlist.fromJson(playlist)
        ];
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
