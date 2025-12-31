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
  List<MDnsInfo> foundList = [];
    await for (final PtrResourceRecord ptr in client.lookup<PtrResourceRecord>(ResourceRecordQuery.serverPointer("_$name._tcp.local"))) {
      // Use the domainName from the PTR record to get the SRV record,
      // which will have the port and local hostname.
      // Note that duplicate messages may come through, especially if any
      // other mDNS queries are running elsewhere on the machine.
      await for (final SrvResourceRecord srv in
        client.lookup<SrvResourceRecord>(ResourceRecordQuery.service(ptr.domainName))
      ) {
        // Domain name will be something like "io.flutter.example@some-iphone.local._dartobservatory._tcp.local"
        final String bundleId = ptr.domainName; //.substring(0, ptr.domainName.indexOf('@'));
        print('instance found at '
          '${srv.target}:${srv.port} for "$bundleId".');
        
        // Now we look up the IP because it gives us the hostname :rolling-eyes:
        await for (final IPAddressResourceRecord ipRec in
          client.lookup<IPAddressResourceRecord>(ResourceRecordQuery.addressIPv4(srv.target))
        ) {
          String ip = ipRec.address.address;
          print("Found ip as ${ip} for ${srv.target}!");

          var obj = MDnsInfo(ip: ip, port: srv.port, name: srv.target.split(".")[0]);
          // var foundList = found.value;
          foundList.add(obj);
          // found.value = foundList;
        }
      }
    
  }
  /*
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

  return records;*/
  return foundList;
}
