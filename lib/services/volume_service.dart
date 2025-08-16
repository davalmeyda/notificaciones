import 'dart:developer';
import 'package:flutter/services.dart';

class VolumeService {
  static final VolumeService _instance = VolumeService._internal();
  factory VolumeService() => _instance;
  VolumeService._internal();

  static const MethodChannel _channel = MethodChannel('volume_control');

  Future<void> setMaxVolume() async {
    try {
      // Intentar maximizar el volumen usando platform channel
      await _setSystemVolumeMax();
      log('🔊 Volumen del sistema maximizado');
    } catch (e) {
      log('⚠️ No se pudo maximizar volumen del sistema: $e');
    }
  }

  Future<void> _setSystemVolumeMax() async {
    try {
      // Para Android: maximizar volumen de media
      if (await _isAndroid()) {
        await _channel.invokeMethod('setMaxVolume');
      }
    } catch (e) {
      log('💥 Error configurando volumen: $e');
    }
  }

  Future<bool> _isAndroid() async {
    try {
      return await _channel.invokeMethod('isAndroid') ?? false;
    } catch (e) {
      return false;
    }
  }
}
