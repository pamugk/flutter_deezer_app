import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/compilation.dart';
import '../models/playable.dart';
import '../models/search.dart';
import '../models/user.dart';

Future<Album> getAlbum(int id) async {
  final response =
      await http.get(Uri.parse('https://api.deezer.com/album/$id'));

  if (response.statusCode == 200) {
    final json = await compute(jsonDecode, response.body);
    return Album.fromJson(json);
  } else {
    throw Exception('Failed to fetch album');
  }
}

Future<Artist> getArtist(int id) async {
  final response =
      await http.get(Uri.parse('https://api.deezer.com/artist/$id'));

  if (response.statusCode == 200) {
    final json = await compute(jsonDecode, response.body);
    return Artist.fromJson(json);
  } else {
    throw Exception('Failed to fetch artist');
  }
}

Future<PartialSearchResponse<Album>> getArtistAlbums(int id,
    [int index = 0, int limit = 25]) async {
  final response = await http.get(Uri.https(
      'api.deezer.com', 'artist/$id/albums', {'index': index, 'limit': limit}));

  if (response.statusCode == 200) {
    final json = await compute(jsonDecode, response.body);
    return PartialSearchResponse(
        [for (var album in json['data']) Album.fromJson(album)],
        json['total'] ?? 0,
        json['prev'],
        json['next']);
  } else {
    throw Exception('Failed to get artist albums');
  }
}

Future<PartialSearchResponse<User>> getArtistFans(int id,
    [int index = 0, int limit = 25]) async {
  final response = await http.get(Uri.https(
      'api.deezer.com', 'artist/$id/fans', {'index': index, 'limit': limit}));

  if (response.statusCode == 200) {
    final json = await compute(jsonDecode, response.body);
    return PartialSearchResponse(
        [for (var user in json['data']) User.fromJson(user)],
        json['total'] ?? 0,
        json['prev'],
        json['next']);
  } else {
    throw Exception('Failed to get artist fans');
  }
}

Future<PartialSearchResponse<Playlist>> getArtistPlaylists(int id,
    [int index = 0, int limit = 25]) async {
  final response = await http.get(Uri.https('api.deezer.com',
      'artist/$id/playlists', {'index': index, 'limit': limit}));

  if (response.statusCode == 200) {
    final json = await compute(jsonDecode, response.body);
    return PartialSearchResponse(
        [for (var playlist in json['data']) Playlist.fromJson(playlist)],
        json['total'] ?? 0,
        json['prev'],
        json['next']);
  } else {
    throw Exception('Failed to get artist playlists');
  }
}

Future<PartialSearchResponse<Track>> getArtistRadio(int id,
    [int index = 0, int limit = 25]) async {
  final response = await http.get(Uri.https(
      'api.deezer.com', 'artist/$id/radio', {'index': index, 'limit': limit}));

  if (response.statusCode == 200) {
    final json = await compute(jsonDecode, response.body);
    return PartialSearchResponse(
        [for (var track in json['data']) Track.fromJson(track)],
        json['total'] ?? 0,
        json['prev'],
        json['next']);
  } else {
    throw Exception('Failed to get artist radio');
  }
}

Future<PartialSearchResponse<Artist>> getArtistRelated(int id,
    [int index = 0, int limit = 25]) async {
  final response = await http.get(Uri.https('api.deezer.com',
      'artist/$id/related', {'index': index, 'limit': limit}));

  if (response.statusCode == 200) {
    final json = await compute(jsonDecode, response.body);
    return PartialSearchResponse([
      for (var similarArtist in json['data']) Artist.fromJson(similarArtist)
    ], json['total'] ?? 0, json['prev'], json['next']);
  } else {
    throw Exception('Failed to get artist related artists');
  }
}

Future<PartialSearchResponse<Track>> getArtistTopTracks(int id,
    [int index = 0, int limit = 25]) async {
  final response = await http.get(Uri.https(
      'api.deezer.com', 'artist/$id/top', {'index': index, 'limit': limit}));

  if (response.statusCode == 200) {
    final json = await compute(jsonDecode, response.body);
    return PartialSearchResponse(
        [for (var track in json['data']) Track.fromJson(track)],
        json['total'] ?? 0,
        json['prev'],
        json['next']);
  } else {
    throw Exception('Failed to get artist top tracks');
  }
}

