import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:provider/provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import "providers/player_provider_list.dart";
import "providers/theme.dart";
import "player_screen.dart";
import 'dart:async';
import 'package:multicast_dns/multicast_dns.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  GetIt.instance.allowReassignment = true;
  //GetIt.instance.registerSingleton<MpdClient>(client);
  //final mpris = MPRIS();
  //final players = await mpris.getPlayers();
  //GetIt.instance.registerSingleton<MPRIS>(mpris);
  //GetIt.instance.registerSingleton<List<MPRISPlayer>>(players);
  final MDnsClient client = MDnsClient();
  await client.start();
  GetIt.instance.registerSingleton<MDnsClient>(client);
  runApp(
    ProviderScope(
      child: const App(),
    )
  );
}

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ThemeModel themeModel = ref.watch(themeHandlerProvider);
    GetIt.instance.registerSingleton(themeModel);
    return MaterialApp(
      theme: themeModel.getTheme(),
      home: ProviderListView(),
    );
  }
}
class ProviderListView extends ConsumerStatefulWidget {
  const ProviderListView({super.key});
  @override
  _ProviderListViewState createState() => _ProviderListViewState();
}

class _ProviderListViewState extends ConsumerState<ProviderListView> {
  bool appBarShown = false;
  @override
  Widget build(BuildContext context) {
    PlayerProviderListState state = ref.watch(playerProviderListProvider);
    if(state.list.isEmpty) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 8),
              Text("Searching for players"),
            ]
          ),
        ),
      );
    }
    return DefaultTabController(
      length: state.list.length,
      child: Scaffold(
        appBar: !appBarShown ? PreferredSize(preferredSize: const Size.fromHeight(64), child: InkWell(onTap: () => setState(() => appBarShown = !appBarShown))) : PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: Container(margin: const EdgeInsets.all(8),child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_upward_rounded),
                onPressed: () => setState(() => appBarShown = !appBarShown),
              ),
              SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () => ref.read(playerProviderListProvider.notifier).updateList(),
              ),
              SizedBox(width: 8),
              state.list.length > 1 ? const Text("Players Available") : Text(ref.read(state.list[0]).friendlyName),
              SizedBox(width: 8),
              if(state.list.length > 1) Expanded(child: TabBar(
                tabs: List<Widget>.generate(state.list.length, (int index) => 
                  //Tab(text: ref.read(state.list[index]).friendlyName)
                  Tab(text: ref.read(state.list[index]).friendlyName),
                ),
              )),
            ]
          ),
        )),
        body: TabBarView(
            children: List<Widget>.generate(
              state.list.length,
              (int index) => PlayerScreen(playerIndex: index)
            ).toList(),
        ),
        //ListView(
        //  children: List<Widget>.generate(state.list.length, (int index) => ListTile(
        //    title: Text(state.list[index].friendlyName),
        //    onTap: () => navigateToScreen(PlayerScreen(playerIndex: index), context),
        //  )).toList(),
        //),
      )
    );
  }
}

void navigateToScreen(Widget screen, BuildContext context) {
  Navigator.of(context).push(MaterialPageRoute(builder: (context) => screen));
}




//class PlayerProviderList extends ChangeNotifier {
//  List<PlayerInstance> _list = [];
//  List<PlayerInstance> get list => _list;
//  set list(List<PlayerInstance> value) {
//    _list = value;
//    GetIt.instance.registerSingleton<List<PlayerInstance>>(value);
//    notifyListeners();
//  }
//  PlayerProviderList(){
//    updateList();
//  }
//  void updateList() {
//    list = [];
//    MDnsClient client = GetIt.instance.get<MDnsClient>();
//    availableServices("dekstop-hud.player._tcp.local", client).then((records) => 
//      list = [...list, ...records.map((r) => MprisWSController(connectionString: "http://${r.ip}:${r.port}", friendlyName: r.name))]
//    );
//    //GetIt.instance.get<MPRIS>().getPlayers().then((value) async {
//    //  list = await Future.wait(value.map((player) async {
//    //    return FriendlyPlayer(player: player, friendlyName: await player.getIdentity());
//    //  }).toList());
//    //});
//  }
//}

//class FriendlyPlayer {
//  final MPRISPlayer player;
//  final String friendlyName;
//  const FriendlyPlayer({required this.player, required this.friendlyName});
//}


//SquigglySlider(
//  useLineThumb: true,
//  value: _value,
//  min: 0,
//  max: 30,
//  squiggleAmplitude: 7,
//  squiggleWavelength: 10,
//  squiggleSpeed: 0.1,
//  label: 'Line thumb',
//  onChanged: (double value) {
//    setState(() {
//      _value = value;
//    });
//  },
//),

