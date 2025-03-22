import 'package:flutter/material.dart';
abstract class PlayerInstance extends ChangeNotifier {
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  Duration get duration => _duration;
  Duration get position => _position;
  set duration(Duration duration) {
    print("duration: ${duration.inSeconds}");
    _duration = duration;
    notifyListeners();
  }
  set position(Duration position) {
    _position = position;
    notifyListeners();
  }

  PlayerMetadata? _currentSong;
  PlayerMetadata? get currentSong => _currentSong;
  set currentSong(PlayerMetadata? song) {
    _currentSong = song;
    notifyListeners();
  }

  PlaybackState _playbackState = PlaybackState.stopped;
  PlaybackState get playbackState => _playbackState;
  set playbackState(PlaybackState state) {
    _playbackState = state;
    notifyListeners();
  }
  String friendlyName = "";
  String get friendlyPosition => (position.inHours > 0 ? position.inHours.toString() + ":" : "") + position.inMinutes.toString() + ":" + (position.inSeconds - (position.inMinutes*60)).toString().padLeft(2, "0");
  String get friendlyDuration => (duration.inHours > 0 ? duration.inHours.toString() + ":" : "") + duration.inMinutes.toString() + ":" + (duration.inSeconds - (duration.inMinutes*60)).toString().padLeft(2, "0");
  double get progress => duration.inMilliseconds == 0 ? 0 : position.inMilliseconds.toDouble() / (duration.inMilliseconds ?? 0);
  bool get isPlaying => playbackState == PlaybackState.playing;
  //PlayerInstance({required this.friendlyName});
  Future<void> init();
  void play();
  void pause();
  void next();
  void previous();
  void seekTo(int inMillis);
  void toggle(){if(isPlaying){pause();}else{play();}}
}

class PlayerMetadata {
  final String title;
  final String artist;
  final String album;
  final Duration duration;
  final String imageUrl;
  const PlayerMetadata({required this.title, required this.artist, required this.album, required this.duration, required this.imageUrl});
}
enum PlaybackState { stopped, paused, playing }
