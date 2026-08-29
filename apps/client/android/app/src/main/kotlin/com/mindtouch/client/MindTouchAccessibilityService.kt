package com.mindtouch.client

import android.accessibilityservice.AccessibilityService
import android.accessibilityservice.GestureDescription
import android.content.ClipData
import android.content.ClipboardManager
import android.content.Context
import android.graphics.Path
import android.os.Build
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.util.Log
import android.view.accessibility.AccessibilityEvent
import android.view.accessibility.AccessibilityNodeInfo
import java.util.concurrent.atomic.AtomicBoolean

/**
 * Accessibility execution layer — all actions serialized on the main thread
 * with a minimum gap to prevent gesture pile-up and service instability.
 */
class MindTouchAccessibilityService : AccessibilityService() {

    companion object {
        private const val TAG = "MindTouchA11y"
        private const val MIN_ACTION_GAP_MS = 160L
        private const val MAX_QUEUE_SIZE = 8

        @Volatile
        var instance: MindTouchAccessibilityService? = null
            private set
    }

    private val mainHandler = Handler(Looper.getMainLooper())
    private val isProcessing = AtomicBoolean(false)
    private val actionQueue = ArrayDeque<QueuedAction>()
    @Volatile
    private var lastActionAt = 0L

    override fun onServiceConnected() {
        super.onServiceConnected()
        instance = this
        Log.i(TAG, "Service connected")
    }

    override fun onDestroy() {
        actionQueue.clear()
        instance = null
        super.onDestroy()
    }

    override fun onAccessibilityEvent(event: AccessibilityEvent?) {}

    override fun onInterrupt() {
        actionQueue.clear()
    }

    fun executeAction(action: String, text: String? = null): Boolean {
        if (Looper.myLooper() != Looper.getMainLooper()) {
            var result = false
            val latch = java.util.concurrent.CountDownLatch(1)
            mainHandler.post {
                result = enqueueAction(action, text)
                latch.countDown()
            }
            try {
                latch.await(2, java.util.concurrent.TimeUnit.SECONDS)
            } catch (_: InterruptedException) {
                Thread.currentThread().interrupt()
            }
            return result
        }
        return enqueueAction(action, text)
    }

    private fun enqueueAction(action: String, text: String?): Boolean {
        if (action == "exit_app") {
            listOf("back", "back", "home").forEach { step ->
                if (actionQueue.size >= MAX_QUEUE_SIZE) {
                    actionQueue.removeFirst()
                }
                actionQueue.addLast(QueuedAction(step, null))
            }
            drainQueue()
            return true
        }
        if (action == "type_message") {
            val message = text ?: ""
            if (actionQueue.size >= MAX_QUEUE_SIZE) actionQueue.removeFirst()
            actionQueue.addLast(QueuedAction("show_keyboard", null))
            message.forEach { ch ->
                if (actionQueue.size >= MAX_QUEUE_SIZE) actionQueue.removeFirst()
                actionQueue.addLast(QueuedAction("type_char", ch.toString()))
            }
            drainQueue()
            return true
        }
        if (actionQueue.size >= MAX_QUEUE_SIZE) {
            actionQueue.removeFirst()
        }
        actionQueue.addLast(QueuedAction(action, text))
        drainQueue()
        return true
    }

    private fun drainQueue() {
        if (isProcessing.get()) return
        if (actionQueue.isEmpty()) return

        isProcessing.set(true)
        val item = actionQueue.removeFirst()

        val now = System.currentTimeMillis()
        val delay = (MIN_ACTION_GAP_MS - (now - lastActionAt)).coerceAtLeast(0L)

        mainHandler.postDelayed({
            try {
                runAction(item.action, item.text)
            } catch (e: Exception) {
                Log.e(TAG, "Action failed: ${item.action}", e)
            } finally {
                lastActionAt = System.currentTimeMillis()
                isProcessing.set(false)
                if (actionQueue.isNotEmpty()) drainQueue()
            }
        }, delay)
    }

