import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../utils/duration.dart';

enum _AudioQuality {
  standard, better, hifi
}

class Player extends StatefulWidget {
  const Player({super.key});

  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  _AudioQuality _audioQuality = _AudioQuality.standard;
  final bool _hasNext = true;
  final bool _hasPrevious = false;
  bool _favorite = false;
  bool _mute = false;
  bool _normaliseSound = true;
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

  void _showQueue() {}

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
    final settingsPopupItems = <PopupMenuEntry<Never>>[
      PopupMenuItem(
        child: Text(AppLocalizations.of(context)!.audioQuality),
      ),
      PopupMenuItem(
        child: RadioListTile(
          value: _AudioQuality.standard,
          groupValue: _audioQuality,
          onChanged: (newQuality) {
            _audioQuality = newQuality!;
          },
          title: Text(AppLocalizations.of(context)!.audioQualityStandard),
        ),
      ),
      PopupMenuItem(
        child: RadioListTile(
          value: _AudioQuality.better,
          groupValue: _audioQuality,
          onChanged: null,
          title: Text(AppLocalizations.of(context)!.audioQualityBetter),
        ),
      ),
      PopupMenuItem(
        child: RadioListTile(
          value:_AudioQuality.hifi,
          groupValue: _audioQuality,
          onChanged: null,
          title: Text(AppLocalizations.of(context)!.audioQualityHighFidelity),
        ),
      ),
      const PopupMenuDivider(),
      PopupMenuItem(
        child: SwitchListTile.adaptive(
          value: _normaliseSound,
          onChanged: (normaliseSound) {
            setState((){
              _normaliseSound = normaliseSound;
            });
          },
          title: Text(AppLocalizations.of(context)!.normaliseAudio),
          subtitle: Text(AppLocalizations.of(context)!.normaliseAudioDescription),
        ),
      ),
    ];

    return Row(children: <Widget>[
      IconButton(
        icon: const Icon(Icons.skip_previous),
        tooltip: AppLocalizations.of(context)!.previous,
        onPressed: _hasPrevious ? _skipBack : null,
      ),
      IconButton(
        icon: _playing ? const Icon(Icons.pause) : const Icon(Icons.play_arrow),
        tooltip: AppLocalizations.of(context)!.play,
        onPressed: _togglePlay,
      ),
      IconButton(
        icon: const Icon(Icons.skip_next),
        tooltip: AppLocalizations.of(context)!.next,
        onPressed: _hasNext ? _skipNext : null,
      ),
      Expanded(
        flex: 1,
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          Row(children: <Widget>[
            Text(AppLocalizations.of(context)!.track),
            Text(AppLocalizations.of(context)!.artist),
            IconButton(
              icon: const Icon(Icons.lyrics),
              tooltip: AppLocalizations.of(context)!.lyrics,
              onPressed: _showLyrics,
            ),
            IconButton(
              icon: const Icon(Icons.playlist_add),
              tooltip: AppLocalizations.of(context)!.addToPlaylist,
              onPressed: _addToPlaylist,
            ),
            IconButton(
              icon: _favorite
                  ? const Icon(Icons.favorite)
                  : const Icon(Icons.favorite_border),
              tooltip: AppLocalizations.of(context)!.addToFavorite,
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
      const IconButton(
        icon: Icon(Icons.cast),
        tooltip: 'Chromecast',
        onPressed: null,
      ),
      IconButton(
        icon:
            _repeating ? const Icon(Icons.repeat_on) : const Icon(Icons.repeat),
        tooltip: AppLocalizations.of(context)!.repeat,
        onPressed: _repeat,
      ),
      IconButton(
        icon: _shuffling
            ? const Icon(Icons.shuffle_on)
            : const Icon(Icons.shuffle),
        tooltip: AppLocalizations.of(context)!.shuffle,
        onPressed: _shuffle,
      ),
      IconButton(
        icon:
            _mute ? const Icon(Icons.volume_off) : const Icon(Icons.volume_up),
        tooltip: AppLocalizations.of(context)!.volume(_volume.round()),
        onPressed: _toggleVolume,
      ),
      PopupMenuButton(
        icon: const Icon(Icons.tune),
        itemBuilder: (innerContext) => settingsPopupItems,
        tooltip: AppLocalizations.of(context)!.settings,
      ),
      TextButton.icon(
        onPressed: _showQueue,
        icon: const Icon(Icons.music_note),
        label: Text(AppLocalizations.of(context)!.queue)),
    ]);
  }
}
