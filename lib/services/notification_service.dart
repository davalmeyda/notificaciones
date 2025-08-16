import 'dart:developer';
import '../models/notification_model.dart';
import 'websocket_service.dart';
import 'tts_service.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final WebSocketService _webSocketService = WebSocketService();
  final TtsService _ttsService = TtsService();
  
  List<NotificationModel> _notifications = [];
  Function(List<NotificationModel>)? _onNotificationsUpdated;

  Future<void> initialize({required String serverUrl}) async {
    // Inicializar TTS
    await _ttsService.initialize();
    
    // Configurar callback para notificaciones
    _webSocketService.setOnNotificationReceived(_handleNotification);
    
    // Conectar WebSocket
    _webSocketService.connect(serverUrl: serverUrl);
  }

  void _handleNotification(NotificationModel notification) {
    log('📱 Procesando notificación: ${notification.titulo}');
    
    // Agregar a la lista
    _notifications.insert(0, notification);
    
    // Limitar a las últimas 50 notificaciones
    if (_notifications.length > 50) {
      _notifications = _notifications.take(50).toList();
    }
    
    // Notificar cambios
    _onNotificationsUpdated?.call(_notifications);
    
    // Leer en voz alta
    _speakNotification(notification);
  }

  void _speakNotification(NotificationModel notification) {
    final text = "${notification.titulo}. ${notification.descripcion}";
    _ttsService.speak(text);
  }

  void setOnNotificationsUpdated(Function(List<NotificationModel>) callback) {
    _onNotificationsUpdated = callback;
  }

  List<NotificationModel> get notifications => List.unmodifiable(_notifications);
  
  bool get isConnected => _webSocketService.isConnected;

  void disconnect() {
    _webSocketService.disconnect();
  }

  Future<void> stopSpeaking() async {
    await _ttsService.stop();
  }
}
