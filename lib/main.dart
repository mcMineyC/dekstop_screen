import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';
import 'package:mpris/mpris.dart';
import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:squiggly_slider/slider.dart';
import 'package:marquee/marquee.dart';

void main() async {
  GetIt.instance.allowReassignment = true;
  //GetIt.instance.registerSingleton<MpdClient>(client);
  final mpris = MPRIS();
  final players = await mpris.getPlayers();
  GetIt.instance.registerSingleton<MPRIS>(mpris);
  GetIt.instance.registerSingleton<List<MPRISPlayer>>(players);
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
            home: Scaffold(
              body: MprisListView(),
            ),
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
        ChangeNotifierProvider(create: (_) => MprisList())
      ],
      child: Consumer<MprisList>(builder: (context, mprisList, child) {
        return ListView(
          children: mprisList.list.map((player) => ListTile(
            title: Text(player.friendlyName),
            onTap: () => navigateToScreen(MprisScreen(player: player.player), context),
          )).toList(),
        );
      },
      ),
    );
  }
}

void navigateToScreen(Widget screen, BuildContext context) {
  Navigator.of(context).push(MaterialPageRoute(builder: (context) => screen));
}

class MprisScreen extends StatefulWidget{
  final MPRISPlayer player;
  const MprisScreen({super.key, required this.player});
  @override
  _MprisScreenState createState() => _MprisScreenState();
}
class _MprisScreenState extends State<MprisScreen> {
  _MprisScreenState();
  late Timer _timer;
  late Metadata currentSong;
  @override
  
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 10), updateState); //updateSeconds
  }

  @override
  Widget build(context) {
    ThemeModel themeModel = GetIt.instance.get<ThemeModel>();
    ThemeData theme = themeModel.getTheme();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MprisController(widget.player)),
      ],
      child: Consumer<MprisController>(
        builder: (context, mprisController, child) {
          GetIt.instance.registerSingleton<MprisController>(mprisController);
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
                              imageUrl: mprisController.currentSong == null ? "" : mprisController.currentSong!.trackArtUrl,
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
                                    mprisController.currentSong == null ? "Not playing" : mprisController.currentSong!.trackTitle,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 32,
                                    ),
                                  ),
                                ),
                                MarqueeWidget(
                                  child: Text(
                                    mprisController.currentSong == null ? "" : mprisController.currentSong!.albumName,
                                    style: TextStyle(
                                      fontSize: 24,
                                    ),
                                  ),
                                ),
                                MarqueeWidget(
                                  child: Text(
                                    mprisController.currentSong == null ? "" : mprisController.currentSong!.trackArtists.join(", "),
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
                                      onPressed: () => mprisController.player.previous(),
                                    ),
                                      SizedBox(width: 16),
                                     FilledButton.tonal(
                                        child: SizedBox(width: 32, height: 48, child: Icon(mprisController.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded, size: 32)),
                                      onPressed: () => mprisController.player.toggle(),
                                    ),
                                    SizedBox(width: 16),
                                    FilledButton.tonal(
                                      child: SizedBox(width: 32, height: 48, child: Icon(Icons.skip_next_rounded, size: 32)),
                                      onPressed: () => mprisController.player.next(),
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
  void updateState(Timer _) {
    MprisController mprisController = GetIt.instance.get<MprisController>();
    mprisController.update();
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

class MprisController extends ChangeNotifier {
  Metadata? currentSong;
  MPRISPlayer player;
  String friendlyName = "";
  Duration position = Duration.zero;
  Duration duration = Duration.zero;
  String get friendlyPosition => (position.inHours > 0 ? position.inHours.toString() + ":" : "") + position.inMinutes.toString() + ":" + (position.inSeconds - (position.inMinutes*60)).toString().padLeft(2, "0");
  String get friendlyDuration => (duration.inHours > 0 ? duration.inHours.toString() + ":" : "") + duration.inMinutes.toString() + ":" + (duration.inSeconds - (duration.inMinutes*60)).toString().padLeft(2, "0");
  double get progress => duration.inMilliseconds == 0 ? 0 : position.inMilliseconds.toDouble() / (duration.inMilliseconds ?? 0);
  bool get isPlaying => playbackState == PlaybackStatus.playing;
  PlaybackStatus playbackState = PlaybackStatus.stopped;
  MprisController(this.player){
    identifier();
    update();
  }
  void identifier() {
    () async {
      try{
        friendlyName = await player.getIdentity();
        notifyListeners();
      }catch(e){
        friendlyName = player.name;
      }
    }();
  }
  void currentsong() {
    () async {
      try{
        currentSong = await player.getMetadata();
        duration = currentSong?.trackLength ?? Duration.zero;
        notifyListeners();
      }catch(e){
        currentSong = null;
        duration = Duration.zero;
        //print(e);
      }
    }();
  }
  void getPosition() {
    () async {
      try{
        position = await player.getPosition();
        notifyListeners();
      }catch(e){
        position = Duration.zero;
      }
    }();
  }
  void seekTo(int inMillis){
    () async {
      position = Duration(milliseconds: inMillis);
      notifyListeners();
      await player.setPosition(currentSong!.trackId, Duration(milliseconds: inMillis));
    }();
  }
  void playing(){
    () async {
      try {
        playbackState = await player.getPlaybackStatus();
        notifyListeners();
      }catch(e){
        playbackState = PlaybackStatus.stopped;
      }
    }();
  }
  void update() {
    currentsong();
    getPosition();
    playing();
  }
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
