package com.amrsoliman.cardguardian

import android.content.Context
import android.content.SharedPreferences

/**
 * Which senders and apps the user allowed. Native code checks these before
 * anything is stored, so messages from other senders never leave the
 * receiver. Holds sender IDs and package names only, never message text.
 */
object SourcePrefs {
    private const val FILE = "cardguardian_sources"
    private const val ALLOWED_SENDERS = "allowed_senders"
    private const val NOTIFICATION_PACKAGES = "notification_packages"
    private const val SEEN_PACKAGES = "seen_packages"
    private const val SECURE_SCREEN = "secure_screen"
    private const val MAX_SEEN = 100

    private val nonSender = Regex("[^a-z0-9؀-ۿ+]")

    /** Same as normalizeSender() in cg_core. */
    fun normalizeSender(sender: String): String = sender.lowercase().replace(nonSender, "")

    private fun prefs(ctx: Context): SharedPreferences = ctx.getSharedPreferences(FILE, Context.MODE_PRIVATE)

    fun setAllowedSenders(ctx: Context, senders: List<String>) {
        val normalized = senders.map(::normalizeSender).filter { it.isNotEmpty() }.toSet()
        prefs(ctx).edit().putStringSet(ALLOWED_SENDERS, normalized).apply()
    }

    fun isAllowedSender(ctx: Context, sender: String): Boolean {
        val n = normalizeSender(sender)
        return n.isNotEmpty() && (prefs(ctx).getStringSet(ALLOWED_SENDERS, emptySet()) ?: emptySet()).contains(n)
    }

    fun setNotificationPackages(ctx: Context, packages: List<String>) {
        prefs(ctx).edit().putStringSet(NOTIFICATION_PACKAGES, packages.toSet()).apply()
    }

    fun notificationPackages(ctx: Context): Set<String> =
        prefs(ctx).getStringSet(NOTIFICATION_PACKAGES, emptySet())?.toSet() ?: emptySet()

    fun seenPackages(ctx: Context): Set<String> = prefs(ctx).getStringSet(SEEN_PACKAGES, emptySet())?.toSet() ?: emptySet()

    /** Remembers that an app posts notifications, so the user can pick it. */
    fun recordSeenPackage(ctx: Context, pkg: String) {
        val seen = seenPackages(ctx)
        if (seen.contains(pkg) || seen.size >= MAX_SEEN) return
        prefs(ctx).edit().putStringSet(SEEN_PACKAGES, seen + pkg).apply()
    }

    fun secureScreen(ctx: Context): Boolean = prefs(ctx).getBoolean(SECURE_SCREEN, true)

    fun setSecureScreen(ctx: Context, secure: Boolean) {
        prefs(ctx).edit().putBoolean(SECURE_SCREEN, secure).apply()
    }
}
