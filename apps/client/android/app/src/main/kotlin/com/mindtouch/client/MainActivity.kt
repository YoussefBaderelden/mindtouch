package com.mindtouch.client

import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.os.PowerManager
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    companion object {
        private const val PHONE_CHANNEL = "com.mindtouch/phone_control"
        private const val PLATFORM_CHANNEL = "com.mindtouch/platform"
    }

    private val mainHandler = Handler(Looper.getMainLooper())

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, PHONE_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "isAccessibilityEnabled" -> {
                        mainHandler.post {
                            result.success(isAccessibilityServiceEnabled())
                        }
                    }
                    "openAccessibilitySettings" -> {
                        try {
                            startActivity(
                                Intent(Settings.ACTION_ACCESSIBILITY_SETTINGS).apply {
                                    addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                                },
                            )
                            result.success(true)
                        } catch (e: Exception) {
                            result.error("SETTINGS", e.message, null)
                        }
                    }
                    "executeAction" -> {
                        val action = call.argument<String>("action")
                        val text = call.argument<String>("text")
                        if (action.isNullOrBlank()) {
                            result.error("INVALID", "action required", null)
                            return@setMethodCallHandler
                        }
                        val service = MindTouchAccessibilityService.instance
                        if (service == null) {
                            result.success(false)
                            return@setMethodCallHandler
                        }
                        mainHandler.post {
                            try {
                                val ok = service.executeAction(action, text)
                                result.success(ok)
                            } catch (_: Exception) {
                                result.success(false)
                            }
                        }
                    }
                    else -> result.notImplemented()
                }
            }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, PLATFORM_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "startBackgroundService" -> {
                        val apiBase = call.argument<String>("api_base")
                        val deviceId = call.argument<String>("device_id")
                        if (!apiBase.isNullOrBlank() && !deviceId.isNullOrBlank()) {
                            RemoteCommandPoller.configure(this, apiBase, deviceId)
                        }
                        MindTouchForegroundService.start(this, apiBase, deviceId)
                        result.success(true)
                    }
                    "stopBackgroundService" -> {
                        MindTouchForegroundService.stop(this)
                        result.success(true)
                    }
                    "isBackgroundServiceRunning" -> {
                        result.success(MindTouchForegroundService.isRunning)
                    }
                    "updateBackgroundStatus" -> {
                        val message = call.argument<String>("message") ?: "Listening"
                        // FGS instance not static — update via bubble + notification refresh
                        FloatingBubbleService.updateMessage(this, message)
                        result.success(true)
                    }
                    "canDrawOverlays" -> {
                        result.success(FloatingBubbleService.canDrawOverlays(this))
                    }
                    "requestOverlayPermission" -> {
                        FloatingBubbleService.requestOverlayPermission(this)
                        result.success(true)
                    }
                    "showFloatingBubble" -> {
                        val message = call.argument<String>("message") ?: "MindTouch active"
                        FloatingBubbleService.show(this, message)
                        result.success(true)
                    }
                    "hideFloatingBubble" -> {
                        FloatingBubbleService.hide(this)
                        result.success(true)
                    }
                    "updateBubbleMessage" -> {
                        val message = call.argument<String>("message") ?: ""
                        FloatingBubbleService.updateMessage(this, message)
                        result.success(true)
                    }
                    "configureRemotePolling" -> {
                        val apiBase = call.argument<String>("api_base")
                        val deviceId = call.argument<String>("device_id")
                        if (!apiBase.isNullOrBlank() && !deviceId.isNullOrBlank()) {
                            RemoteCommandPoller.configure(this, apiBase, deviceId)
                        }
                        result.success(true)
                    }
                    "isBatteryOptimizationIgnored" -> {
                        result.success(isBatteryOptimizationIgnored())
                    }
                    "requestBatteryOptimization" -> {
                        requestBatteryOptimization()
                        result.success(true)
                    }
                    "getPermissionStatus" -> {
                        result.success(
                            mapOf(
                                "accessibility" to isAccessibilityServiceEnabled(),
                                "overlay" to FloatingBubbleService.canDrawOverlays(this),
                                "battery_exemption" to isBatteryOptimizationIgnored(),
                                "background_service" to MindTouchForegroundService.isRunning,
                            ),
                        )
                    }
                    else -> result.notImplemented()
                }
            }
    }

    private fun isAccessibilityServiceEnabled(): Boolean {
        val serviceName =
            "$packageName/${MindTouchAccessibilityService::class.java.canonicalName}"
        val enabledServices = Settings.Secure.getString(
            contentResolver,
            Settings.Secure.ENABLED_ACCESSIBILITY_SERVICES,
        ) ?: return false
        return enabledServices.split(':').any { it.equals(serviceName, ignoreCase = true) }
    }

    private fun isBatteryOptimizationIgnored(): Boolean {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.M) return true
        val pm = getSystemService(POWER_SERVICE) as PowerManager
        return pm.isIgnoringBatteryOptimizations(packageName)
    }

    private fun requestBatteryOptimization() {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.M) return
        if (isBatteryOptimizationIgnored()) return
        try {
            startActivity(
                Intent(Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS).apply {
                    data = Uri.parse("package:$packageName")
                    addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                },
            )
        } catch (_: Exception) {
            startActivity(
                Intent(Settings.ACTION_IGNORE_BATTERY_OPTIMIZATION_SETTINGS).apply {
                    addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                },
            )
        }
    }
}
