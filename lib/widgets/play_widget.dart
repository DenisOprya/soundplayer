
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'dart:developer';

class PlayingSong extends StatefulWidget {
  const PlayingSong({Key? key, required this.songModel, required this.audioPlayer}) : super(key: key);
  final SongModel songModel;
  final AudioPlayer audioPlayer;

  @override
  State<PlayingSong> createState() => _PlayingSongState();
}

class _PlayingSongState extends State<PlayingSong> {
  Duration _duration = const Duration();
  Duration _position = const Duration();
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    playSong();
  }
  void playSong() {
    try {
      widget.audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(widget.songModel.uri!)));
      widget.audioPlayer.play();
    } on Exception {
      log('Cannot parse Song');
    }
    widget.audioPlayer.durationStream.listen((d) {
      setState(() {
        _duration = d!;
      });
    });
    widget.audioPlayer.durationStream.listen((p) {
      setState(() {
        _position = p!;
      });
    });
  }
  void playMusic() {
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(onPressed: () {
                Navigator.pop(context);
              }, icon: const Icon(Icons.arrow_back_ios)
              ),
              const SizedBox(
                height: 30,
              ),
              Center(
                child: Column(
                  children:  [
                    const CircleAvatar(
                      radius: 100,
                      child: Icon(Icons.music_note),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                     Text(
                      widget.songModel.displayNameWOExt,
                      overflow: TextOverflow.fade,
                      maxLines: 1,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                     Text(
                      widget.songModel.artist.toString() == '<unknown>'
                          ? 'Unknown Artist'
                          : widget.songModel.artist.toString(),
                      overflow: TextOverflow.fade,
                      maxLines: 1,
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                         Text(
                           _position.toString().split(".")[0],
                        ),
                        Expanded(child: Slider(
                          min: const Duration(microseconds: 0).inSeconds.toDouble(),
                            value: 0.0,
                            max: _duration.inSeconds.toDouble(),
                            onChanged: (value) {
                          setState(() {
                            changeToSeconds(value.toInt());
                            value = value;
                          });
                        })),
                         Text(
                          _duration.toString().split(".")[0],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.skip_previous,
                              size: 40,
                            )),
                        IconButton(
                            onPressed: () {
                                setState(() {
                                  if(_isPlaying) {
                                    widget.audioPlayer.stop();
                                  } else {
                                    widget.audioPlayer.play();
                                  }
                                  _isPlaying = !_isPlaying;
                                });

                            },
                            icon: Icon(
                              _isPlaying ? Icons.pause : Icons.play_arrow,
                              size: 40,
                              color: Colors.orangeAccent,
                            )),
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.skip_next,
                              size: 40,
                            )),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  void changeToSeconds(int seconds) {
    Duration duration = Duration(seconds: seconds);
    widget.audioPlayer.seek(duration);
  }
}
