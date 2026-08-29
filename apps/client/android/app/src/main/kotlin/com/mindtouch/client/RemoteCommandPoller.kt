package com.mindtouch.client

import android.content.Context
import android.os.Handler
import android.os.Looper
import android.util.Log
import org.json.JSONObject
import java.io.BufferedReader
import java.io.InputStreamReader
import java.io.OutputStreamWriter
import java.net.HttpURLConnection
import java.net.URL
import java.net.URLEncoder
import java.util.concurrent.atomic.AtomicBoolean

/** Polls the MindTouch API from the foreground service — survives app backgrounding. */
object RemoteCommandPoller {
    private const val TAG = "MindTouchPoll"
    private const val PREFS = "mindtouch_remote"
    private const val POLL_MS = 400L

    private val running = AtomicBoolean(false)
    private var worker: Thread? = null
    private val mainHandler = Handler(Looper.getMainLooper())

    fun configure(context: Context, apiBase: String, deviceId: String) {
        context.getSharedPreferences(PREFS, Context.MODE_PRIVATE)
            .edit()
            .putString("api_base", apiBase.trimEnd('/'))
            .putString("device_id", deviceId)
            .apply()
    }

    fun start(context: Context) {
        if (!running.compareAndSet(false, true)) return
        val appCtx = context.applicationContext
        worker = Thread({
            while (running.get()) {
                try {
                    pollOnce(appCtx)
                } catch (e: Exception) {
                    Log.w(TAG, "poll loop: ${e.message}")
                }
                try {
                    Thread.sleep(POLL_MS)
                } catch (_: InterruptedException) {
                    Thread.currentThread().interrupt()
                    break
                }
            }
        }, "MindTouchRemotePoll").also { it.start() }
        Log.i(TAG, "Native remote polling started")
    }

    fun stop() {
        running.set(false)
        worker?.interrupt()
        worker = null
    }

    fun reportTypingPreview(context: Context, preview: String) {
        val prefs = context.getSharedPreferences(PREFS, Context.MODE_PRIVATE)
        val apiBase = prefs.getString("api_base", null) ?: return
        val deviceId = prefs.getString("device_id", null) ?: return
        Thread {
            try {
                postJson(
                    "$apiBase/api/phone/typing",
                    JSONObject()
                        .put("device_id", deviceId)
                        .put("preview", preview)
                        .toString(),
                )
            } catch (e: Exception) {
                Log.w(TAG, "typing preview: ${e.message}")
            }
        }.start()
    }

    private fun pollOnce(context: Context) {
        val prefs = context.getSharedPreferences(PREFS, Context.MODE_PRIVATE)
        val apiBase = prefs.getString("api_base", null) ?: return
        val deviceId = prefs.getString("device_id", null) ?: return
        if (deviceId.isBlank()) return

        val encodedId = URLEncoder.encode(deviceId, "UTF-8")
        val pollUrl =
            "$apiBase/api/phone/poll?device_id=$encodedId&name=${URLEncoder.encode("MindTouch Phone", "UTF-8")}"
        val body = get(pollUrl) ?: return
        val json = JSONObject(body)
        if (json.optString("status") != "command") return

        val command = json.optJSONObject("command") ?: return
        val action = command.optString("action")
        val text = command.optString("text").ifBlank { null }
        val commandId = command.optString("command_id")

        var ok = false
        val latch = java.util.concurrent.CountDownLatch(1)
        mainHandler.post {
            try {
                val service = MindTouchAccessibilityService.instance
                ok = service?.executeAction(action, text) ?: false
            } catch (e: Exception) {
                Log.e(TAG, "execute $action", e)
            } finally {
                latch.countDown()
            }
        }
        latch.await(8, java.util.concurrent.TimeUnit.SECONDS)

        postJson(
            "$apiBase/api/phone/ack",
            JSONObject()
                .put("device_id", deviceId)
                .put("command_id", commandId)
                .put("status", if (ok) "ok" else "failed")
                .put("action", action)
                .toString(),
        )
    }

    private fun get(url: String): String? {
        val conn = (URL(url).openConnection() as HttpURLConnection).apply {
            requestMethod = "GET"
            connectTimeout = 8000
            readTimeout = 8000
        }
        return try {
            val code = conn.responseCode
            val stream = if (code in 200..299) conn.inputStream else conn.errorStream
            stream?.bufferedReader()?.use { it.readText() }
        } finally {
            conn.disconnect()
        }
    }

    private fun postJson(url: String, body: String) {
        val conn = (URL(url).openConnection() as HttpURLConnection).apply {
            requestMethod = "POST"
            connectTimeout = 8000
            readTimeout = 8000
            doOutput = true
            setRequestProperty("Content-Type", "application/json")
        }
        try {
            OutputStreamWriter(conn.outputStream, Charsets.UTF_8).use { it.write(body) }
            conn.responseCode
            conn.inputStream?.close()
        } finally {
            conn.disconnect()
        }
    }
}
