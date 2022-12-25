import 'user.dart';

class Album {
  final int id;
  final String title;
  final String upc;

  final String cover, coverSmall, coverMedium, coverBig, coverXl;

  final List<Genre> genres;
  final String label;
  final int trackCount;
  final Duration duration;
  final int fanCount;
  final int rating;
  final DateTime releaseDate;
  final String recordType;
  final bool available;
  final Album? alternative;
  final String tracklist;

  final bool explicitLyrics;
  final int explicitContentLyrics, explicitContentCover;

  final List<Contributor> contributors;
  final Artist artist;
  final List<Track> tracks;

  const Album(
      this.id,
      this.title,
      this.upc,
      this.cover,
      this.coverSmall,
      this.coverMedium,
      this.coverBig,
      this.coverXl,
      this.genres,
      this.label,
      this.trackCount,
      this.duration,
      this.fanCount,
      this.rating,
      this.releaseDate,
      this.recordType,
      this.available,
      this.alternative,
      this.tracklist,
      this.explicitLyrics,
      this.explicitContentLyrics,
      this.explicitContentCover,
      this.contributors,
      this.artist,
      this.tracks);

  Album.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        upc = json['upc'],
        cover = json['cover'],
        coverSmall = json['cover_small'],
        coverMedium = json['cover_medium'],
        coverBig = json['cover_big'],
        coverXl = json['cover_xl'],
        genres = json['genres'] != null &&
                json['genres'] is Map<String, dynamic>
            ? [for (var genre in json['genres']['data']) Genre.fromJson(genre)]
            : null,
        label = json['label'],
        trackCount = json['nb_tracks'],
        duration = Duration(seconds: json['duration']),
        fanCount = json['fans'],
        rating = json['rating'],
        releaseDate = DateTime.parse(json['release_date']),
        recordType = json['record_type'],
        available = json['available'],
        alternative = json['alternative'] == null
            ? null
            : Album.fromJson(json['alternative']),
        tracklist = json['tracklist'],
        explicitLyrics = json['explicit_lyrics'],
        explicitContentLyrics = json['explicit_content_lyrics'],
        explicitContentCover = json['explicit_content_cover'],
        contributors = [
          for (var contributor in json['contributors'])
            Contributor.fromJson(contributor)
        ],
        artist = Artist.fromJson(json['artist']),
        tracks = json['tracks'] != null &&
                json['tracks'] is Map<String, dynamic>
            ? [for (var track in json['tracks']['data']) Track.fromJson(track)]
            : null;
}

class Artist {
  final int id;
  final String name;
  final String picture, pictureSmall, pictureMedium, pictureBig, pictureXl;
  final int albumCount;
  final int fanCount;
  final bool radio;
  final String tracklist;

  const Artist(
      this.id,
      this.name,
      this.picture,
      this.pictureSmall,
      this.pictureMedium,
      this.pictureBig,
      this.pictureXl,
      this.albumCount,
      this.fanCount,
      this.radio,
      this.tracklist);

  Artist.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        description = json['description'],
        picture = json['picture'],
        pictureSmall = json['picture_small'],
        pictureMedium = json['picture_medium'],
        pictureBig = json['picture_big'],
        pictureXl = json['picture_xl'],
        albumCount = json['nb_album'],
        fanCount = json['nb_fan'],
        radio = json['radio'],
        tracklist = json['tracklist'];
}

class Contributor {
  int id;

  const Contributor(this.id);

  Contributor.fromJson(Map<String, dynamic> json) : id = json['id'];
}

class Genre {
  final int id;
  final String name;
  final String picture, pictureSmall, pictureMedium, pictureBig, pictureXl;

  const Genre(this.id, this.name, this.picture, this.pictureSmall,
      this.pictureMedium, this.pictureBig, this.pictureXl);

  Genre.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        picture = json['picture'],
        pictureSmall = json['picture_small'],
        pictureMedium = json['picture_medium'],
        pictureBig = json['picture_big'],
        pictureXl = json['picture_xl'];
}

class Playlist {
  final int id;
  final String title;
  final String description;
  final Duration duration;
  final bool public;
  final bool favorite;
  final bool collaborative;
  final int rating;
  final int trackCount, unseenTrackCount;
  final int fanCount;
  final String picture, pictureSmall, pictureMedium, pictureBig, pictureXl;
  final String checksum;
  final User creator;
  final List<Track>? tracks;

