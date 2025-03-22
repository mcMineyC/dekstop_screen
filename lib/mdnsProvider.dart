//import 'package:multicast_dns/multicast_dns.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'playerobject.dart';
import 'package:get_it/get_it.dart';
import 'mdnsInfo.dart';
//import 'package:flutter/material.dart';

class MprisWSController extends PlayerInstance {
  String connectionString;
  late IO.Socket socket;
  MprisWSController({required this.connectionString}){
    socket = IO.io(connectionString, IO.OptionBuilder().setTransports(['websocket']).build());
    socket.on('connect', (_) {
      print('MprisWSController: Connected to WebSocket server @ $connectionString');
    });
    socket.on('friendlyName', (data) {
      print('MprisWSController: Received Friendly Name: $data');
      friendlyName = data;
    });
    socket.on('metadata', (data) {
      print('MprisWSController: Received Metadata: "$data"');
    });
    socket.on('position', (data) {
      print('MprisWSController: Received Position: $data ms');
    });
    socket.on('playbackState', (data) {
      print('MprisWSController: Received Playback State: "$data"');
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
