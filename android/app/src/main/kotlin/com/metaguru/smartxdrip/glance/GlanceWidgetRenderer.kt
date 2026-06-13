package com.metaguru.smartxdrip.glance

import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.graphics.Color
import android.util.TypedValue
import android.view.View
import android.widget.RemoteViews
import com.metaguru.smartxdrip.MainActivity
import com.metaguru.smartxdrip.R

class GlanceWidgetRenderer {
    fun render(context: Context, layoutId: Int): RemoteViews {
        val store = GlanceWidgetSnapshotStore(context)
        val snapshot = store.load()
        val config = store.loadConfig()
        val views = RemoteViews(context.packageName, layoutId)
        val stateColor = stateColor(snapshot.rangeState)
        val textColor = textColor(config.backgroundStyle)
        val freshness = freshnessLabel(layoutId, snapshot.freshnessLabel, config.graphRange)
        views.setInt(R.id.glance_widget_root, "setBackgroundResource", backgroundRes(config.backgroundStyle))
        views.setTextViewText(R.id.glance_value, snapshot.valueLabel)
        views.setTextViewText(R.id.glance_unit, snapshot.unitLabel)
        views.setTextViewText(R.id.glance_delta, snapshot.deltaLabel)
        views.setTextViewText(R.id.glance_trend, snapshot.trendArrow)
        views.setTextViewText(R.id.glance_freshness, freshness)
        views.setTextViewText(R.id.glance_source, snapshot.sourceLabel)
        views.setTextViewText(R.id.glance_alt_value, snapshot.alternateValueLabel)
        views.setTextViewText(R.id.glance_tir, "78%")
        views.setTextColor(R.id.glance_value, textColor)
        views.setTextColor(R.id.glance_trend, stateColor)
        views.setTextColor(R.id.glance_delta, stateColor)
        views.setTextColor(R.id.glance_link_glyph, stateColor)
        views.setTextColor(R.id.glance_tir, stateColor)
        views.setInt(R.id.glance_accent, "setBackgroundColor", stateColor)
        if (layoutId == R.layout.widget_glance_trend ||
            layoutId == R.layout.widget_glance_dashboard
        ) {
            views.setImageViewBitmap(
                R.id.glance_chart,
                GlanceWidgetChartRenderer().render(
                    snapshot.trendValues,
                    snapshot.targetLowMmol,
                    snapshot.targetHighMmol,
                    stateColor,
                    dashboard = layoutId == R.layout.widget_glance_dashboard
                )
            )
        }
        applyConfig(views, layoutId, config)
        views.setOnClickPendingIntent(R.id.glance_widget_root, openAppIntent(context))
        return views
    }

    private fun applyConfig(
        views: RemoteViews,
        layoutId: Int,
        config: GlanceWidgetNativeConfig
    ) {
        val valueSize = when (layoutId) {
            R.layout.widget_glance_dashboard -> sizeByConfig(config.fontSize, 28f, 30f, 32f)
            R.layout.widget_glance_trend -> sizeByConfig(config.fontSize, 20f, 22f, 24f)
            R.layout.widget_glance_dual_unit -> sizeByConfig(config.fontSize, 21f, 23f, 25f)
            else -> sizeByConfig(config.fontSize, 21f, 23f, 25f)
        }
        views.setTextViewTextSize(R.id.glance_value, TypedValue.COMPLEX_UNIT_SP, valueSize)
        views.setViewVisibility(R.id.glance_trend, if (config.showTrendArrow) View.VISIBLE else View.GONE)
        views.setViewVisibility(R.id.glance_delta, if (config.showDelta) View.VISIBLE else View.GONE)
        val timeVisibility = if (config.showLastUpdated) View.VISIBLE else View.GONE
        views.setViewVisibility(R.id.glance_freshness, timeVisibility)
        views.setViewVisibility(R.id.glance_link_glyph, timeVisibility)
        if (layoutId == R.layout.widget_glance_trend || layoutId == R.layout.widget_glance_dashboard) {
            views.setViewVisibility(R.id.glance_chart, if (config.showMiniGraph) View.VISIBLE else View.GONE)
        }
        if (layoutId == R.layout.widget_glance_dual_unit) {
            views.setViewVisibility(
                R.id.glance_alt_value,
                if (config.showAlternateUnit || config.template == "dual_unit") View.VISIBLE else View.GONE
            )
        }
    }

    private fun sizeByConfig(config: String, small: Float, medium: Float, large: Float): Float {
        return when (config) {
            "small" -> small
            "large" -> large
            else -> medium
        }
    }

    private fun freshnessLabel(layoutId: Int, label: String, graphRange: String): String {
        return when (layoutId) {
            R.layout.widget_glance_trend -> "$label - ${graphRangeLabel(graphRange)}"
            R.layout.widget_glance_dashboard -> "Updated $label"
            R.layout.widget_glance_dual_unit -> label.replace(" ago", "")
            else -> label
        }
    }

    private fun graphRangeLabel(graphRange: String): String {
        return when (graphRange) {
            "1h", "one_hour" -> "1h"
            "4h", "four_hours" -> "4h"
            "8h", "eight_hours" -> "8h"
            "24h", "twenty_four_hours" -> "24h"
            "3h", "three_hours" -> "4h"
            "6h", "six_hours" -> "8h"
            "12h", "twelve_hours" -> "24h"
            else -> "4h"
        }
    }

    private fun stateColor(state: String): Int {
        return when (state) {
            "in_range" -> Color.rgb(110, 232, 158)
            "high" -> Color.rgb(240, 180, 78)
            "low" -> Color.rgb(240, 120, 118)
            else -> Color.rgb(143, 191, 170)
        }
    }

    private fun textColor(backgroundStyle: String): Int {
        return when (backgroundStyle) {
            "light" -> Color.rgb(21, 51, 38)
            else -> Color.rgb(214, 237, 227)
        }
    }

    private fun backgroundRes(backgroundStyle: String): Int {
        return when (backgroundStyle) {
            "light" -> R.drawable.glance_widget_bg_light
            "transparent" -> R.drawable.glance_widget_bg_transparent
            else -> R.drawable.glance_widget_bg_dark
        }
    }

    private fun openAppIntent(context: Context): PendingIntent {
        val intent = Intent(context, MainActivity::class.java).apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_SINGLE_TOP
        }
        return PendingIntent.getActivity(
            context,
            74002,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
    }
}
