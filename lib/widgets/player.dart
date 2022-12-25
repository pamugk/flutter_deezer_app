import 'package:flutter/material.dart';

import '../utils/duration.dart';

class Player extends StatefulWidget {
  const Player({super.key});

  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  final bool _hasNext = true;
  final bool _hasPrevious = false;
  bool _favorite = false;
  bool _mute = false;
  bool _playing = false;
  bool _repeating = false;
  bool _shuffling = false;
  final double _trackDuration = 239;
  double _trackPosition = 0;
  final double _volume = 100;

  void _addToFavorite() {
    setState(() {
      _favorite = !_favorite;
    });
  }

  void _addToPlaylist() {}

  void _onSeek(double newPosition) {
    setState(() {
      _trackPosition = newPosition;
    });
  }

  void _repeat() {
    setState(() {
      _repeating = !_repeating;
    });
  }

  void _showLyrics() {}

  void _showSettings() {}

  void _shuffle() {
    setState(() {
      _shuffling = !_shuffling;
    });
  }

  void _skipBack() {}

  void _skipNext() {}

  void _togglePlay() {
    setState(() {
      _playing = !_playing;
    });
  }

  void _toggleVolume() {
    setState(() {
      _mute = !_mute;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      IconButton(
        icon: const Icon(Icons.skip_previous),
        tooltip: 'Предыдущий',
        onPressed: _hasPrevious ? _skipBack : null,
      ),
      IconButton(
        icon: _playing ? const Icon(Icons.pause) : const Icon(Icons.play_arrow),
        tooltip: 'Воспроизвести',
        onPressed: _togglePlay,
      ),
      IconButton(
        icon: const Icon(Icons.skip_next),
        tooltip: 'Следующий',
        onPressed: _hasNext ? _skipNext : null,
      ),
      Expanded(
        flex: 1,
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          Row(children: <Widget>[
            const Text('Трек'),
            const Text('Исполнитель'),
            IconButton(
              icon: const Icon(Icons.lyrics),
              tooltip: 'Текст песни',
              onPressed: _showLyrics,
            ),
            IconButton(
              icon: const Icon(Icons.playlist_add),
              tooltip: 'Добавить в плейлист',
              onPressed: _addToPlaylist,
            ),
            IconButton(
              icon: _favorite
                  ? const Icon(Icons.favorite)
                  : const Icon(Icons.favorite_border),
              tooltip: 'Добавить в избранное',
              onPressed: _addToFavorite,
            ),
          ]),
          Row(children: <Widget>[
            Text(formatSecondsDuration(_trackPosition.round())),
            Expanded(
              flex: 1,
              child: Slider(
                value: _trackPosition,
                min: 0,
                max: _trackDuration,
                onChanged: _onSeek,
              ),
            ),
            Text(formatSecondsDuration(_trackDuration.round())),
          ]),
        ]),
      ),
      IconButton(
        icon:
            _repeating ? const Icon(Icons.repeat_on) : const Icon(Icons.repeat),
        tooltip: 'Повторять',
        onPressed: _repeat,
      ),
      IconButton(
        icon: _shuffling
            ? const Icon(Icons.shuffle_on)
            : const Icon(Icons.shuffle),
        tooltip: 'Перемешать',
        onPressed: _shuffle,
      ),
      IconButton(
        icon:
            _mute ? const Icon(Icons.volume_off) : const Icon(Icons.volume_up),
        tooltip: 'Громкость: ${_volume.round()}',
        onPressed: _toggleVolume,
      ),
      IconButton(
        icon: const Icon(Icons.tune),
        tooltip: 'Настройки',
        onPressed: _showSettings,
      ),
    ]);
  }
}
