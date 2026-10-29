package com.amrsoliman.cardguardian

import android.content.ComponentName
import android.content.Intent
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.provider.Settings
import android.provider.Telephony
import androidx.core.app.NotificationManagerCompat
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.util.concurrent.Executors

/** The `cardguardian/native` channel. Mirrors lib/services/platform_bridge.dart. */
class NativeBridge(private val activity: MainActivity, messenger: BinaryMessenger) : MethodChannel.MethodCallHandler {
    private val channel = MethodChannel(messenger, "cardguardian/native")
    private val main = Handler(Looper.getMainLooper())
    private val io = Executors.newSingleThreadExecutor()
    private val ctx = activity.applicationContext

    init {
        channel.setMethodCallHandler(this)
        PendingQueue.onAdded = { main.post { channel.invokeMethod("pendingAvailable", null) } }
    }

    fun dispose() {
        PendingQueue.onAdded = null
        channel.setMethodCallHandler(null)
        io.shutdown()
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "capabilities" -> result.success(
                mapOf(
                    "sms" to FlavorSms.SUPPORTED,
                    "notificationListener" to true,
                    "shortcuts" to false,
                    "flavor" to FlavorSms.FLAVOR,
                ),
            )
            "drainPending" -> background(result) { PendingQueue.drain(ctx) }
            "setAllowedSenders" -> {
                SourcePrefs.setAllowedSenders(ctx, call.stringList())
                result.success(null)
            }
            "setNotificationPackages" -> {
                SourcePrefs.setNotificationPackages(ctx, call.stringList())
                result.success(null)
            }
            "hasSmsPermission" -> result.success(FlavorSms.hasPermission(ctx))
            "requestSmsPermission" -> activity.requestSmsPermission(result)
            "smsSenders" -> background(result) { FlavorSms.senders(ctx) }
            "readSms" -> {
                val addresses = call.argument<List<String>>("addresses") ?: emptyList()
                val since = call.argument<Number>("since")?.toLong()
                val limit = call.argument<Number>("limit")?.toInt() ?: 5000
                background(result) { FlavorSms.read(ctx, addresses, since, limit) }
            }
            "notificationAccessEnabled" ->
                result.success(NotificationManagerCompat.getEnabledListenerPackages(ctx).contains(ctx.packageName))
            "openNotificationAccessSettings" -> {
                openNotificationAccessSettings()
                result.success(null)
            }
            "notificationApps" -> background(result) { notificationApps() }
            "setSecureScreen" -> {
                val secure = call.arguments as? Boolean ?: true
                SourcePrefs.setSecureScreen(ctx, secure)
                activity.applySecureScreen(secure)
                result.success(null)
            }
            "deviceLooksCompromised" -> background(result) { DeviceIntegrity.looksCompromised(ctx) }
            else -> result.notImplemented()
        }
    }

    private fun MethodCall.stringList(): List<String> = (arguments as? List<*>)?.filterIsInstance<String>() ?: emptyList()

    private fun background(result: MethodChannel.Result, work: () -> Any?) {
        io.execute {
            try {
                val value = work()
                main.post { result.success(value) }
            } catch (e: Exception) {
                // Never include message contents in errors.
                main.post { result.error("native", e.javaClass.simpleName, null) }
            }
        }
    }

    private fun openNotificationAccessSettings() {
        val intent = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            Intent(Settings.ACTION_NOTIFICATION_LISTENER_DETAIL_SETTINGS).putExtra(
                Settings.EXTRA_NOTIFICATION_LISTENER_COMPONENT_NAME,
                ComponentName(ctx, BankNotificationListener::class.java).flattenToString(),
            )
        } else {
            Intent(Settings.ACTION_NOTIFICATION_LISTENER_SETTINGS)
        }
        try {
            activity.startActivity(intent)
        } catch (_: Exception) {
            activity.startActivity(Intent(Settings.ACTION_NOTIFICATION_LISTENER_SETTINGS))
        }
    }

    private fun notificationApps(): List<Map<String, String>> {
        val packages = LinkedHashSet<String>()
        Telephony.Sms.getDefaultSmsPackage(ctx)?.let { packages.add(it) }
        packages.addAll(SourcePrefs.seenPackages(ctx).sorted())
        packages.addAll(SourcePrefs.notificationPackages(ctx))
        val pm = ctx.packageManager
        return packages.map { pkg ->
            val label = try {
                pm.getApplicationLabel(pm.getApplicationInfo(pkg, 0)).toString()
            } catch (_: Exception) {
                pkg
            }
            mapOf("package" to pkg, "label" to label)
        }
    }
}
