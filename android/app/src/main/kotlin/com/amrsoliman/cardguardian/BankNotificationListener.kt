package com.amrsoliman.cardguardian

import android.app.Notification
import android.os.Bundle
import android.provider.Telephony
import android.service.notification.NotificationListenerService
import android.service.notification.StatusBarNotification

/**
 * Reads bank alerts from notifications of the apps the user picked.
 *
 * For every other app only the package name is noted (so it can be offered
 * in the picker); its notification content is never read or stored. For the
 * SMS app, the conversation must also be an allowed sender.
 */
class BankNotificationListener : NotificationListenerService() {
    override fun onNotificationPosted(sbn: StatusBarNotification) {
        try {
            handle(sbn)
        } catch (_: Exception) {
            // Never crash the listener; the message can still be imported by hand.
        }
    }

    private fun handle(sbn: StatusBarNotification) {
        val pkg = sbn.packageName ?: return
        if (pkg == packageName) return
        val n = sbn.notification ?: return
        if (n.flags and Notification.FLAG_GROUP_SUMMARY != 0) return
        SourcePrefs.recordSeenPackage(this, pkg)
        if (!SourcePrefs.notificationPackages(this).contains(pkg)) return

        val extras = n.extras ?: return
        val text = latestMessage(extras)
            ?: extras.getCharSequence(Notification.EXTRA_BIG_TEXT)?.toString()
            ?: extras.getCharSequence(Notification.EXTRA_TEXT)?.toString()
            ?: return

        val sender: String?
        if (pkg == Telephony.Sms.getDefaultSmsPackage(this)) {
            val conversation = extras.getCharSequence(Notification.EXTRA_CONVERSATION_TITLE)?.toString()
                ?: extras.getCharSequence(Notification.EXTRA_TITLE)?.toString()
                ?: return
            if (!SourcePrefs.isAllowedSender(this, conversation)) return
            sender = conversation
        } else {
            // A bank's own app: the user picked the app itself. Dart matches
            // the bank by message format.
            sender = null
        }
        PendingQueue.enqueue(this, "notification", sender, text, sbn.postTime)
    }

    @Suppress("DEPRECATION")
    private fun latestMessage(extras: Bundle): String? {
        val messages = extras.getParcelableArray(Notification.EXTRA_MESSAGES) ?: return null
        val last = messages.lastOrNull() as? Bundle ?: return null
        return last.getCharSequence("text")?.toString()
    }
}