    private fun runAction(action: String, text: String?) {
        when (action) {
            "tap_center" -> tapRelative(0.5f, 0.5f)
            "tap_top" -> tapRelative(0.5f, 0.2f)
            "tap_bottom" -> tapRelative(0.5f, 0.8f)
            "tap_left" -> tapRelative(0.2f, 0.5f)
            "tap_right" -> tapRelative(0.8f, 0.5f)
            "double_tap" -> doubleTapCenter()
            "long_press" -> tapRelative(0.5f, 0.5f, 700L)
            "scroll_up" -> swipeRelative(0.5f, 0.35f, 0.5f, 0.72f)
            "scroll_down" -> swipeRelative(0.5f, 0.72f, 0.5f, 0.35f)
            "scroll_left" -> swipeRelative(0.28f, 0.5f, 0.72f, 0.5f)
            "scroll_right" -> swipeRelative(0.72f, 0.5f, 0.28f, 0.5f)
            "swipe_up" -> swipeRelative(0.5f, 0.78f, 0.5f, 0.22f, 280L)
            "swipe_down" -> swipeRelative(0.5f, 0.22f, 0.5f, 0.78f, 280L)
            "swipe_left" -> swipeRelative(0.78f, 0.5f, 0.22f, 0.5f, 280L)
            "swipe_right" -> swipeRelative(0.22f, 0.5f, 0.78f, 0.5f, 280L)
            "back" -> performGlobalAction(GLOBAL_ACTION_BACK)
            "home" -> performGlobalAction(GLOBAL_ACTION_HOME)
            "recents" -> performGlobalAction(GLOBAL_ACTION_RECENTS)
            "notifications" -> performGlobalAction(GLOBAL_ACTION_NOTIFICATIONS)
            "quick_settings" -> performGlobalAction(GLOBAL_ACTION_QUICK_SETTINGS)
            "enter" -> pressEnter()
            "delete" -> deleteChar()
            "type_text" -> typeText(text ?: "")
            "type_char" -> appendChar(text ?: "")
            "type_message" -> true
            "show_keyboard" -> showKeyboardAndFocus()
            "clear_text" -> clearFocusedText()
            "paste" -> pasteText()
            "select_all" -> selectAll()
            "focus_search" -> focusSearch()
            else -> Log.w(TAG, "Unknown action: $action")
        }
    }

    private data class QueuedAction(val action: String, val text: String?)

    private fun displaySize(): Pair<Int, Int> {
        val metrics = resources.displayMetrics
        return metrics.widthPixels to metrics.heightPixels
    }

    private fun tapRelative(xRatio: Float, yRatio: Float, durationMs: Long = 48L) {
        val (w, h) = displaySize()
        dispatchTap(w * xRatio, h * yRatio, durationMs)
    }

    private fun doubleTapCenter() {
        val (w, h) = displaySize()
        val x = w * 0.5f
        val y = h * 0.5f
        dispatchTap(x, y, 40)
        mainHandler.postDelayed({ dispatchTap(x, y, 40) }, 120)
    }

    private fun swipeRelative(
        startXRatio: Float,
        startYRatio: Float,
        endXRatio: Float,
        endYRatio: Float,
        durationMs: Long = 320L,
    ) {
        val (w, h) = displaySize()
        dispatchSwipe(
            w * startXRatio,
            h * startYRatio,
            w * endXRatio,
            h * endYRatio,
            durationMs,
        )
    }

