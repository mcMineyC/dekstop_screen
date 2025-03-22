import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';
import 'package:mpris/mpris.dart';
import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:squiggly_slider/slider.dart';
import 'package:marquee/marquee.dart';
import 'package:multicast_dns/multicast_dns.dart';
import 'playerobject.dart';

void main() async {
  GetIt.instance.allowReassignment = true;
  //GetIt.instance.registerSingleton<MpdClient>(client);
  //final mpris = MPRIS();
  //final players = await mpris.getPlayers();
  //GetIt.instance.registerSingleton<MPRIS>(mpris);
  //GetIt.instance.registerSingleton<List<MPRISPlayer>>(players);
  final MDnsClient client = MDnsClient();
  await client.start();
  GetIt.instance.registerSingleton<MDnsClient>(client);
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeModel()),
        //ChangeNotifierProvider(create: (_) => MprisList()),
      ],
      child: Consumer<ThemeModel>(
        builder: (context, themeModel, child) {
          GetIt.instance.registerSingleton(themeModel);
          return MaterialApp(
            theme: themeModel.getTheme(),
            home: MprisListView(),
          );
        },
      ),
    );
  }
}
class MprisListView extends StatefulWidget {
  const MprisListView({super.key});
  @override
  _MprisListViewState createState() => _MprisListViewState();
}

class _MprisListViewState extends State<MprisListView> {
  @override
  Widget build(context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PlayerProviderList())
      ],
      child: Consumer<PlayerProviderList>(builder: (context, list, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Players Available"),
            leading: IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => list.updateList(),
            ),
          ),
          body: ListView(
            children: list.list.map((player) => ListTile(
              title: Text(player.friendlyName),
              onTap: () => navigateToScreen(MprisScreen(player: player), context),
            )).toList(),
          ),
        );
      }),
    );
  }
}

void navigateToScreen(Widget screen, BuildContext context) {
  Navigator.of(context).push(MaterialPageRoute(builder: (context) => screen));
}

class MprisScreen extends StatefulWidget{
  final PlayerInstance player;
  const MprisScreen({super.key, required this.player});
  @override
  _MprisScreenState createState() => _MprisScreenState();
}
class _MprisScreenState extends State<MprisScreen> {
  _MprisScreenState();
  late Metadata currentSong;
  @override
  
  void initState() {
    super.initState();
  }

  @override
  Widget build(context) {
    ThemeModel themeModel = GetIt.instance.get<ThemeModel>();
    ThemeData theme = themeModel.getTheme();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => widget.player),
      ],
      child: Consumer<PlayerInstance>(
        builder: (context, mprisController, child) {
          GetIt.instance.registerSingleton<PlayerInstance>(mprisController);
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context)),
              title: Text(mprisController.friendlyName)
            ),
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
                            child: CachedNetworkImage(
                              width: 256,
                              height: 256,
                              //fadeOutDuration: Duration.zero,
                              imageUrl: mprisController.currentSong == null ? "" : mprisController.currentSong!.imageUrl,
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
                                    mprisController.currentSong == null ? "Not playing" : mprisController.currentSong!.title,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 32,
                                    ),
                                  ),
                                ),
                                MarqueeWidget(
                                  child: Text(
                                    mprisController.currentSong == null ? "" : mprisController.currentSong!.album,
                                    style: TextStyle(
                                      fontSize: 24,
                                    ),
                                  ),
                                ),
                                MarqueeWidget(
                                  child: Text(
                                    mprisController.currentSong == null ? "" : mprisController.currentSong!.artist,
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
                                      mprisController.friendlyPosition,
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                    Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Text("/", style: TextStyle(fontSize: 20)),),
                                    Text(
                                      mprisController.friendlyDuration,
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
                                      onPressed: () => mprisController.previous(),
                                    ),
                                      SizedBox(width: 16),
                                     FilledButton.tonal(
                                        child: SizedBox(width: 32, height: 48, child: Icon(mprisController.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded, size: 32)),
                                      onPressed: () => mprisController.toggle(),
                                    ),
                                    SizedBox(width: 16),
                                    FilledButton.tonal(
                                      child: SizedBox(width: 32, height: 48, child: Icon(Icons.skip_next_rounded, size: 32)),
                                      onPressed: () => mprisController.next(),
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
                            useLineThumb: mprisController.isPlaying,
                            value: mprisController.position.inMilliseconds.toDouble() > mprisController.duration.inMilliseconds.toDouble() ? 0 : mprisController.position.inMilliseconds.toDouble(),
                            min: 0,
                            max: mprisController.duration.inMilliseconds.toDouble(),
                            squiggleAmplitude: mprisController.isPlaying ? 6 : 0,
                            squiggleWavelength: 10,
                            squiggleSpeed: 0.1,
                            label: 'Progress',
                            onChanged: (double value) {
                              if(mprisController.currentSong == null) return;
                              mprisController.seekTo(value.toInt());
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
      ), //Center(child: TextButton(child: Text("toggle mode ${themeModel.dark ? "light" : "dark"}"), onPressed: () => themeModel.dark = !themeModel.dark));
    );
  }
}

class ThemeModel extends ChangeNotifier {
  bool _dark = true;
  Color _color = Colors.blue[500]!;
  bool get dark => _dark;
  Color get color => _color;
  set dark(bool value) {
    _dark = value;
    notifyListeners();
  }
  set color(Color value) {
    _color = value;
    notifyListeners();
  }
  ThemeData getTheme() => ThemeData(
    fontFamily: "JetBrainsNerdMono",
    colorScheme: ColorScheme.fromSeed(
      brightness: _dark ? Brightness.dark : Brightness.light,
      seedColor: _color
    ),
  );
}


class MprisList extends ChangeNotifier {
  List<FriendlyPlayer> _list = [];
  List<FriendlyPlayer> get list => _list;
  set list(List<FriendlyPlayer> value) {
    _list = value;
    notifyListeners();
  }
  MprisList(){
    updateList();
  }
  void updateList() {
    GetIt.instance.get<MPRIS>().getPlayers().then((value) async {
      list = await Future.wait(value.map((player) async {
        return FriendlyPlayer(player: player, friendlyName: await player.getIdentity());
      }).toList());
    });
  }
}

class FriendlyPlayer {
  final MPRISPlayer player;
  final String friendlyName;
  const FriendlyPlayer({required this.player, required this.friendlyName});
}


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
