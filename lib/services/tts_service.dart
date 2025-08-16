import 'dart:developer';
import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  static final TtsService _instance = TtsService._internal();
  factory TtsService() => _instance;
  TtsService._internal();

  final FlutterTts _flutterTts = FlutterTts();
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Configurar idioma
      await _flutterTts.setLanguage("es-ES");
      
      // Configurar velocidad y tono (velocidad más lenta)
      await _flutterTts.setSpeechRate(0.7);
      await _flutterTts.setPitch(1.0);
      await _flutterTts.setVolume(1.0);

      _isInitialized = true;
      log('✅ TTS inicializado correctamente');
    } catch (e) {
      log('💥 Error inicializando TTS: $e');
    }
  }

  Future<void> speak(String text) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      await _flutterTts.speak(text);
      log('🗣️ Reproduciendo: $text');
    } catch (e) {
      log('💥 Error reproduciendo TTS: $e');
    }
  }

  Future<void> stop() async {
    try {
      await _flutterTts.stop();
    } catch (e) {
      log('💥 Error deteniendo TTS: $e');
    }
  }
}
