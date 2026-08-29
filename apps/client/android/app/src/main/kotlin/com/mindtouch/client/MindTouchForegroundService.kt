package com.mindtouch.client

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.IBinder
import androidx.core.app.NotificationCompat

/** Keeps MindTouch alive in background — listening for neural / remote commands. */
class MindTouchForegroundService : Service() {

    companion object {
        const val CHANNEL_ID = "mindtouch_listening"
        const val NOTIFICATION_ID = 1001
        const val ACTION_START = "com.mindtouch.action.START_FGS"
        const val ACTION_STOP = "com.mindtouch.action.STOP_FGS"

        @Volatile
        var isRunning = false
            private set

        fun start(context: Context, apiBase: String? = null, deviceId: String? = null) {
            val intent = Intent(context, MindTouchForegroundService::class.java).apply {
                action = ACTION_START
                if (!apiBase.isNullOrBlank()) putExtra("api_base", apiBase)
                if (!deviceId.isNullOrBlank()) putExtra("device_id", deviceId)
            }
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                context.startForegroundService(intent)
            } else {
                context.startService(intent)
            }
        }

        fun stop(context: Context) {
            context.stopService(
                Intent(context, MindTouchForegroundService::class.java).apply {
                    action = ACTION_STOP
                },
            )
        }
    }

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onCreate() {
        super.onCreate()
        createChannel()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        if (intent?.action == ACTION_STOP) {
            isRunning = false
            stopForeground(STOP_FOREGROUND_REMOVE)
            stopSelf()
            return START_NOT_STICKY
        }
        isRunning = true
        val apiBase = intent?.getStringExtra("api_base")
        val deviceId = intent?.getStringExtra("device_id")
        if (!apiBase.isNullOrBlank() && !deviceId.isNullOrBlank()) {
            RemoteCommandPoller.configure(this, apiBase, deviceId)
        }
        RemoteCommandPoller.start(this)
        val notification = buildNotification("Listening for remote commands")
        startForeground(NOTIFICATION_ID, notification)
        FloatingBubbleService.show(this, "MindTouch active")
        return START_STICKY
    }

    override fun onDestroy() {
        isRunning = false
        RemoteCommandPoller.stop()
        FloatingBubbleService.hide(this)
        super.onDestroy()
    }

    fun updateStatus(message: String) {
        val manager = getSystemService(NotificationManager::class.java)
        manager.notify(NOTIFICATION_ID, buildNotification(message))
        FloatingBubbleService.updateMessage(this, message)
    }

    private fun createChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                CHANNEL_ID,
                "MindTouch Listening",
                NotificationManager.IMPORTANCE_LOW,
            ).apply {
                description = "MindTouch stays active to control your phone hands-free"
                setShowBadge(true)
            }
            getSystemService(NotificationManager::class.java)
                .createNotificationChannel(channel)
        }
    }

    private fun buildNotification(content: String): Notification {
        val launchIntent = Intent(this, MainActivity::class.java).apply {
            flags = Intent.FLAG_ACTIVITY_SINGLE_TOP
        }
        val pending = PendingIntent.getActivity(
            this,
            0,
            launchIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )
        return NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle("MindTouch")
            .setContentText(content)
            .setSmallIcon(android.R.drawable.ic_menu_compass)
            .setOngoing(true)
            .setContentIntent(pending)
            .setPriority(NotificationCompat.PRIORITY_LOW)
            .setCategory(NotificationCompat.CATEGORY_SERVICE)
            .build()
    }
}
