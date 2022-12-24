import 'search.dart';

class Album {
    int id;
    String title;
    String upc;
    String cover;
    String cover_small;
    String cover_medium;
    String cover_big;
    String cover_xl;
    SearchResponse<Genre> genres;
    String label;
    int nb_tracks;
    int duration;
    int fans;
    int rating;
    DateTime release_date;
    String record_type;
    bool available;
    Album? alternative;
    String tracklist;
    bool explicit_lyrics;
    int explicit_content_lyrics;
    int explicit_content_cover;
    List<Contributor> contributors;
    Artist artist;
    SearchResponse<Track> tracks;
}

class Artist {
    int id;
    String name;
    String picture;
    String picture_small;
    String picture_medium;
    String picture_big;
    String picture_xl;
    int nb_album;
    int nb_fan;
    bool radio;
    String tracklist;
}

class Contributor {
    int id;
}

class Genre {
    int id;
    String name;
    String picture;
    String picture_small;
    String picture_medium;
    String picture_big;
    String picture_xl;
}

class Playlist {
    int id;
    String title;
    String description;
    int duration;
    bool public;
    bool is_loved_track;
    bool collaborative;
    int rating;
    int nb_tracks;
    int unseen_track_count;
    int fans;
    String picture;
    String picture_small;
    String picture_medium;
    String picture_big;
    String picture_xl;
    String checksum;
    User creator;
    SearchResponse<Track> tracks;
}

class Radio {
    int id;
    String title;
    String description;
    String picture;
    String picture_small;
    String picture_medium;
    String picture_big;
    String picture_xl;
    String tracklist;
}

class Track extends TrackShort {
    bool unseen;
    String isrc;
    int track_position;
    int disk_number;
    DateTime release_date;
    int explicit_content_lyrics;
    int explicit_content_cover;
    double bpm;
    double gain;
    List<String> available_countries;
    Track? alternative;
    List<Contributor> contributors;
}

class TrackShort {
    int id;
    bool readable;
    String title;
    String title_short;
    String title_version;
    int duration;
    int rank;
    bool explicit_lyrics;
    String preview;
    Artist artist;
    Album album;
}

class User {
    int id;
    String name;
    String lastname;
    String firstname;
    String email;
    int status;
    DateTime birthday;
    DateTime inscription_date;
    String gender;
    String link;
    String picture;
    String picture_small;
    String picture_medium;
    String picture_big;
    String picture_xl;
    String country;
    String lang;
    bool is_kid;
    String explicit_content_level;
    String[] explicit_content_levels_available;
    String tracklist;
}