    private fun dispatchTap(x: Float, y: Float, durationMs: Long) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.N) return
        val path = Path().apply { moveTo(x, y) }
        val stroke = GestureDescription.StrokeDescription(path, 0, durationMs)
        val gesture = GestureDescription.Builder().addStroke(stroke).build()
        dispatchGesture(gesture, null, null)
    }

    private fun dispatchSwipe(
        startX: Float,
        startY: Float,
        endX: Float,
        endY: Float,
        durationMs: Long,
    ) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.N) return
        val path = Path().apply {
            moveTo(startX, startY)
            lineTo(endX, endY)
        }
        val stroke = GestureDescription.StrokeDescription(path, 0, durationMs)
        val gesture = GestureDescription.Builder().addStroke(stroke).build()
        dispatchGesture(gesture, null, null)
    }

    private fun focusedEditable(): AccessibilityNodeInfo? {
        var focused: AccessibilityNodeInfo? = null
        try {
            focused = findFocus(AccessibilityNodeInfo.FOCUS_INPUT)
            if (focused != null && focused.isEditable) return focused
            focused?.recycle()

            val root = rootInActiveWindow ?: return null
            return findEditableNode(root)
        } catch (e: Exception) {
            Log.e(TAG, "focusedEditable error", e)
            return null
        }
    }

    private fun findEditableNode(node: AccessibilityNodeInfo): AccessibilityNodeInfo? {
        if (node.isEditable) return AccessibilityNodeInfo.obtain(node)
        for (i in 0 until node.childCount) {
            val child = node.getChild(i) ?: continue
            try {
                findEditableNode(child)?.let { return it }
            } finally {
                child.recycle()
            }
        }
        return null
    }

    private var liveTypingPreview = StringBuilder()

    private fun showKeyboardAndFocus(): Boolean {
        val focused = focusSearch()
        if (!focused) {
            val root = rootInActiveWindow ?: return false
            try {
                val editable = findEditableNode(root)
                if (editable != null) {
                    try {
                        editable.performAction(AccessibilityNodeInfo.ACTION_FOCUS)
                        editable.performAction(AccessibilityNodeInfo.ACTION_CLICK)
                    } finally {
                        editable.recycle()
                    }
                }
            } finally {
                root.recycle()
            }
        }
        return if (Build.VERSION.SDK_INT >= 33) {
            @Suppress("DEPRECATION")
            performGlobalAction(29) // GLOBAL_ACTION_SHOW_SOFT_KEYBOARD
        } else {
            true
        }
    }

    private fun appendChar(ch: String): Boolean {
        if (ch.isEmpty()) return false
        val node = focusedEditable() ?: return false
        return try {
            val current = node.text?.toString() ?: ""
            val next = current + ch
            val args = Bundle()
            args.putCharSequence(
                AccessibilityNodeInfo.ACTION_ARGUMENT_SET_TEXT_CHARSEQUENCE,
                next,
            )
            val ok = node.performAction(AccessibilityNodeInfo.ACTION_SET_TEXT, args)
            if (ok) {
                liveTypingPreview.append(ch)
                val preview = liveTypingPreview.toString()
                FloatingBubbleService.updateMessage(applicationContext, "⌨ $preview")
                RemoteCommandPoller.reportTypingPreview(applicationContext, preview)
            }
            ok
        } finally {
            node.recycle()
        }
    }

    private fun clearFocusedText(): Boolean {
        liveTypingPreview.clear()
        RemoteCommandPoller.reportTypingPreview(applicationContext, "")
        val node = focusedEditable() ?: return false
        return try {
            val args = Bundle()
            args.putCharSequence(
                AccessibilityNodeInfo.ACTION_ARGUMENT_SET_TEXT_CHARSEQUENCE,
                "",
            )
            node.performAction(AccessibilityNodeInfo.ACTION_SET_TEXT, args)
        } finally {
            node.recycle()
        }
    }

    private fun typeText(text: String): Boolean {
        if (text.isEmpty()) return false
        liveTypingPreview.clear()
        liveTypingPreview.append(text)
        RemoteCommandPoller.reportTypingPreview(applicationContext, text)
        FloatingBubbleService.updateMessage(applicationContext, "⌨ $text")
        val node = focusedEditable() ?: return pasteViaClipboard(text)
        return try {
            val args = Bundle()
            args.putCharSequence(
                AccessibilityNodeInfo.ACTION_ARGUMENT_SET_TEXT_CHARSEQUENCE,
                text,
            )
            node.performAction(AccessibilityNodeInfo.ACTION_SET_TEXT, args)
        } finally {
            node.recycle()
        }
    }

    private fun pasteViaClipboard(text: String): Boolean {
        return try {
            val clipboard = getSystemService(Context.CLIPBOARD_SERVICE) as ClipboardManager
            clipboard.setPrimaryClip(ClipData.newPlainText("mindtouch", text))
            val node = focusedEditable() ?: return false
            try {
                node.performAction(AccessibilityNodeInfo.ACTION_PASTE)
            } finally {
                node.recycle()
            }
        } catch (e: Exception) {
            Log.e(TAG, "pasteViaClipboard error", e)
            false
        }
    }

    private fun pasteText(): Boolean {
        val node = focusedEditable() ?: return false
        return try {
            node.performAction(AccessibilityNodeInfo.ACTION_PASTE)
        } finally {
            node.recycle()
        }
    }

    private fun deleteChar(): Boolean {
        val node = focusedEditable() ?: return false
        return try {
            val current = node.text?.toString() ?: return false
            if (current.isEmpty()) return false
            val args = Bundle()
            args.putCharSequence(
                AccessibilityNodeInfo.ACTION_ARGUMENT_SET_TEXT_CHARSEQUENCE,
                current.dropLast(1),
            )
            node.performAction(AccessibilityNodeInfo.ACTION_SET_TEXT, args)
        } finally {
            node.recycle()
        }
    }

    private fun pressEnter(): Boolean {
        val node = focusedEditable()
        if (node != null) {
            try {
                val current = node.text?.toString() ?: ""
                val args = Bundle()
                args.putCharSequence(
                    AccessibilityNodeInfo.ACTION_ARGUMENT_SET_TEXT_CHARSEQUENCE,
                    "$current\n",
                )
                if (node.performAction(AccessibilityNodeInfo.ACTION_SET_TEXT, args)) {
                    return true
                }
            } finally {
                node.recycle()
            }
        }
        tapRelative(0.9f, 0.92f)
        return true
    }

    private fun selectAll(): Boolean {
        val node = focusedEditable() ?: return false
        return try {
            node.performAction(AccessibilityNodeInfo.ACTION_SELECT)
        } finally {
            node.recycle()
        }
    }

    private fun focusSearch(): Boolean {
        val root = rootInActiveWindow ?: return false
        return try {
            val search = findNodeByText(
                root,
                listOf("Search", "search", "Type a message", "Message", "message"),
            )
            search?.let {
                val ok = it.performAction(AccessibilityNodeInfo.ACTION_FOCUS) ||
                    it.performAction(AccessibilityNodeInfo.ACTION_CLICK)
                it.recycle()
                ok
            } ?: false
        } catch (e: Exception) {
            Log.e(TAG, "focusSearch error", e)
            false
        } finally {
            root.recycle()
        }
    }

    private fun findNodeByText(
        node: AccessibilityNodeInfo,
        texts: List<String>,
    ): AccessibilityNodeInfo? {
        val nodeText = node.text?.toString() ?: ""
        val contentDesc = node.contentDescription?.toString() ?: ""
        if (texts.any {
                nodeText.contains(it, ignoreCase = true) ||
                    contentDesc.contains(it, ignoreCase = true)
            }
        ) {
            if (node.isClickable || node.isEditable || node.isFocusable) {
                return AccessibilityNodeInfo.obtain(node)
            }
        }
        for (i in 0 until node.childCount) {
            val child = node.getChild(i) ?: continue
            try {
                findNodeByText(child, texts)?.let { return it }
            } finally {
                child.recycle()
            }
        }
        return null
    }
}
