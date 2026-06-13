package com.metaguru.smartxdrip.glance

import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.content.Context
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

object GlanceWidgetBridge {
    private const val CHANNEL = "com.metaguru.smartxdrip/glance_widget"

    fun configure(flutterEngine: FlutterEngine, context: Context) {
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "publishSnapshot" -> {
                        @Suppress("UNCHECKED_CAST")
                        GlanceWidgetSnapshotStore(context).save(call.arguments as? Map<String, Any?> ?: emptyMap())
                        updateAllWidgets(context)
                        result.success(true)
                    }
                    "publishConfig" -> {
                        @Suppress("UNCHECKED_CAST")
                        GlanceWidgetSnapshotStore(context).saveConfig(call.arguments as? Map<String, Any?> ?: emptyMap())
                        updateAllWidgets(context)
                        result.success(true)
                    }
                    "updateAll" -> {
                        @Suppress("UNCHECKED_CAST")
                        GlanceWidgetSnapshotStore(context).save(call.arguments as? Map<String, Any?> ?: emptyMap())
                        updateAllWidgets(context)
                        result.success(true)
                    }
                    "updateWidget" -> {
                        @Suppress("UNCHECKED_CAST")
                        val args = call.arguments as? Map<String, Any?> ?: emptyMap()
                        @Suppress("UNCHECKED_CAST")
                        GlanceWidgetSnapshotStore(context).save(args["snapshot"] as? Map<String, Any?> ?: emptyMap())
                        @Suppress("UNCHECKED_CAST")
                        GlanceWidgetSnapshotStore(context).saveConfig(args["config"] as? Map<String, Any?> ?: emptyMap())
                        updateAllWidgets(context)
                        result.success(true)
                    }
                    else -> result.notImplemented()
                }
            }
    }

    private fun updateAllWidgets(context: Context) {
        val manager = AppWidgetManager.getInstance(context)
        val providers = listOf(
            GlanceCompactWidgetProvider::class.java,
            GlanceTrendWidgetProvider::class.java,
            GlanceDashboardWidgetProvider::class.java,
            GlanceDualUnitWidgetProvider::class.java
        )
        for (provider in providers) {
            val component = ComponentName(context, provider)
            val ids = manager.getAppWidgetIds(component)
            val instance = provider.getDeclaredConstructor().newInstance()
            instance.onUpdate(context, manager, ids)
        }
    }
}
