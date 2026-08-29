package com.mindtouch.client

import android.content.Context
import android.content.Intent

/** Restart MindTouch background listening after device reboot. */
class BootReceiver : android.content.BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent?) {
        if (intent?.action == Intent.ACTION_BOOT_COMPLETED) {
            if (MindTouchAccessibilityService.instance != null) {
                MindTouchForegroundService.start(context)
            }
        }
    }
}
