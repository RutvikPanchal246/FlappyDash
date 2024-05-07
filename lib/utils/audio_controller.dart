import 'package:flame_audio/flame_audio.dart';

class AudioController {
  bool isAudioEnabled;

  AudioController({required this.isAudioEnabled}) {
    FlameAudio.bgm.initialize();
    startBackGroundMusic(isAudioEnabled);
  }

  void startBackGroundMusic(bool isAudioEnabled) {
    this.isAudioEnabled = isAudioEnabled;
    if (isAudioEnabled) {
      FlameAudio.bgm.play('music_bg.mp3', volume: 0.4);
    }
  }

  void stopBackgroundMusic(bool isAudioEnabled) {
    this.isAudioEnabled = isAudioEnabled;
    FlameAudio.bgm.stop();
  }

  void playJumpMusic() {
    if (isAudioEnabled) {
      FlameAudio.play('dash_jump.mp3');
    }
  }

  void playCollisionMusic() {
    if (isAudioEnabled) {
      FlameAudio.play('collision.mp3');
    }
  }
}
