package com.metaguru.smartxdrip.glance

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import com.metaguru.smartxdrip.R

open class GlanceWidgetProvider : AppWidgetProvider() {
    open val layoutId: Int = R.layout.widget_glance_trend

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        val renderer = GlanceWidgetRenderer()
        for (appWidgetId in appWidgetIds) {
            appWidgetManager.updateAppWidget(appWidgetId, renderer.render(context, layoutId))
        }
    }
}

class GlanceCompactWidgetProvider : GlanceWidgetProvider() {
    override val layoutId: Int = R.layout.widget_glance_compact
}

class GlanceTrendWidgetProvider : GlanceWidgetProvider() {
    override val layoutId: Int = R.layout.widget_glance_trend
}

class GlanceDashboardWidgetProvider : GlanceWidgetProvider() {
    override val layoutId: Int = R.layout.widget_glance_dashboard
}

class GlanceDualUnitWidgetProvider : GlanceWidgetProvider() {
    override val layoutId: Int = R.layout.widget_glance_dual_unit
}
