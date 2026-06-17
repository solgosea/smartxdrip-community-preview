package com.metaguru.smartxdrip.platform

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

object AppLifecycleBridge {
    private const val CHANNEL = "com.metaguru.smartxdrip/app_lifecycle"

    fun configure(flutterEngine: FlutterEngine, activity: FlutterActivity) {
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "moveTaskToBack" -> {
                        activity.moveTaskToBack(true)
                        result.success(true)
                    }
                    else -> result.notImplemented()
                }
            }
    }
}
