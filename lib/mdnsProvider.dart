//import 'package:multicast_dns/multicast_dns.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'playerobject.dart';
import 'package:get_it/get_it.dart';
import 'mdnsInfo.dart';
//import 'package:flutter/material.dart';

class MprisWSController extends PlayerInstance {
  String connectionString;
  String friendlyName;
  late IO.Socket socket;
  MprisWSController({required this.connectionString, required this.friendlyName}) {
    socket = IO.io(connectionString, IO.OptionBuilder().setTransports(['websocket']).build());
    socket.on('connect', (_) {
      print('MprisWSController: Connected to WebSocket server @ $connectionString');
    });
    socket.on('friendlyName', (data) {
      print('MprisWSController: Received Friendly Name: $data');
      friendlyName = data;
    });
    /*
    flutter: MprisWSController: Received Metadata: "{title: The Largest Black Hole, album: Kurzgesagt, Vol. 8 (Original Motion Picture Soundtrack), artist: Epic Mounta, imageUrl: https://i.scdn.co/image/ab67616d0000b2738c34918f736c985abfe1be01, length: {value: 657.345, unit: s}, trackId: 288ELeSdlPJhzLfhWkGaZQ}"
*/
    socket.on('metadata', (data) {
      print('MprisWSController: Received Metadata: "$data"');
      Duration d = Duration(milliseconds: (data["length"]["value"]*1000).toInt());
      currentSong = PlayerMetadata(
        title: data["title"],
        artist: data["artist"],
        album: data["album"],
        imageUrl: data["imageUrl"],
        duration: d,
      );
      duration = d;
    });
    socket.on('position', (data) {
      print('MprisWSController: Received Position: $data ms');
      position  = Duration(milliseconds: data);
    });
    socket.on('playbackState', (data) {
      print('MprisWSController: Received Playback State: "$data"');
      var state = data.toString().toLowerCase();
      playbackState = switch(state) {
        "playing" => PlaybackState.playing,
        "paused" => PlaybackState.paused,
        "stopped" => PlaybackState.stopped,
        _ => PlaybackState.stopped
      };
    });
    socket.on('disconnect', (_) {
      print('MprisWSController: Disconnected from WebSocket server');
    });
  }

  @override
  Future<void> init() async {
  }

  @override
  play() {
    socket.emit("play");
  }

  @override
  pause() {
    socket.emit("pause");
  }

  @override
  next() {
    socket.emit("next");
  }

  @override
  previous() {
    socket.emit("previous");
  }

  @override
  seekTo(int inMillis) {
    socket.emit("seek", inMillis);
  }
}
/*
await for (final PtrResourceRecord ptr in client
      .lookup<PtrResourceRecord>(ResourceRecordQuery.serverPointer(name))) {
    // Use the domainName from the PTR record to get the SRV record,
    // which will have the port and local hostname.
    // Note that duplicate messages may come through, especially if any
    // other mDNS queries are running elsewhere on the machine.
    await for (final SrvResourceRecord srv in client.lookup<SrvResourceRecord>(
        ResourceRecordQuery.service(ptr.domainName))) {
      // Domain name will be something like "io.flutter.example@some-iphone.local._dartobservatory._tcp.local"
      final String bundleId =
          ptr.domainName; //.substring(0, ptr.domainName.indexOf('@'));
      print('Dart observatory instance found at '
          '${srv.target}:${srv.port} for "$bundleId".');
    }
  }
*/
