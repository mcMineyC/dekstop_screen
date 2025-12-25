import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:squiggly_slider/slider.dart';
import "marquee.dart";

import "providers/player_provider_list.dart";
import "providers/theme.dart";
import 'generics/player_instance.dart';

class PlayerScreen extends ConsumerStatefulWidget{
  final int playerIndex;
  const PlayerScreen({super.key, required this.playerIndex});
  @override
  _PlayerScreenState createState() => _PlayerScreenState();
}
class _PlayerScreenState extends ConsumerState<PlayerScreen> {
  _PlayerScreenState();
  late PlayerMetadata currentSong;
  @override
  
  void initState() {
    super.initState();
  }

  @override
  Widget build(context) {
    PlayerProviderListState state = ref.watch(playerProviderListProvider);
    if(state.list.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    var prov = ref.read(state.list[widget.playerIndex].notifier);
    final PlayerState selectedPlayer = ref.watch(state.list[widget.playerIndex]);
    if(selectedPlayer.connectionState == PlayerConnectionState.disconnected) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 8),
            Text("Connecting to player"),
          ],
        )
      );
    }
    //if (selectedPlayerInstance == null) {
    //  print("No player found");
    //  return const Text("No player found");
    //}
    ThemeModel themeModel = GetIt.instance.get<ThemeModel>();
    ThemeData theme = themeModel.getTheme();
    return Container(
              // color: Colors.red,
              margin: EdgeInsets.fromLTRB(64,0,64,0),
              child: FittedBox(
                fit: BoxFit.contain,
                // aspectRatio: 650 / 400,
                child: SizedBox(
                width: 650,
                height: 308,
                child: Container(
                  // color: Colors.green,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
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
              )
          );
  }
}

