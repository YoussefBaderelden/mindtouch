package com.mindtouch.client

import android.content.Intent
import android.os.Handler
import android.os.Looper
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    companion object {
        private const val CHANNEL = "com.mindtouch/phone_control"
    }

    private val mainHandler = Handler(Looper.getMainLooper())

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
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
                            } catch (e: Exception) {
                                result.success(false)
                            }
                        }
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
}
