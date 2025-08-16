package com.example.notificaciones

import android.content.Context
import android.media.AudioManager
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class VolumeControlPlugin: FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel
    private lateinit var context: Context

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "volume_control")
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "setMaxVolume" -> {
                try {
                    val audioManager = context.getSystemService(Context.AUDIO_SERVICE) as AudioManager
                    val maxVolume = audioManager.getStreamMaxVolume(AudioManager.STREAM_MUSIC)
                    audioManager.setStreamVolume(AudioManager.STREAM_MUSIC, maxVolume, 0)
                    result.success(true)
                } catch (e: Exception) {
                    result.error("VOLUME_ERROR", "Could not set max volume", e.message)
                }
            }
            "isAndroid" -> {
                result.success(true)
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
