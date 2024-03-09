import 'package:flutter/material.dart';
import 'package:music_player/constant.dart';
import 'package:music_player/notification.dart';
import 'package:music_player/provider/audio_player_provider.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:provider/provider.dart';

class AudioPlayerScreen extends StatefulWidget {
  final List<SongModel> playlist;
  int currentIndex;
  final int imageId;

  AudioPlayerScreen({
    Key? key,
    required this.imageId,
    required this.playlist,
    required this.currentIndex,
  }) : super(key: key);

  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  late AudioPlayer audioPlayer;
  final OnAudioQuery _audioQuery = OnAudioQuery();

  @override
  void initState() {
    super.initState();
    audioPlayer = context.read<AudioPlayer>();
    audioPlayer.onPlayerComplete.listen((event) {
      if (widget.currentIndex < widget.playlist.length - 1) {
        setState(() {
          widget.currentIndex++;
        });
        _playCurrentSong();
      } else {
        print('Playlist reached the end');
      }
    });

    audioPlayer.onPlayerStateChanged.listen((state) {
      context
          .read<AudioPlayerProvider>()
          .updateIsPlaying(state == PlayerState.playing);
    });

    audioPlayer.onDurationChanged.listen((newDuration) {
      context.read<AudioPlayerProvider>().updateDuration(newDuration);
    });

    audioPlayer.onPositionChanged.listen((newPosition) {
      context.read<AudioPlayerProvider>().updatePosition(newPosition);
    });

    _playCurrentSong();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 1 / 2,
                  width: MediaQuery.of(context).size.width * 1 / 1.1,
                  child: QueryArtworkWidget(
                    controller: _audioQuery,
                    id: widget.playlist[widget.currentIndex].id,
                    type: ArtworkType.AUDIO,
                  ),
                ),
              ),
              const SizedBox(
                height: 32,
              ),
              Text(
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                widget.playlist[widget.currentIndex].title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                widget.playlist[widget.currentIndex].artist.toString(),
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 20,
                ),
              ),
              Consumer<AudioPlayerProvider>(
                builder: (context, provider, _) => Slider(
                  min: 0,
                  max: provider.duration.inSeconds.toDouble(),
                  value: provider.position.inSeconds.toDouble(),
                  onChanged: (value) async {
                    final position = Duration(seconds: value.toInt());
                    await audioPlayer.seek(position);
                  },
                ),
              ),
              Consumer<AudioPlayerProvider>(
                builder: (context, provider, _) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(kformatDuration(
                        Duration(seconds: provider.position.inSeconds))),
                    Text(kformatDuration(Duration(
                        seconds: provider.duration.inSeconds -
                            provider.position.inSeconds)))
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: Icon(Icons.skip_previous),
                    onPressed: _playPreviousSong,
                  ),
                  Consumer<AudioPlayerProvider>(
                    builder: (context, provider, _) => CircleAvatar(
                      radius: 35,
                      child: IconButton(
                        icon: Icon(provider.isPlaying
                            ? Icons.pause
                            : Icons.play_arrow),
                        onPressed: () async {
                          if (provider.isPlaying) {
                            await audioPlayer.pause();
                          } else {
                            await audioPlayer.resume();
                          }
                        },
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.skip_next),
                    onPressed: _playNextSong,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _playCurrentSong() async {
    String filePath = widget.playlist[widget.currentIndex].data;
    String uri = Uri.file(filePath).toString();
    await audioPlayer.play(UrlSource(uri));
    // kShowNotification(
    //   widget.playlist[widget.currentIndex].title,
    //   widget.playlist[widget.currentIndex].artist.toString(),
    // );
  }

  void _playPreviousSong() {
    if (widget.currentIndex > 0) {
      setState(() {
        widget.currentIndex--;
      });
      _playCurrentSong();
    }
  }

  void _playNextSong() {
    if (widget.currentIndex < widget.playlist.length - 1) {
      setState(() {
        widget.currentIndex++;
      });
      _playCurrentSong();
    }
  }
}
