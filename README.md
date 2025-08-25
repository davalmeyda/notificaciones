# 🔔 Sistema de Notificaciones en Voz Alta

Una aplicación Flutter para recibir notificaciones de un servidor WebSocket y reproducirlas en voz alta con modo quiosco.

## ✨ Características

### 🎯 Funcionalidades Principales
- **Conexión WebSocket**: Recibe notificaciones en tiempo real desde un servidor
- **Texto a Voz (TTS)**: Reproduce las notificaciones en voz alta
- **Sonido de Alerta**: Reproduce un sonido MP3 antes de leer la notificación
- **Control de Volumen**: Maximiza automáticamente el volumen del sistema
- **Modo Quiosco**: Pantalla completa para mostrar notificaciones de forma prominente

### 🖥️ Modo Quiosco
- **Pantalla Siempre Encendida**: Mantiene la pantalla activa indefinidamente
- **Notificaciones Prominentes**: Muestra las notificaciones en pantalla completa
- **Animaciones Visuales**: Efectos de parpadeo y escala para llamar la atención
- **Información Temporal**: Muestra fecha y hora de cada notificación
- **Diseño Tipo Banco**: Interfaz similar a sistemas de tickets bancarios

## 🚀 Instalación

1. **Clona el repositorio**:
```bash
git clone <url-del-repositorio>
cd notificaciones
```

2. **Instala las dependencias**:
```bash
flutter pub get
```

3. **Ejecuta la aplicación**:
```bash
flutter run
```

## 📱 Uso

### Configuración Inicial
1. Abre la aplicación
2. Configura la URL de tu servidor WebSocket (por defecto: `http://localhost:3000`)
3. Presiona "Conectar" para establecer la conexión

### Modo Normal
- Ve todas las notificaciones recibidas en una lista
- Envía notificaciones de prueba
- Controla la conexión al servidor

### Modo Quiosco
1. Presiona el botón de pantalla completa (🔲) en la barra superior
2. La aplicación entrará en modo quiosco:
   - La pantalla se mantendrá siempre encendida
   - Las notificaciones aparecerán en pantalla completa con animaciones
   - Se mostrará la fecha/hora de la última notificación
3. Para salir, presiona la "X" en la esquina superior izquierda

## 🛠️ Tecnologías Utilizadas

- **Flutter**: Framework de desarrollo multiplataforma
- **Socket.IO**: Comunicación WebSocket en tiempo real
- **Flutter TTS**: Conversión de texto a voz
- **Audioplayers**: Reproducción de sonidos de alerta
- **Wakelock Plus**: Mantener la pantalla encendida
- **HTTP**: Cliente para pruebas de notificaciones

## 📋 Dependencias

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  socket_io_client: ^3.1.0
  flutter_tts: ^4.1.0
  http: ^1.2.2
  audioplayers: ^6.1.0
  wakelock_plus: ^1.2.8
```

## 🔧 Configuración del Servidor

La aplicación espera un servidor WebSocket que envíe notificaciones en el siguiente formato:

```json
{
  "titulo": "Título de la notificación",
  "descripcion": "Descripción detallada",
  "timestamp": "2024-01-01T12:00:00.000Z"
}
```

### Endpoint para Pruebas
La aplicación también puede enviar notificaciones de prueba a:
```
POST /webhook/notification
Content-Type: application/json

{
  "titulo": "Título de prueba",
  "descripcion": "Descripción de prueba"
}
```

## 🎨 Características Visuales del Modo Quiosco

- **Gradiente Dinámico**: Colores llamativos para notificaciones activas
- **Animaciones Suaves**: Efectos de escala y parpadeo
- **Tipografía Grande**: Texto fácil de leer desde la distancia
- **Indicadores de Estado**: Conexión y última notificación visibles
- **Diseño Responsive**: Se adapta a diferentes tamaños de pantalla

## 🔊 Funcionalidades de Audio

- **Sonido de Alerta**: Reproduce `assets/audio/alerta.mp3` antes de cada notificación
- **TTS Configurable**: Lee el título y descripción en voz alta
- **Control de Volumen**: Maximiza automáticamente el volumen del sistema
- **Gestión de Estados**: Puede detener la reproducción en cualquier momento

## 🔒 Permisos Requeridos

### Android
- `WAKE_LOCK`: Para mantener la pantalla encendida
- `INTERNET`: Para conexión WebSocket
- `MODIFY_AUDIO_SETTINGS`: Para control de volumen

### iOS
- Los permisos se gestionan automáticamente a través de los plugins

## 🎯 Casos de Uso

- **Sistemas de Alerta**: Notificaciones críticas en tiempo real
- **Pantallas Informativas**: Displays en áreas públicas
- **Sistemas de Tickets**: Similar a bancos o centros de servicio
- **Monitoreo de Procesos**: Alertas de sistemas automatizados

## 🔄 Flujo de la Aplicación

1. **Conexión**: Se establece WebSocket con el servidor
2. **Escucha**: La app mantiene conexión activa
3. **Recepción**: Llega una notificación del servidor
4. **Procesamiento**: Se reproduce sonido + TTS
5. **Visualización**: Se muestra en modo quiosco (si está activo)
6. **Persistencia**: Se guarda en historial local

## 🐛 Solución de Problemas

### La pantalla no se mantiene encendida
- Verifica que los permisos estén otorgados
- En Android, revisa la configuración de batería de la app

### No se escucha el audio
- Verifica que el volumen del dispositivo esté activado
- Comprueba que los archivos de audio estén en `assets/audio/`

### Problemas de conexión WebSocket
- Verifica que la URL del servidor sea correcta
- Asegúrate de que el servidor esté ejecutándose
- Revisa la conectividad de red del dispositivo

## 📄 Licencia

Este proyecto está bajo la Licencia MIT. Ver el archivo `LICENSE` para más detalles.
