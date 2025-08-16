import 'package:flutter/material.dart';
import 'screens/notification_screen.dart';

void main() {
  runApp(const NotificacionesApp());
}

class NotificacionesApp extends StatelessWidget {
  const NotificacionesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notificaciones en Voz Alta',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const NotificationScreen(),
    );
  }
}