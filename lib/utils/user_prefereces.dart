import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  late SharedPreferences preferences;

  UserPreferences() {
    initPreference();
  }

  void initPreference() async {
    preferences = await SharedPreferences.getInstance();
  }

  void prefSetAudioEnabled(bool enabled) async {
    preferences.setBool("is_audio_enabled", enabled);
  }

  bool prefGetAudioEnabled() {
    return preferences.getBool("is_audio_enabled") ?? true;
  }

  void prefSetBestScore(int score) {
    preferences.setInt('best_score', score);
  }

  int prefGetBestScore() {
    return preferences.getInt('best_score') ?? 0;
  }
}
