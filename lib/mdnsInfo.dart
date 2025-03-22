import 'package:multicast_dns/multicast_dns.dart';
class MDnsInfo {
  final String name;
  final int port;
  final String ip;
  MDnsInfo({required this.name, required this.port, required this.ip});
}
Future<List<MDnsInfo>> availableServices(String name, MDnsClient client) async {
    List<MDnsInfo> records = [];
  await for (final PtrResourceRecord ptr in client.lookup<PtrResourceRecord>(ResourceRecordQuery.serverPointer(name))) {
    // Use the domainName from the PTR record to get the SRV record,
    // which will have the port and local hostname.
    // Note that duplicate messages may come through, especially if any
    // other mDNS queries are running elsewhere on the machine.
    print("looking up");
    String serviceName = "";
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
      serviceName = txt.text;
    }
    print("up looked");
    var mdnsInfo = MDnsInfo(name: serviceName, ip: ip, port: port);
    records.add(mdnsInfo);
  }
  return records;
}
