package com.amrsoliman.cardguardian

import android.content.Context
import android.os.Build
import java.io.File

/** Best-effort root detection. Used for a warning only, never to block. */
object DeviceIntegrity {
    private val suPaths = listOf(
        "/system/bin/su",
        "/system/xbin/su",
        "/sbin/su",
        "/su/bin/su",
        "/system/app/Superuser.apk",
        "/data/local/su",
        "/data/local/bin/su",
        "/data/local/xbin/su",
    )

    fun looksCompromised(ctx: Context): Boolean {
        if (Build.TAGS?.contains("test-keys") == true) return true
        if (suPaths.any { File(it).exists() }) return true
        return try {
            ctx.packageManager.getPackageInfo("com.topjohnwu.magisk", 0)
            true
        } catch (_: Exception) {
            false
        }
    }
}
