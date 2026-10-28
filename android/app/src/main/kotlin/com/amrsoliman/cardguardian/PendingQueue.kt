package com.amrsoliman.cardguardian

import android.content.Context
import android.security.keystore.KeyGenParameterSpec
import android.security.keystore.KeyProperties
import org.json.JSONObject
import java.io.File
import java.security.KeyStore
import javax.crypto.Cipher
import javax.crypto.KeyGenerator
import javax.crypto.SecretKey
import javax.crypto.spec.GCMParameterSpec

/**
 * Messages captured while the app is closed, waiting for Dart to import
 * them. Each one is a file encrypted with AES-GCM under a key that never
 * leaves the Android Keystore. Dart drains the queue on open/unlock.
 */
object PendingQueue {
    private const val KEY_ALIAS = "cardguardian_pending_v1"
    private const val MAX_ITEMS = 2000
    private val lock = Any()

    /** Set while the Flutter UI is running, to import right away. */
    @Volatile
    var onAdded: (() -> Unit)? = null

    private fun dir(ctx: Context): File = File(ctx.noBackupFilesDir, "pending").apply { mkdirs() }

    fun enqueue(ctx: Context, source: String, sender: String?, body: String, receivedAt: Long) {
        if (body.isBlank()) return
        val json = JSONObject()
            .put("source", source)
            .put("sender", sender ?: JSONObject.NULL)
            .put("body", body)
            .put("receivedAt", receivedAt)
        synchronized(lock) {
            val d = dir(ctx)
            val name = "%013d-%d".format(System.currentTimeMillis(), System.nanoTime())
            val tmp = File(d, "$name.tmp")
            tmp.writeBytes(encrypt(json.toString().toByteArray(Charsets.UTF_8)))
            tmp.renameTo(File(d, "$name.msg"))
            val files = d.listFiles { f -> f.name.endsWith(".msg") }?.sortedBy { it.name } ?: emptyList()
            if (files.size > MAX_ITEMS) files.take(files.size - MAX_ITEMS).forEach { it.delete() }
        }
        onAdded?.invoke()
    }

    /** Returns every queued message and removes it from the queue. */
    fun drain(ctx: Context): List<Map<String, Any?>> = synchronized(lock) {
        val files = dir(ctx).listFiles()?.sortedBy { it.name } ?: return emptyList()
        val out = ArrayList<Map<String, Any?>>()
        for (f in files) {
            if (f.name.endsWith(".msg")) {
                try {
                    val o = JSONObject(String(decrypt(f.readBytes()), Charsets.UTF_8))
                    out.add(
                        mapOf(
                            "source" to o.getString("source"),
                            "sender" to if (o.isNull("sender")) null else o.getString("sender"),
                            "body" to o.getString("body"),
                            "receivedAt" to o.getLong("receivedAt"),
                        ),
                    )
                } catch (_: Exception) {
                    // Unreadable (e.g. the key was reset): nothing to recover.
                }
            }
            f.delete()
        }
        out
    }

    private fun key(): SecretKey {
        val ks = KeyStore.getInstance("AndroidKeyStore").apply { load(null) }
        (ks.getKey(KEY_ALIAS, null) as? SecretKey)?.let { return it }
        val gen = KeyGenerator.getInstance(KeyProperties.KEY_ALGORITHM_AES, "AndroidKeyStore")
        gen.init(
            KeyGenParameterSpec.Builder(KEY_ALIAS, KeyProperties.PURPOSE_ENCRYPT or KeyProperties.PURPOSE_DECRYPT)
                .setBlockModes(KeyProperties.BLOCK_MODE_GCM)
                .setEncryptionPaddings(KeyProperties.ENCRYPTION_PADDING_NONE)
                .setKeySize(256)
                .build(),
        )
        return gen.generateKey()
    }

    private fun encrypt(plain: ByteArray): ByteArray {
        val c = Cipher.getInstance("AES/GCM/NoPadding")
        c.init(Cipher.ENCRYPT_MODE, key())
        val iv = c.iv
        return byteArrayOf(iv.size.toByte()) + iv + c.doFinal(plain)
    }

    private fun decrypt(data: ByteArray): ByteArray {
        val ivLen = data[0].toInt()
        val c = Cipher.getInstance("AES/GCM/NoPadding")
        c.init(Cipher.DECRYPT_MODE, key(), GCMParameterSpec(128, data.copyOfRange(1, 1 + ivLen)))
        return c.doFinal(data, 1 + ivLen, data.size - 1 - ivLen)
    }
}
