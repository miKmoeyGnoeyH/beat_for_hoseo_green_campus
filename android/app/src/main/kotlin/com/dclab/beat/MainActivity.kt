package com.dclab.beat  // ← 실제 패키지명으로 수정

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.beat.walkreport/channel"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "startBackgroundTasks" -> {
                        // TODO: 안드로이드에서 백그라운드 위치/걸음수 서비스 시작
                        result.success("Background tasks started on Android")
                    }
                    "stopBackgroundTasks" -> {
                        // TODO: 안드로이드에서 백그라운드 위치/걸음수 서비스 중지
                        result.success("Background tasks stopped on Android")
                    }
                    else -> result.notImplemented()
                }
            }
    }
}