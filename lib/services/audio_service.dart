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
      // Configurar volumen máximo
      await _audioPlayer.setVolume(1.0);
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
      // Asegurar volumen máximo antes de reproducir
      await _audioPlayer.setVolume(1.0);
      
      // Reproducir el archivo MP3 de alerta
      await _audioPlayer.play(AssetSource('audio/alerta.mp3'));
      log('🔔 Sonido de alerta reproducido a volumen máximo');
    } catch (e) {
      log('💥 Error reproduciendo sonido: $e');
    }
  }

  Future<void> dispose() async {
    await _audioPlayer.dispose();
  }
}