Future<Chart> getChart(int id) async {
  final response =
      await http.get(Uri.parse('https://api.deezer.com/chart/$id'));

  if (response.statusCode == 200) {
    final json = await compute(jsonDecode, response.body);
    return Chart.fromJson(json);
  } else {
    throw Exception('Failed to fetch chart');
  }
}

Future<PartialSearchResponse<Album>> getChartAlbums(int id,
    [int index = 0, int limit = 25]) async {
  final response = await http.get(Uri.https(
      'api.deezer.com', 'chart/$id/albums', {'index': index, 'limit': limit}));

  if (response.statusCode == 200) {
    final json = await compute(jsonDecode, response.body);
    return PartialSearchResponse(
        [for (var album in json['data']) Album.fromJson(album)],
        json['total'] ?? 0,
        json['prev'],
        json['next']);
  } else {
    throw Exception('Failed to get chart albums');
  }
}

Future<PartialSearchResponse<Artist>> geChartArtists(int id,
    [int index = 0, int limit = 25]) async {
  final response = await http.get(Uri.https(
      'api.deezer.com', 'chart/$id/artists', {'index': index, 'limit': limit}));

  if (response.statusCode == 200) {
    final json = await compute(jsonDecode, response.body);
    return PartialSearchResponse([
      for (var similarArtist in json['data']) Artist.fromJson(similarArtist)
    ], json['total'] ?? 0, json['prev'], json['next']);
  } else {
    throw Exception('Failed to get chart artists');
  }
}

Future<PartialSearchResponse<Playlist>> getChartPlaylists(int id,
    [int index = 0, int limit = 25]) async {
  final response = await http.get(Uri.https('api.deezer.com',
      'chart/$id/playlists', {'index': index, 'limit': limit}));

  if (response.statusCode == 200) {
    final json = await compute(jsonDecode, response.body);
    return PartialSearchResponse(
        [for (var playlist in json['data']) Playlist.fromJson(playlist)],
        json['total'] ?? 0,
        json['prev'],
        json['next']);
  } else {
    throw Exception('Failed to get chart playlists');
  }
}

Future<PartialSearchResponse<Track>> getChartTracks(int id,
    [int index = 0, int limit = 25]) async {
  final response = await http.get(Uri.https(
      'api.deezer.com', 'chart/$id/tracks', {'index': index, 'limit': limit}));

  if (response.statusCode == 200) {
    final json = await compute(jsonDecode, response.body);
    return PartialSearchResponse(
        [for (var track in json['data']) Track.fromJson(track)],
        json['total'] ?? 0,
        json['prev'],
        json['next']);
  } else {
    throw Exception('Failed to get chart tracks');
  }
}

Future<Chart> getDefaultChart() async {
  final response = await http.get(Uri.parse('https://api.deezer.com/chart'));

  if (response.statusCode == 200) {
    final json = await compute(jsonDecode, response.body);
    return Chart.fromJson(json);
  } else {
    throw Exception('Failed to fetch chart');
  }
}

Future<Editorial> getEditorial(int id) async {
  final response =
      await http.get(Uri.parse('https://api.deezer.com/editorial/$id'));

  if (response.statusCode == 200) {
    final json = await compute(jsonDecode, response.body);
    return Editorial.fromJson(json);
  } else {
    throw Exception('Failed to fetch editorial');
  }
}

Future<List<Editorial>> getEditorialList() async {
  final response =
      await http.get(Uri.parse('https://api.deezer.com/editorial'));

  if (response.statusCode == 200) {
    final json = await compute(jsonDecode, response.body);
    return json['data'] == null
        ? []
        : [for (var editorial in json['data']) Editorial.fromJson(editorial)];
  } else {
    throw Exception('Failed to fetch editorials');
  }
}

Future<Genre> getGenre(int id) async {
  final response =
      await http.get(Uri.parse('https://api.deezer.com/genre/$id'));

  if (response.statusCode == 200) {
    final json = await compute(jsonDecode, response.body);
    return Genre.fromJson(json);
  } else {
    throw Exception('Failed to fetch genre');
  }
}

Future<List<Genre>> getGenres() async {
  final response = await http.get(Uri.parse('https://api.deezer.com/genre'));

  if (response.statusCode == 200) {
    final json = await compute(jsonDecode, response.body);
    return json['data'] == null
        ? []
        : [for (var genre in json['data']) Genre.fromJson(genre)];
  } else {
    throw Exception('Failed to fetch genres');
  }
}

