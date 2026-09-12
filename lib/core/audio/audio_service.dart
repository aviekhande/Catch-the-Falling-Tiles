import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/foundation.dart';

abstract class AudioService {
  bool get isMuted;
  void toggleMute();
  void setMuted(bool muted);

  Future<void> playCatch();
  Future<void> playMiss();
  Future<void> playLifeLost();
  Future<void> playGameOver();
}

class FlameAudioServiceImpl implements AudioService {
  FlameAudioServiceImpl({bool initialMuted = false}) : _isMuted = initialMuted;

  bool _isMuted;

  @override
  bool get isMuted => _isMuted;

  @override
  void toggleMute() {
    _isMuted = !_isMuted;
  }

  @override
  void setMuted(bool muted) {
    _isMuted = muted;
  }

  @override
  Future<void> playCatch() => _playSound('catch.wav');

  @override
  Future<void> playMiss() => _playSound('miss.wav');

  @override
  Future<void> playLifeLost() => _playSound('life_lost.wav');

  @override
  Future<void> playGameOver() => _playSound('life_lost.wav');

  Future<void> _playSound(String fileName) async {
    if (_isMuted) return;
    try {
      await FlameAudio.play(fileName);
    } catch (e) {
      debugPrint('[AudioService] Could not play sound $fileName: $e');
    }
  }
}
