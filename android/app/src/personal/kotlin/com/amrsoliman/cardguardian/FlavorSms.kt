package com.amrsoliman.cardguardian

import android.Manifest
import android.content.Context
import android.content.pm.PackageManager
import android.provider.Telephony
import androidx.core.content.ContextCompat

/** `personal` build: reads SMS from the senders the user allowed. */
object FlavorSms {
    const val FLAVOR = "personal"
    const val SUPPORTED = true
    val PERMISSIONS = arrayOf(Manifest.permission.READ_SMS, Manifest.permission.RECEIVE_SMS)

    fun hasPermission(ctx: Context): Boolean =
        PERMISSIONS.all { ContextCompat.checkSelfPermission(ctx, it) == PackageManager.PERMISSION_GRANTED }

    /** Distinct senders with counts. Reads addresses and dates only, never bodies. */
    fun senders(ctx: Context): List<Map<String, Any>> {
        if (!hasPermission(ctx)) return emptyList()
        class Acc(val address: String, var count: Int, var lastAt: Long)
        val byKey = LinkedHashMap<String, Acc>()
        ctx.contentResolver.query(
            Telephony.Sms.Inbox.CONTENT_URI,
            arrayOf(Telephony.Sms.ADDRESS, Telephony.Sms.DATE),
            null,
            null,
            "${Telephony.Sms.DATE} DESC",
        )?.use { c ->
            while (c.moveToNext()) {
                val address = c.getString(0) ?: continue
                val key = SourcePrefs.normalizeSender(address)
                if (key.isEmpty()) continue
                val date = c.getLong(1)
                val acc = byKey.getOrPut(key) { Acc(address, 0, date) }
                acc.count++
                if (date > acc.lastAt) acc.lastAt = date
            }
        }
        return byKey.values
            .sortedByDescending { it.count }
            .map { mapOf("address" to it.address, "count" to it.count, "lastAt" to it.lastAt) }
    }

    /** Messages from the given senders only, newest first. */
    fun read(ctx: Context, addresses: List<String>, since: Long?, limit: Int): List<Map<String, Any?>> {
        if (!hasPermission(ctx)) return emptyList()
        val wanted = addresses.map(SourcePrefs::normalizeSender).filter { it.isNotEmpty() }.toSet()
        if (wanted.isEmpty()) return emptyList()
        val out = ArrayList<Map<String, Any?>>()
        ctx.contentResolver.query(
            Telephony.Sms.Inbox.CONTENT_URI,
            arrayOf(Telephony.Sms.ADDRESS, Telephony.Sms.BODY, Telephony.Sms.DATE),
            if (since != null) "${Telephony.Sms.DATE} >= ?" else null,
            if (since != null) arrayOf(since.toString()) else null,
            "${Telephony.Sms.DATE} DESC",
        )?.use { c ->
            while (c.moveToNext() && out.size < limit) {
                val address = c.getString(0) ?: continue
                if (!wanted.contains(SourcePrefs.normalizeSender(address))) continue
                out.add(
                    mapOf(
                        "source" to "sms",
                        "sender" to address,
                        "body" to (c.getString(1) ?: ""),
                        "receivedAt" to c.getLong(2),
                    ),
                )
            }
        }
        return out
    }
}
