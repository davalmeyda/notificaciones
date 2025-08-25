import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/notification_model.dart';
import '../services/notification_service.dart';
import '../services/wakelock_service.dart';
import 'dart:async';

class KioskScreen extends StatefulWidget {
  const KioskScreen({super.key});

  @override
  State<KioskScreen> createState() => _KioskScreenState();
}

class _KioskScreenState extends State<KioskScreen>
    with TickerProviderStateMixin {
  final NotificationService _notificationService = NotificationService();
  final WakelockService _wakelockService = WakelockService();
  List<NotificationModel> _notifications = [];
  NotificationModel? _currentNotification;
  final String _serverUrl = 'http://chiquicloud.com:3333';
  bool _isConnected = false;
  
  // Controladores de animación
  late AnimationController _blinkController;
  late AnimationController _scaleController;
  late Animation<double> _blinkAnimation;
  late Animation<double> _scaleAnimation;
  
  Timer? _displayTimer;
  bool _showingNotification = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _setupWakelock();
    _setupNotificationService();
    _enterFullscreen();
    _connectToServer();
  }

  void _setupAnimations() {
    // Animación de parpadeo
    _blinkController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _blinkAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _blinkController, curve: Curves.easeInOut),
    );

    // Animación de escala
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );
  }

  void _setupWakelock() async {
    await _wakelockService.enable();
  }

  void _setupNotificationService() {
    _notificationService.setOnNotificationsUpdated(_updateNotifications);
    _checkConnection();
  }

  void _enterFullscreen() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  Future<void> _connectToServer() async {
    await _notificationService.initialize(serverUrl: _serverUrl);
    await Future.delayed(const Duration(milliseconds: 500));
    _checkConnection();
  }

  void _updateNotifications(List<NotificationModel> notifications) {
    if (mounted) {
      setState(() {
        _notifications = notifications;
        if (notifications.isNotEmpty) {
          _showNewNotification(notifications.first);
        }
      });
    }
  }

  void _showNewNotification(NotificationModel notification) {
    setState(() {
      _currentNotification = notification;
      _showingNotification = true;
    });

    // Iniciar animaciones
    _scaleController.forward();
    _blinkController.repeat(reverse: true);

    // Mantener la notificación visible por 10 segundos
    _displayTimer?.cancel();
    _displayTimer = Timer(const Duration(seconds: 10), () {
      if (mounted) {
        _blinkController.stop();
        setState(() {
          _showingNotification = false;
        });
      }
    });
  }

  void _checkConnection() {
    setState(() {
      _isConnected = _notificationService.isConnected;
    });
  }

  void _exitKioskMode() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    Navigator.of(context).pop();
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}';
  }

  String _formatDate(DateTime dateTime) {
    const months = [
      'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
      'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
    ];
    return '${dateTime.day} de ${months[dateTime.month - 1]} de ${dateTime.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Contenido principal
            if (_showingNotification && _currentNotification != null)
              _buildNotificationDisplay()
            else
              _buildIdleDisplay(),
            
            // Indicador de conexión en la esquina superior derecha
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _isConnected ? Colors.green.withValues(alpha: 0.8) : Colors.red.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _isConnected ? Icons.wifi : Icons.wifi_off,
                      color: Colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _isConnected ? 'Conectado' : 'Desconectado',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Botón de salir en la esquina superior izquierda
            Positioned(
              top: 16,
              left: 16,
              child: GestureDetector(
                onTap: _exitKioskMode,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationDisplay() {
    return AnimatedBuilder(
      animation: Listenable.merge([_blinkAnimation, _scaleAnimation]),
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.red.shade800,
                  Colors.red.shade600,
                  Colors.orange.shade600,
                ],
              ),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Icono parpadeante
                    Opacity(
                      opacity: _blinkAnimation.value,
                      child: const Icon(
                        Icons.notification_important,
                        size: 80,
                        color: Colors.white,
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Título de la notificación
                    Opacity(
                      opacity: _blinkAnimation.value,
                      child: Text(
                        _currentNotification!.titulo,
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              blurRadius: 10,
                              color: Colors.black54,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Descripción de la notificación
                    Text(
                      _currentNotification!.descripcion,
                      style: const TextStyle(
                        fontSize: 32,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            blurRadius: 5,
                            color: Colors.black54,
                            offset: Offset(1, 1),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Fecha y hora
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Text(
                            _formatTime(_currentNotification!.timestamp),
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            _formatDate(_currentNotification!.timestamp),
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildIdleDisplay() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF1a1a2e),
            Color(0xFF16213e),
            Color(0xFF0f3460),
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo o icono principal
            const Icon(
              Icons.notifications_none,
              size: 120,
              color: Colors.white38,
            ),
            
            const SizedBox(height: 32),
            
            // Texto de espera
            const Text(
              'Esperando notificaciones...',
              style: TextStyle(
                fontSize: 32,
                color: Colors.white70,
                fontWeight: FontWeight.w300,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 48),
            
            // Información de la última notificación (si existe)
            if (_notifications.isNotEmpty) ...[
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 32),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Última notificación:',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white60,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _notifications.first.titulo,
                      style: const TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${_formatTime(_notifications.first.timestamp)} - ${_formatDate(_notifications.first.timestamp)}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _displayTimer?.cancel();
    _blinkController.dispose();
    _scaleController.dispose();
    _wakelockService.disable();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }
}
