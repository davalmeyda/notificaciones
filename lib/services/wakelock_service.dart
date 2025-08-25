import 'package:wakelock_plus/wakelock_plus.dart';
import 'dart:developer';

class WakelockService {
  static final WakelockService _instance = WakelockService._internal();
  factory WakelockService() => _instance;
  WakelockService._internal();

  bool _isEnabled = false;

  /// Habilita el wakelock para mantener la pantalla encendida
  Future<void> enable() async {
    try {
      if (!_isEnabled) {
        await WakelockPlus.enable();
        _isEnabled = true;
        log('✅ Wakelock habilitado - Pantalla se mantendrá encendida');
      }
    } catch (e) {
      log('❌ Error habilitando wakelock: $e');
    }
  }

  /// Deshabilita el wakelock
  Future<void> disable() async {
    try {
      if (_isEnabled) {
        await WakelockPlus.disable();
        _isEnabled = false;
        log('🔋 Wakelock deshabilitado - Pantalla puede apagarse normalmente');
      }
    } catch (e) {
      log('❌ Error deshabilitando wakelock: $e');
    }
  }

  /// Verifica si el wakelock está habilitado
  Future<bool> isEnabled() async {
    try {
      final enabled = await WakelockPlus.enabled;
      _isEnabled = enabled;
      return enabled;
    } catch (e) {
      log('❌ Error verificando estado de wakelock: $e');
      return false;
    }
  }

  /// Alterna el estado del wakelock
  Future<void> toggle() async {
    final enabled = await isEnabled();
    if (enabled) {
      await disable();
    } else {
      await enable();
    }
  }

  bool get enabled => _isEnabled;
}
