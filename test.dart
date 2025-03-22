/*
import 'dart:async';
import 'package:socket_io_client/socket_io_client.dart' as IO;

void main() async {
  // Create a WebSocket client
  final MDnsClient client = MDnsClient();
  // Start the client with default options.
  await client.start();
  bool playing = false;
  var socket = IO.io('http://localhost:3000', IO.OptionBuilder()
    .setTransports(['websocket']) // Use WebSocket transport
    .build());

  // Connect to the server
  socket.on('connect', (_) {
    print('Connected to WebSocket server');
    //socket.emit("mdns:add", {"name": "dekstop-hud.wled", "port": 3000});
  });

  // Listen for 'metadata' events from the server
  socket.on('metadata', (data) {
    print('Received Metadata: $data');
  });

  // Listen for 'position' events from the server
  socket.on('position', (data) {
    print('Received Position: $data ms');
  });

  // Listen for 'playbackState' events from the server
  socket.on('playbackState', (data) {
    print('Received Playback State: $data');
    playing = data == "Playing";
  });

  // Handle WebSocket disconnect
  socket.on('disconnect', (_) {
    print('Disconnected from WebSocket server');
  });
  //Timer.periodic(Duration(seconds: 5), (timer) {
  //  print("Sending ${playing ? "pause" : "play"}");
  //  if(playing) socket.emit('pause', false);
  //  else socket.emit('play', false);
  //});
}
*/


import 'package:multicast_dns/multicast_dns.dart';
import 'lib/mdnsInfo.dart';

Future<void> main() async {
  // Parse the command line arguments.

  const String name = 'dekstop-hud.player._tcp.local';
  final MDnsClient client = MDnsClient();
  // Start the client with default options.
  await client.start();

  // Get the PTR record for the service.
  List<MDnsInfo> records = [];
  await for (final PtrResourceRecord ptr in client.lookup<PtrResourceRecord>(ResourceRecordQuery.serverPointer(name))) {
    // Use the domainName from the PTR record to get the SRV record,
    // which will have the port and local hostname.
    // Note that duplicate messages may come through, especially if any
    // other mDNS queries are running elsewhere on the machine.
    print("looking up");
    String name = "";
    String ip = "";
    int port = -1;
    await for (final SrvResourceRecord srv in client.lookup<SrvResourceRecord>(
        ResourceRecordQuery.service(ptr.domainName))) {
      // Domain name will be something like "io.flutter.example@some-iphone.local._dartobservatory._tcp.local"
      final String bundleId =
          ptr.domainName; //.substring(0, ptr.domainName.indexOf('@'));
      print('Dart observatory instance found at '
          '${srv.target}:${srv.port} for "$bundleId".');
      port = srv.port;
      ip = srv.target;
    }
    await for (final TxtResourceRecord txt in client.lookup<TxtResourceRecord>(
        ResourceRecordQuery.text(ptr.domainName))) {
      // Domain name will be something like "io.flutter.example@some-iphone.local._dartobservatory._tcp.local"
      print('name ${txt.text}');
      name = txt.text;
    }
    print("up looked");
    var mdnsInfo = MDnsInfo(name: name, ip: ip, port: port);
    records.add(mdnsInfo);
  }
  client.stop();

  print('Done.');
}
