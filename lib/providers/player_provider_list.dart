import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:freezed_annotation/freezed_annotation.dart";
import "package:get_it/get_it.dart";
import "../generics/mdns.dart";
import "package:multicast_dns/multicast_dns.dart";
import "../generics/player_instance.dart";
part 'player_provider_list.g.dart';
part 'player_provider_list.freezed.dart';

@freezed
class PlayerProviderListState with _$PlayerProviderListState {
  factory PlayerProviderListState({
    required List<NotifierProviderImpl> list,
    required bool loading,
    required int selected,
  }) = _PlayerProviderListState;
}

@Riverpod(keepAlive: true)
class PlayerProviderList extends _$PlayerProviderList {
  @override
  PlayerProviderListState build() {
    Future.delayed(Duration(milliseconds: 100)).then((_) => updateList().then((_) => print("PlayerProviderList@build: Updated list")));
    return PlayerProviderListState(list: [], loading: true, selected: -1);
  }
  Future<void> updateList() async {
    state = state.copyWith(loading: true, list: []);
    discoverRemote().then((list) => state = state.copyWith(loading: false, list: [...state.list, ...list]));
  }
  Future<List<NotifierProviderImpl>> discoverRemote({String serviceName = "dekstop-hud.player._tcp.local"}) async {
    var client = GetIt.instance.get<MDnsClient>();
    List<MDnsInfo> records = await availableServices(serviceName, client);
    var list = records.map((r) {
      print("PlayerProviderList@discoverRemote: Found player ${r.name} at ${r.ip}:${r.port}");
      var p = NotifierProvider<NetworkPlayer, PlayerState>(() => NetworkPlayer());
      ref.read(p.notifier).init(
        connectionString: "http://${r.ip}:${r.port}",
        friendlyName: r.name,
      );
      return p;
    }).toList();
    print("PlayerProviderList@discoverRemote: Found ${list.length} players");
    return list;
  }
}