Future<Playlist> getPlaylist(int id) async {
  final response =
      await http.get(Uri.parse('https://api.deezer.com/playlist/$id'));

  if (response.statusCode == 200) {
    final json = await compute(jsonDecode, response.body);
    return Playlist.fromJson(json);
  } else {
    throw Exception('Failed to fetch playlist');
  }
}

Future<Track> getTrack(int id) async {
  final response =
      await http.get(Uri.parse('https://api.deezer.com/track/$id'));

  if (response.statusCode == 200) {
    final json = await compute(jsonDecode, response.body);
    return Track.fromJson(json);
  } else {
    throw Exception('Failed to fetch track');
  }
}

Future<User> getUser(int id) async {
  final response = await http.get(Uri.parse('https://api.deezer.com/user/$id'));

  if (response.statusCode == 200) {
    final json = await compute(jsonDecode, response.body);
    return User.fromJson(json);
  } else {
    throw Exception('Failed to fetch user');
  }
}

Future<PartialSearchResponse<Album>> searchAlbums(String query,
    [int index = 0, int limit = 25, bool strict = false]) async {
  final response = await http.get(Uri.https('api.deezer.com', 'search/album', {
    'q': query,
    'index': index,
    'limit': limit,
    'strict': strict ? 'on' : 'off'
  }));

  if (response.statusCode == 200) {
    final json = await compute(jsonDecode, response.body);
    return PartialSearchResponse(
        [for (var album in json['data']) Album.fromJson(album)],
        json['total'] ?? 0,
        json['prev'],
        json['next']);
  } else {
    throw Exception('Failed to search albums');
  }
}

Future<PartialSearchResponse<Artist>> searchArtists(String query,
    [int index = 0, int limit = 25, bool strict = false]) async {
  final response = await http.get(Uri.https('api.deezer.com', 'search/artist', {
    'q': query,
    'index': index,
    'limit': limit,
    'strict': strict ? 'on' : 'off'
  }));

  if (response.statusCode == 200) {
    final json = await compute(jsonDecode, response.body);
    return PartialSearchResponse(
        [for (var artist in json['data']) Artist.fromJson(artist)],
        json['total'] ?? 0,
        json['prev'],
        json['next']);
  } else {
    throw Exception('Failed to search artists');
  }
}

Future<PartialSearchResponse<Playlist>> searchPlaylists(String query,
    [int index = 0, int limit = 25, bool strict = false]) async {
  final response = await http.get(Uri.https(
      'api.deezer.com', 'search/playlist', {
    'q': query,
    'index': index,
    'limit': limit,
    'strict': strict ? 'on' : 'off'
  }));

  if (response.statusCode == 200) {
    final json = await compute(jsonDecode, response.body);
    return PartialSearchResponse(
        [for (var playlist in json['data']) Playlist.fromJson(playlist)],
        json['total'] ?? 0,
        json['prev'],
        json['next']);
  } else {
    throw Exception('Failed to search playlists');
  }
}

Future<PartialSearchResponse<Track>> searchTracks(String query,
    [int index = 0, int limit = 25, bool strict = false]) async {
  final response = await http.get(Uri.https('api.deezer.com', 'search/track', {
    'q': query,
    'index': index,
    'limit': limit,
    'strict': strict ? 'on' : 'off'
  }));

  if (response.statusCode == 200) {
    final json = await compute(jsonDecode, response.body);
    return PartialSearchResponse(
        [for (var track in json['data']) Track.fromJson(track)],
        json['total'] ?? 0,
        json['prev'],
        json['next']);
  } else {
    throw Exception('Failed to search tracks');
  }
}

Future<PartialSearchResponse<User>> searchUsers(String query,
    [int index = 0, int limit = 25, bool strict = false]) async {
  final response = await http.get(Uri.https('api.deezer.com', 'search/user', {
    'q': query,
    'index': index,
    'limit': limit,
    'strict': strict ? 'on' : 'off'
  }));

  if (response.statusCode == 200) {
    final json = await compute(jsonDecode, response.body);
    return PartialSearchResponse(
        [for (var user in json['data']) User.fromJson(user)],
        json['total'] ?? 0,
        json['prev'],
        json['next']);
  } else {
    throw Exception('Failed to search users');
  }
}
