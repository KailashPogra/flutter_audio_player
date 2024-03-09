import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class AudioPlayerProvider extends ChangeNotifier {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  void init(AudioPlayer audioPlayer) {
    _audioPlayer = audioPlayer;
  }

  void updateIsPlaying(bool isPlaying) {
    _isPlaying = isPlaying;
    notifyListeners();
  }

  void updateDuration(Duration duration) {
    _duration = duration;
    notifyListeners();
  }

  void updatePosition(Duration position) {
    _position = position;
    notifyListeners();
  }

  bool get isPlaying => _isPlaying;
  Duration get duration => _duration;
  Duration get position => _position;
}
