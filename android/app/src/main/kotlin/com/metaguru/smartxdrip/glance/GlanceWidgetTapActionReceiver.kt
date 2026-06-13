package com.metaguru.smartxdrip.glance

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import com.metaguru.smartxdrip.MainActivity

class GlanceWidgetTapActionReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val open = Intent(context, MainActivity::class.java).apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_SINGLE_TOP
        }
        context.startActivity(open)
    }
}
