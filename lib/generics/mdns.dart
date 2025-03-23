import 'package:multicast_dns/multicast_dns.dart';

class MDnsInfo {
  final String name;
  final int port;
  final String ip;
  MDnsInfo({required this.name, required this.port, required this.ip});
  @override
  toString() => '$ip:$port (${name.trim()})';
}

Future<List<MDnsInfo>> availableServices(String name, MDnsClient client) async {
  List<MDnsInfo> records = [];
  // Use the domainName from the PTR record to get the SRV record,
  // which will have the port and local hostname.
  // Note that duplicate messages may come through, especially if any
  // other mDNS queries are running elsewhere on the machine.
  print("looking up");
  Map<String, Map<String, String>> txtRecordsByService = {};
  List<SrvResourceRecord> srvs = [];
  List<TxtResourceRecord> txts = [];

  // Fetch SRV records
  await for (final SrvResourceRecord srv
      in client.lookup<SrvResourceRecord>(ResourceRecordQuery.service(name))) {
    print('instance found at '
        '${srv.target}:${srv.port} for "$name".');
    srvs.add(srv);

    // Initialize an empty map for this service's TXT records
    String serviceKey = '${srv.target}:${srv.port}';
    txtRecordsByService[serviceKey] = {};
  }

  // Fetch TXT records
  Map<String, String> descriptions = {};
  await for (final TxtResourceRecord txt
      in client.lookup<TxtResourceRecord>(ResourceRecordQuery.text(name))) {
    txts.add(txt);

    // Parse TXT record text in format prop=val
  }
  //print("mdns.dart@availableServices: txts: ${txts.length}");
  txts.forEach((txt) {
    Map<String, String> propMap = {};
    List<String> props = txt.text.split("\n");
    props.forEach((prop) {
      if (prop.contains('=')) {
        List<String> parts = prop.split('=');
        String key = parts[0];
        String val = parts.sublist(1).join('=');
        propMap[key] = val;
      }
    });
    if (propMap.containsKey('description') && propMap.containsKey('port') && propMap.containsKey('ip')) {
      descriptions['${propMap['ip']}:${propMap['port']}'] = propMap['description'] ?? "Unnamed";
    }
  });
    

  print("up looked");

  // Create MDnsInfo objects with names from TXT records
  records = srvs.map((srv) {
    String serviceKey = '${srv.target}:${srv.port}';
    String serviceNamey = descriptions[serviceKey] ?? 'Unnamed';
    return MDnsInfo(name: serviceNamey, ip: srv.target, port: srv.port);
  }).toList();

  return records;
}
