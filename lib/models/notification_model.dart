class NotificationModel {
  final String titulo;
  final String descripcion;
  final DateTime timestamp;

  NotificationModel({
    required this.titulo,
    required this.descripcion,
    required this.timestamp,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      titulo: json['titulo'] as String,
      descripcion: json['descripcion'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'titulo': titulo,
      'descripcion': descripcion,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
