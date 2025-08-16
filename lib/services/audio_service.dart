import 'dart:developer';
import 'package:audioplayers/audioplayers.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      _isInitialized = true;
      log('✅ AudioService inicializado correctamente');
    } catch (e) {
      log('💥 Error inicializando AudioService: $e');
    }
  }

  Future<void> playNotificationSound() async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      // Reproducir el archivo MP3 de alerta
      await _audioPlayer.play(AssetSource('audio/alerta.mp3'));
      log('🔔 Sonido de alerta reproducido');
    } catch (e) {
      log('💥 Error reproduciendo sonido: $e');
    }
  }

  Future<void> dispose() async {
    await _audioPlayer.dispose();
  }
}