import 'user.dart';

class Album extends AlbumShort {
  final String share;
  final String upc;

  final List<Genre> genres;
  final String? label;
  final int trackCount;
  final Duration duration;
  final int fanCount;
  final int? rating;
  final DateTime releaseDate;
  final String recordType;
  final bool available;
  final Album? alternative;

  final bool explicitLyrics;
  final int explicitContentLyrics, explicitContentCover;

  final List<Contributor> contributors;
  final Artist artist;
  //final List<Track>? tracks;

  const Album(
    super.id,
    super.title,
    this.upc,
    this.share,
    super.cover,
    super.coverSmall,
    super.coverMedium,
    super.coverBig,
    super.coverXl,
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
    super.tracklist,
    this.explicitLyrics,
    this.explicitContentLyrics,
    this.explicitContentCover,
    this.contributors,
    this.artist,
  );

  Album.fromJson(Map<String, dynamic> json)
      : upc = json['upc'],
        share = json['share'],
        genres = [
          for (var genre in json['genres']['data']) Genre.fromJson(genre)
        ],
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
        explicitLyrics = json['explicit_lyrics'],
        explicitContentLyrics = json['explicit_content_lyrics'],
        explicitContentCover = json['explicit_content_cover'],
        contributors = [
          for (var contributor in json['contributors'])
            Contributor.fromJson(contributor)
        ],
        artist = Artist.fromJson(json['artist']),
        //tracks = json['tracks'] == null
        //    ? null
        //    : [for (var track in json['tracks']['data']) Track.fromJson(track)],
        super.fromJson(json);
}

class AlbumShort {
  final int id;
  final String title;
  final String cover, coverSmall, coverMedium, coverBig, coverXl;
  final String tracklist;

  const AlbumShort(this.id, this.title, this.cover, this.coverSmall,
      this.coverMedium, this.coverBig, this.coverXl, this.tracklist);

  AlbumShort.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        cover = json['cover'],
        coverSmall = json['cover_small'],
        coverMedium = json['cover_medium'],
        coverBig = json['cover_big'],
        coverXl = json['cover_xl'],
        tracklist = json['tracklist'];
}

class Artist extends ArtistShort {
  final String picture, pictureSmall, pictureMedium, pictureBig, pictureXl;
  final int? albumCount;
  final int? fanCount;
  final bool? radio;

  const Artist(
      super.id,
      super.name,
      this.picture,
      this.pictureSmall,
      this.pictureMedium,
      this.pictureBig,
      this.pictureXl,
      this.albumCount,
      this.fanCount,
      this.radio,
      super.tracklist);

  Artist.fromJson(Map<String, dynamic> json)
      : picture = json['picture'],
        pictureSmall = json['picture_small'],
        pictureMedium = json['picture_medium'],
        pictureBig = json['picture_big'],
        pictureXl = json['picture_xl'],
        albumCount = json['nb_album'],
        fanCount = json['nb_fan'],
        radio = json['radio'],
        super.fromJson(json);
}

class ArtistShort {
  final int id;
  final String name;
  final String tracklist;

  const ArtistShort(this.id, this.name, this.tracklist);

  ArtistShort.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        tracklist = json['tracklist'];
}

class Contributor {
  final int id;
  final String name;
  final String link, share;
  final String picture, pictureSmall, pictureMedium, pictureBig, pictureXl;

  const Contributor(this.id, this.name, this.link, this.share, this.picture,
      this.pictureSmall, this.pictureMedium, this.pictureBig, this.pictureXl);

  Contributor.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        link = json['link'],
        share = json['share'],
        picture = json['picture'],
        pictureSmall = json['picture_small'],
        pictureMedium = json['picture_medium'],
        pictureBig = json['picture_big'],
        pictureXl = json['picture_xl'];
}

class Genre {
  final int id;
  final String name;
  final String picture;
  final String? pictureSmall, pictureMedium, pictureBig, pictureXl;

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
  final String? description;
  final Duration? duration;
  final bool public;
  final bool? favorite;
  final bool? collaborative;
  final int? rating;
  final int? trackCount;
  final int? unseenTrackCount;
  final int? fanCount;
  final String picture, pictureSmall, pictureMedium, pictureBig, pictureXl;
  final String checksum;
  final UserShort? creator;
  final List<TrackShort>? tracks;

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
        duration = json['duration'] == null
            ? null
            : Duration(seconds: json['duration']),
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
        creator = json['creator'] == null
            ? null
            : UserShort.fromJson(json['creator']),
        tracks = json['tracks'] == null
            ? null
            : [
                for (var track in json['tracks']['data'])
                  TrackShort.fromJson(track)
              ];
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
  final bool? unseen;
  final String isrc;
  final int position;
  final int diskNumber;
  final DateTime? releaseDate;
  final int explicitContentLyrics, explicitContentCover;
  final double? bpm;
  final double? gain;
  final List<String>? availableCountries;
  final Track? alternative;
  final List<Contributor>? contributors;

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
      : unseen = json['unseen'],
        isrc = json['isrc'],
        position = json['track_position'],
        diskNumber = json['disk_number'],
        releaseDate = json['release_date'] == null
            ? null
            : DateTime.parse(json['release_date']),
        explicitContentLyrics = json['explicit_content_lyrics'],
        explicitContentCover = json['explicit_content_cover'],
        bpm = json['bpm'],
        gain = json['gain'],
        availableCountries = json['available_countries'],
        alternative = json['alternative'] == null
            ? null
            : Track.fromJson(json['alternative']),
        contributors = json['contributors'] == null
            ? null
            : [
                for (var contributor in json['contributors'])
                  Contributor.fromJson(contributor)
              ],
        super.fromJson(json);
}

class TrackShort {
  final int id;
  final bool readable;
  final String title;
  final String? titleShort, titleVersion;
  final Duration duration;
  final int rank;
  final bool explicitLyrics;
  final String? preview;
  final ArtistShort artist;
  final AlbumShort? album;

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
        artist = ArtistShort.fromJson(json['artist']),
        album =
            json['album'] == null ? null : AlbumShort.fromJson(json['album']);
}
