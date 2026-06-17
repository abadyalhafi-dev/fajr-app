package com.example.fajr_app

import android.view.KeyEvent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val channelName = "fajr_app/volume"
    private var channel: MethodChannel? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        channel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            channelName
        )
    }

    // Forward volume key presses to Flutter. We do NOT consume the event
    // (return super), so normal volume behaviour still works when no alarm
    // is ringing. The ringing screen listens and dismisses when shown.
    override fun onKeyDown(keyCode: Int, event: KeyEvent?): Boolean {
        if (keyCode == KeyEvent.KEYCODE_VOLUME_UP ||
            keyCode == KeyEvent.KEYCODE_VOLUME_DOWN
        ) {
            channel?.invokeMethod("volumeButtonPressed", null)
        }
        return super.onKeyDown(keyCode, event)
    }
}
