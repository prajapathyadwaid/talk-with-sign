import 'package:flutter_tts/flutter_tts.dart';

class Speak {
  final FlutterTts _tts = FlutterTts();
  Speak() {
    _tts.setVolume(0);
  }
  Future<void> speak(String word) async {
    await _tts.setPitch(0.7);
    await _tts.setSpeechRate(0.4);
    await _tts.speak(word);
  }

  void stop() async {
    await _tts.stop();
  }

  void setVolume(double vol) {
    _tts.setVolume(vol);
  }
}
