package com.aiweekmobile  // ← 실제 패키지명 확인

import android.app.NotificationChannel
import android.app.NotificationManager
import android.os.Build
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    override fun onStart() {
        super.onStart()
        createNotificationChannel()
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                "activity_service_channel",   // ID
                "Activity Service",           // 이름 (설정 > 알림 > 채널명에 보임)
                NotificationManager.IMPORTANCE_LOW
            ).apply {
                description = "Background activity tracking service"
                setShowBadge(false)
            }

            val manager = getSystemService(NotificationManager::class.java)
            manager?.createNotificationChannel(channel)
        }
    }
}