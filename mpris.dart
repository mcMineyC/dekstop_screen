import 'package:mpris/mpris.dart';
import 'dart:async';

void main() async {
  // Create a connection to the MPRIS service
  final mpris = MPRIS();

  // List all players available
  final players = await mpris.getPlayers();

  if (players.isEmpty) {
    print("No players found.");
    return;
  }

  // Choose the first player or specify one
  for(var player in players) {
    print(player.name);
    try{
      print(await player.getMetadata());
    }catch(e){}

  // Get the current playback state
    //Timer t = Timer.periodic(const Duration(seconds: 1), (Timer t) async {
    //  print(await player.getMetadata());
    //});
  }

  //final playbackState = await player.getPlaybackStatus();
  //
  //// Check if the player is playing
  //if (playbackState == PlaybackStatus.playing) {
  //  print("The player is playing.");
  //} else {
  //  print("The player is not playing.");
  //}
}

