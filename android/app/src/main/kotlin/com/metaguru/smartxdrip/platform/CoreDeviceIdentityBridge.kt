package com.metaguru.smartxdrip.platform

import android.content.Context
import android.provider.Settings
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

object CoreDeviceIdentityBridge {
    private const val CHANNEL = "com.metaguru.smartxdrip/device_identity"

    fun configure(flutterEngine: FlutterEngine, context: Context) {
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "androidId" -> result.success(
                        Settings.Secure.getString(
                            context.contentResolver,
                            Settings.Secure.ANDROID_ID
                        )
                    )
                    else -> result.notImplemented()
                }
            }
    }
}
