package com.amrsoliman.cardguardian

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.provider.Telephony

/** Queues new SMS from allowed senders. Everything else is ignored unread. */
class SmsReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action != Telephony.Sms.Intents.SMS_RECEIVED_ACTION) return
        val parts = Telephony.Sms.Intents.getMessagesFromIntent(intent)?.filterNotNull() ?: return
        // A long SMS arrives in several parts from the same sender.
        for ((address, msgs) in parts.groupBy { it.displayOriginatingAddress ?: it.originatingAddress ?: "" }) {
            if (address.isEmpty() || !SourcePrefs.isAllowedSender(context, address)) continue
            val body = msgs.joinToString("") { it.displayMessageBody ?: it.messageBody ?: "" }
            PendingQueue.enqueue(context, "sms", address, body, System.currentTimeMillis())
        }
    }
}
