package com.noorayah.app

import android.content.Context
import android.media.AudioManager
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        
        // إعدادات الصوت
        setupAudioSettings()
    }
    
    private fun setupAudioSettings() {
        try {
            val audioManager = getSystemService(Context.AUDIO_SERVICE) as AudioManager
            
            // طلب التركيز على الصوت
            audioManager.requestAudioFocus(
                null,
                AudioManager.STREAM_MUSIC,
                AudioManager.AUDIOFOCUS_GAIN_TRANSIENT_MAY_DUCK
            )
            
            // تعيين وضع الصوت
            audioManager.mode = AudioManager.MODE_NORMAL
            
        } catch (e: Exception) {
            // تجاهل الأخطاء في إعدادات الصوت
        }
    }
}

