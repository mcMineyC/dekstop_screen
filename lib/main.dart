import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:provider/provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import "generics/mdns.dart";
import "providers/player_provider_list.dart";
import "providers/theme.dart";
import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:squiggly_slider/slider.dart';
import 'package:marquee/marquee.dart';
import 'package:multicast_dns/multicast_dns.dart';
import 'generics/player_instance.dart';

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
        appBar: AppBar(
          title: const Text("Players Available"),
          leading: IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(playerProviderListProvider.notifier).updateList(),
          ),
          bottom: TabBar(
            tabs: List<Widget>.generate(state.list.length, (int index) => 
              //Tab(text: ref.read(state.list[index]).friendlyName)
              Tab(text: ref.read(state.list[index]).friendlyName),
            ),
          ),
        ),
        body: TabBarView(
            children: List<Widget>.generate(
              state.list.length,
              (int index) => MprisScreen(playerIndex: index)
            ).toList(),
        ),
        //ListView(
        //  children: List<Widget>.generate(state.list.length, (int index) => ListTile(
        //    title: Text(state.list[index].friendlyName),
        //    onTap: () => navigateToScreen(MprisScreen(playerIndex: index), context),
        //  )).toList(),
        //),
      )
    );
  }
}

void navigateToScreen(Widget screen, BuildContext context) {
  Navigator.of(context).push(MaterialPageRoute(builder: (context) => screen));
}

class MprisScreen extends ConsumerStatefulWidget{
  final int playerIndex;
  const MprisScreen({super.key, required this.playerIndex});
  @override
  _MprisScreenState createState() => _MprisScreenState();
}
class _MprisScreenState extends ConsumerState<MprisScreen> {
  _MprisScreenState();
  late PlayerMetadata currentSong;
  @override
  
  void initState() {
    super.initState();
  }

  @override
  Widget build(context) {
    PlayerProviderListState state = ref.read(playerProviderListProvider);
    var prov = ref.read(state.list[widget.playerIndex].notifier);
    final PlayerState selectedPlayer = ref.watch(state.list[widget.playerIndex]);
    //if (selectedPlayerInstance == null) {
    //  print("No player found");
    //  return const Text("No player found");
    //}
    ThemeModel themeModel = GetIt.instance.get<ThemeModel>();
    ThemeData theme = themeModel.getTheme();
    return Scaffold(
            //appBar: AppBar(
            //  //leading: IconButton(
            //  //icon: Icon(Icons.arrow_back),
            //  //onPressed: () => Navigator.pop(context)),
            //  title: Text(selectedPlayer.progress.toString()),
            //),
            body: Center(
              child: SizedBox(
                width: 650,
                height: 400,
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.circular(32),
                            child: selectedPlayer.isStopped ? SizedBox(width: 256, height: 256) : CachedNetworkImage(
                              width: 256,
                              height: 256,
                              //fadeOutDuration: Duration.zero,
                              imageUrl: selectedPlayer.isStopped ? "" : selectedPlayer.imageUrl,
                              placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) => Icon(Icons.error),
                            ),
                          //child: Container(
                          //  width: 256,
                          //  height: 256,
                          //  color: theme.colorScheme.primaryContainer,
                            //),
                          ),
                          Expanded(child: Container()),
                          SizedBox(
                            width: 362-16,
                            child: Column(
                              children: [
                                MarqueeWidget(
                                  child: Text(
                                    selectedPlayer.isStopped ? "Not playing" : selectedPlayer.title,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 32,
                                    ),
                                  ),
                                ),
                                MarqueeWidget(
                                  child: Text(
                                    selectedPlayer.isStopped ? "" : selectedPlayer.album,
                                    style: TextStyle(
                                      fontSize: 24,
                                    ),
                                  ),
                                ),
                                MarqueeWidget(
                                  child: Text(
                                    selectedPlayer.isStopped ? "" : selectedPlayer.artist,
                                    style: TextStyle(
                                      //fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [ 
                                    Text(
                                      selectedPlayer.friendlyPosition,
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                    Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Text("/", style: TextStyle(fontSize: 20)),),
                                    Text(
                                      selectedPlayer.friendlyDuration,
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    FilledButton.tonal(
                                      child: SizedBox(width: 32, height: 48, child: Icon(Icons.skip_previous_rounded, size: 32)),
                                      onPressed: () => prov.previous(),
                                      //onPressed: (){},
                                    ),
                                      SizedBox(width: 16),
                                     FilledButton.tonal(
                                        child: SizedBox(width: 32, height: 48, child: Icon(selectedPlayer.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded, size: 32)),
                                      onPressed: () => prov.toggle(),
                                      //onPressed: (){},
                                    ),
                                    SizedBox(width: 16),
                                    FilledButton.tonal(
                                      child: SizedBox(width: 32, height: 48, child: Icon(Icons.skip_next_rounded, size: 32)),
                                      onPressed: () => prov.next(),
                                      //onPressed: (){},
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    //Row(
                    //  mainAxisSize: MainAxisSize.max,
                    //  children: [
                    //    Expanded(child:
                        SquigglySlider(
                            useLineThumb: selectedPlayer.isPlaying,
                            value: selectedPlayer.position.inMilliseconds.toDouble() > selectedPlayer.duration.inMilliseconds.toDouble() ? 0 : selectedPlayer.position.inMilliseconds.toDouble(),
                            min: 0,
                            max: selectedPlayer.duration.inMilliseconds.toDouble(),
                            squiggleAmplitude: selectedPlayer.isPlaying ? 6 : 0,
                            squiggleWavelength: 10,
                            squiggleSpeed: 0.1,
                            label: 'Progress',
                            onChanged: (double value) {
                              if(selectedPlayer.isStopped) return;
                              prov.seekTo(value.toInt());
                            },
                          ),
                    //    ),
                    //  ],
                    //),
                  ],
                ),
              ),
            ),
          );
  }
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

class MarqueeWidget extends StatefulWidget {
  final Widget child;
  final Axis direction;
  final Duration animationDuration, backDuration, pauseDuration;

  const MarqueeWidget({
    Key? key,
    required this.child,
    this.direction = Axis.horizontal,
    this.animationDuration = const Duration(milliseconds: 5000),
    this.backDuration = const Duration(milliseconds: 1000),
    this.pauseDuration = const Duration(milliseconds: 2000),
  }) : super(key: key);

  @override
  _MarqueeWidgetState createState() => _MarqueeWidgetState();
}

class _MarqueeWidgetState extends State<MarqueeWidget> {
  late ScrollController scrollController;

  @override
  void initState() {
    scrollController = ScrollController(initialScrollOffset: 50.0);
    WidgetsBinding.instance.addPostFrameCallback(scroll);
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: widget.child,
      scrollDirection: widget.direction,
      controller: scrollController,
    );
  }

  void scroll(_) async {
    while (scrollController.hasClients) {
      await Future.delayed(widget.pauseDuration);
      if (scrollController.hasClients) {
        await scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: widget.animationDuration,
          curve: Curves.linear,
        );
      }
      await Future.delayed(widget.pauseDuration);
      if (scrollController.hasClients) {
        await scrollController.animateTo(
          0.0,
          duration: widget.backDuration,
          curve: Curves.linear,
        );
      }
    }
  }
}
