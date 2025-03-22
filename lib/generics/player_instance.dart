import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:get_it/get_it.dart';
import '../generics/mdns.dart';
part 'player_instance.g.dart';
part 'player_instance.freezed.dart';

@freezed
class PlayerState with _$PlayerState {
  const PlayerState._();
  const factory PlayerState({
    required String title,
    required String artist,
    required String album,
    required String imageUrl,
    required Duration duration,
    required Duration position,
    required String friendlyName,
    required PlaybackState playbackState,
    required ConnectionState connectionState,
  }) = _PlayerState;
  factory PlayerState.notPlaying() => const PlayerState(
    title: "",
    artist: "",
    album: "",
    imageUrl: "",
    position: Duration.zero,
    duration: Duration.zero,
    playbackState: PlaybackState.stopped,
    connectionState: ConnectionState.disconnected,
    friendlyName: "",
  );
  String get friendlyPosition => (position.inHours > 0 ? position.inHours.toString() + ":" : "") + position.inMinutes.toString() + ":" + (position.inSeconds - (position.inMinutes*60)).toString().padLeft(2, "0");
  String get friendlyDuration => (duration.inHours > 0 ? duration.inHours.toString() + ":" : "") + duration.inMinutes.toString() + ":" + (duration.inSeconds - (duration.inMinutes*60)).toString().padLeft(2, "0");
  double get progress => duration.inMilliseconds == 0 ? 0 : position.inMilliseconds.toDouble() / (duration.inMilliseconds ?? 0);
  bool get isPlaying => playbackState == PlaybackState.playing;
  bool get isPaused => playbackState == PlaybackState.paused;
  bool get isStopped => playbackState == PlaybackState.stopped;
}

@Riverpod(keepAlive:true)
class NetworkPlayer extends _$NetworkPlayer {
  late IO.Socket socket;
  bool inited = false;
  bool debug = false;

  void init({required String connectionString, required String friendlyName}) {
    if (inited) return;
    state = state.copyWith(friendlyName: friendlyName);
    socket = IO.io(connectionString, IO.OptionBuilder().setTransports(['websocket']).build());
    state = state.copyWith(connectionState: ConnectionState.connecting);
    socket.on('connect', (_) {
      if(debug) print('MprisWSController: Connected to WebSocket server @ $connectionString');
      state = state.copyWith(connectionState: ConnectionState.connected);
    });
    socket.on('disconnect', (_) {
      if(debug) print('MprisWSController: Disconnected from WebSocket server');
      state = state.copyWith(connectionState: ConnectionState.disconnected);
    });
    //socket.on('friendlyName', (data) {
    //  if(debug) print('MprisWSController: Received Friendly Name: $data');
    //  state = state.copyWith(friendlyName: data);
    //});
    /*
    flutter: MprisWSController: Received Metadata: "{title: The Largest Black Hole, album: Kurzgesagt, Vol. 8 (Original Motion Picture Soundtrack), artist: Epic Mounta, imageUrl: https://i.scdn.co/image/ab67616d0000b2738c34918f736c985abfe1be01, length: {value: 657.345, unit: s}, trackId: 288ELeSdlPJhzLfhWkGaZQ}"
*/
    socket.on('metadata', (data) {
      if(debug) print('MprisWSController: Received Metadata: "$data"');
      Duration d = Duration(milliseconds: (data["length"]["value"]*1000).toInt());
      state = state.copyWith(
        title: data["title"],
        artist: data["artist"],
        album: data["album"],
        imageUrl: data["imageUrl"],
        duration: d,
      );
    });
    socket.on('position', (data) {
      if(debug) print('MprisWSController: Received Position: $data ms');
      state = state.copyWith(position: Duration(milliseconds: data));
    });
    socket.on('playbackState', (data) {
      if(debug) print('MprisWSController: Received Playback State: "$data"');
      var playbackState = data.toString().toLowerCase();
      state = state.copyWith(playbackState: switch(playbackState) {
        "playing" => PlaybackState.playing,
        "paused" => PlaybackState.paused,
        "stopped" => PlaybackState.stopped,
        _ => PlaybackState.stopped
      });
    });
    inited = true;
  }

  play() {
    socket.emit("play");
  }

  pause() {
    socket.emit("pause");
  }

  next() {
    socket.emit("next");
  }

  previous() {
    socket.emit("previous");
  }

  toggle() {
    if(state.isPlaying) pause();
    else play();
  }

  seekTo(int inMillis) {
    socket.emit("seek", inMillis);
  }

  @override
  PlayerState build() {
    return PlayerState.notPlaying();
  }
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
enum ConnectionState { connecting, connected, disconnected }