  const Playlist(
      this.id,
      this.title,
      this.description,
      this.duration,
      this.public,
      this.favorite,
      this.collaborative,
      this.rating,
      this.trackCount,
      this.unseenTrackCount,
      this.fanCount,
      this.picture,
      this.pictureSmall,
      this.pictureMedium,
      this.pictureBig,
      this.pictureXl,
      this.checksum,
      this.creator,
      this.tracks);

  Playlist.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        description = json['description'],
        duration = Duration(seconds: json['duration']),
        public = json['public'],
        favorite = json['is_loved_track'],
        collaborative = json['collaborative'],
        rating = json['rating'],
        trackCount = json['nb_tracks'],
        unseenTrackCount = json['unseen_track_count'],
        fanCount = json['fans'],
        picture = json['picture'],
        pictureSmall = json['picture_small'],
        pictureMedium = json['picture_medium'],
        pictureBig = json['picture_big'],
        pictureXl = json['picture_xl'],
        checksum = json['checksum'],
        creator = User.fromJson(json['creator']),
        tracks = json['tracks'] != null &&
                json['tracks'] is Map<String, dynamic>
            ? [for (var track in json['tracks']['data']) Track.fromJson(track)]
            : null;
}

class Radio {
  final int id;
  final String title;
  final String description;
  final String picture, pictureSmall, pictureMedium, pictureBig, pictureXl;
  final String tracklist;

  const Radio(
      this.id,
      this.title,
      this.description,
      this.picture,
      this.pictureSmall,
      this.pictureMedium,
      this.pictureBig,
      this.pictureXl,
      this.tracklist);

  Radio.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        description = json['description'],
        picture = json['picture'],
        pictureSmall = json['picture_small'],
        pictureMedium = json['picture_medium'],
        pictureBig = json['picture_big'],
        pictureXl = json['picture_xl'],
        tracklist = json['tracklist'];
}

class Track extends TrackShort {
  final bool unseen;
  final String isrc;
  final int position;
  final int diskNumber;
  final DateTime releaseDate;
  final int explicitContentLyrics, explicitContentCover;
  final double bpm;
  final double gain;
  final List<String> availableCountries;
  final Track? alternative;
  final List<Contributor> contributors;

  const Track(
      super.id,
      super.readable,
      super.title,
      super.titleShort,
      super.titleVersion,
      super.duration,
      super.rank,
      super.explicitLyrics,
      super.preview,
      super.artist,
      super.album,
      this.unseen,
      this.isrc,
      this.position,
      this.diskNumber,
      this.releaseDate,
      this.explicitContentLyrics,
      this.explicitContentCover,
      this.bpm,
      this.gain,
      this.availableCountries,
      this.alternative,
      this.contributors);

  Track.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        readable = json['readable'],
        title = json['title'],
        titleShort = json['title_short'],
        titleVersion = json['title_version'],
        duration = Duration(seconds: json['duration']),
        rank = json['rank'],
        explicitLyrics = json['explicit_lyrics'],
        preview = json['preview'],
        artist = json['artist'],
        album = json['album'],
        unseen = json['unseen'],
        isrc = json['isrc'],
        position = json['track_position'],
        diskNumber = json['disk_number'],
        releaseDate = DateTime.parse(json['release_date']),
        explicitContentLyrics = json['explicit_content_lyrics'] == 1,
        explicitContentCover = json['explicit_content_cover'] == 1,
        bpm = json['bpm'],
        gain = json['gain'],
        availableCountries = json['available_countries'],
        alternative = json['alternative'] == null
            ? null
            : Track.fromJson(json['alternative']),
        contributors = [
          for (var contributor in json['contributors'])
            Contributor.fromJson(contributor)
        ];
}

class TrackShort {
  final int id;
  final bool readable;
  final String title, titleShort, titleVersion;
  final Duration duration;
  final int rank;
  final bool explicitLyrics;
  final String preview;
  final Artist artist;
  final Album album;

  const TrackShort(
      this.id,
      this.readable,
      this.title,
      this.titleShort,
      this.titleVersion,
      this.duration,
      this.rank,
      this.explicitLyrics,
      this.preview,
      this.artist,
      this.album);

  TrackShort.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        readable = json['readable'],
        title = json['title'],
        titleShort = json['title_short'],
        titleVersion = json['title_version'],
        duration = Duration(seconds: json['duration']),
        rank = json['rank'],
        explicitLyrics = json['explicit_lyrics'],
        preview = json['preview'],
        artist = json['artist'],
        album = json['album'];
}
