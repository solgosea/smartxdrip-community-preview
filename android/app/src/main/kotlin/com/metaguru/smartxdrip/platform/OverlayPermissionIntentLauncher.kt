package com.metaguru.smartxdrip.platform

import android.content.Context
import android.content.Intent
import android.net.Uri
import android.provider.Settings

object OverlayPermissionIntentLauncher {
    fun openAppOverlaySettings(context: Context) {
        val packageUri = Uri.parse("package:${context.packageName}")
        val appIntent = Intent(
            Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
            packageUri
        ).addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)

        runCatching {
            context.startActivity(appIntent)
        }.recoverCatching {
            val fallbackIntent = Intent(
                Settings.ACTION_MANAGE_OVERLAY_PERMISSION
            ).addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            context.startActivity(fallbackIntent)
        }.getOrThrow()
    }
}
