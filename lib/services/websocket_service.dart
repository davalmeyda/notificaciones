import 'dart:developer';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../models/notification_model.dart';

class WebSocketService {
  static final WebSocketService _instance = WebSocketService._internal();
  factory WebSocketService() => _instance;
  WebSocketService._internal();

  IO.Socket? _socket;
  Function(NotificationModel)? _onNotificationReceived;

  void connect({required String serverUrl}) {
    try {
      _socket = IO.io(serverUrl, <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
      });

      _socket!.connect();

      _socket!.onConnect((_) {
        log('✅ Conectado al servidor WebSocket');
      });

      _socket!.onDisconnect((_) {
        log('❌ Desconectado del servidor WebSocket');
      });

      _socket!.on('notification', (data) {
        log('📢 Notificación recibida: $data');
        if (_onNotificationReceived != null) {
          final notification = NotificationModel.fromJson(data);
          _onNotificationReceived!(notification);
        }
      });

      _socket!.onError((error) {
        log('💥 Error WebSocket: $error');
      });
    } catch (e) {
      log('💥 Error conectando WebSocket: $e');
    }
  }

  void setOnNotificationReceived(Function(NotificationModel) callback) {
    _onNotificationReceived = callback;
  }

  void disconnect() {
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
  }

  bool get isConnected => _socket?.connected ?? false;
}
