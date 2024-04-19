import 'package:audioplayers/audioplayers.dart' as p;
import 'package:flutter/material.dart';

class AudioPlayer extends StatefulWidget {
  const AudioPlayer({super.key});

  @override
  State<AudioPlayer> createState() => _AudioPlayerState();
}

class _AudioPlayerState extends State<AudioPlayer> {
  p.AudioContext audioCtx = p.AudioContext();

  @override
  void initState() {
    final player = p.AudioPlayer();
    player.play(p.AssetSource('output_20240418154938831289.mp3'), ctx: audioCtx);

    player.eventStream.listen((event) {
      if (event.eventType == p.AudioEventType.complete) {
        Navigator.of(context).pop();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: Center(
          child: Icon(
            Icons.record_voice_over,
            color: Colors.white,
            size: MediaQuery.of(context).size.width / 2,
          ),
        )),
        Padding(
          padding: const EdgeInsets.all(20),
          child: TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Voltar", style: TextStyle(color: Colors.white))),
        )
      ],
    );
  }
}
