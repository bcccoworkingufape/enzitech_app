package com.lohhans.enzitech

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val channelName = "enzitech/screen_protection"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "enableSecure" -> {
                        runOnUiThread {
                            window.setFlags(
                                android.view.WindowManager.LayoutParams.FLAG_SECURE,
                                android.view.WindowManager.LayoutParams.FLAG_SECURE
                            )
                            result.success(true)
                        }
                    }
                    "disableSecure" -> {
                        runOnUiThread {
                            window.clearFlags(android.view.WindowManager.LayoutParams.FLAG_SECURE)
                            result.success(true)
                        }
                    }
                    else -> result.notImplemented()
                }
            }
    }
}
