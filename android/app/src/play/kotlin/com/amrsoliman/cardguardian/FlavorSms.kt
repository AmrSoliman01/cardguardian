package com.amrsoliman.cardguardian

import android.content.Context

/** `play` build: no SMS access at all. Bank alerts come from notifications. */
object FlavorSms {
    const val FLAVOR = "play"
    const val SUPPORTED = false
    val PERMISSIONS = emptyArray<String>()

    fun hasPermission(ctx: Context): Boolean = false

    fun senders(ctx: Context): List<Map<String, Any>> = emptyList()

    fun read(ctx: Context, addresses: List<String>, since: Long?, limit: Int): List<Map<String, Any?>> = emptyList()
}
