import 'package:flutter/material.dart';

class Player extends StatelessWidget {
  const Player({super.key});

  void _addToPlaylist() {

  }

  void _onSeek(double newPosition) {

  }

  void _repeat() {

  }

  void _showLyrics() {

  }

  void _showSettings() {

  }

  void _shuffle() {

  }

  void _skipBack() {

  }

  void _skipNext() {

  }

  void _togglePlay() {

  }

  void _toggleVolume() {

  }

  @override
  Widget build(BuildContext context) {
      return Row(
        children: <Widget>[
          IconButton(
            icon: const Icon(Icons.skip_previous),
            tooltip: 'Предыдущий',
            onPressed: _skipBack,
          ),
          IconButton(
            icon: const Icon(Icons.play_arrow),
            tooltip: 'Воспроизвести',
            onPressed: _togglePlay,
          ),
          IconButton(
            icon: const Icon(Icons.skip_next),
            tooltip: 'Следующий',
            onPressed: _skipNext,
          ),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text('Трек'),
                    Text('Исполнитель'),
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
                      icon: const Icon(Icons.favorite_border),
                      tooltip: 'Добавить в избранное',
                      onPressed: _addToPlaylist,
                    ),
                  ]
                ),
                Row(
                  children: <Widget>[
                    Text('00:00'),
                    Expanded(
                      flex: 1,
                      child: Slider(
                        value: 0,
                        min: 0,
                        max: 239,
                        label: '00:00',
                        onChanged: _onSeek,
                      ),
                    ),
                    Text('03:59'),
                  ]
                ),
              ]
            ),
          ),
          IconButton(
            icon: const Icon(Icons.replay),
            tooltip: 'Повторять',
            onPressed: _repeat,
          ),
          IconButton(
            icon: const Icon(Icons.shuffle),
            tooltip: 'Перемешать',
            onPressed: _shuffle,
          ),
          IconButton(
            icon: const Icon(Icons.volume_up),
            tooltip: 'Громкость: 100',
            onPressed: _toggleVolume,
          ),
          IconButton(
            icon: const Icon(Icons.tune),
            tooltip: 'Настройки',
            onPressed: _showSettings,
          ),
        ]
      );
  }
}
