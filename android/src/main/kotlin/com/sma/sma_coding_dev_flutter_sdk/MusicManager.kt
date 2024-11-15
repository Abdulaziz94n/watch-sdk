package com.sma.sma_coding_dev_flutter_sdk

import android.annotation.SuppressLint
import android.content.Context
import com.bestmafen.baseble.util.BleLog
import com.szabh.smable3.music.MusicControllerCompat

object MusicManager {
    private const val TAG = "MusicManager"

    @SuppressLint("StaticFieldLeak")
    var mMusicControlCompat: MusicControllerCompat? = null

    fun startMusicController(context: Context) {
        val isRunning = isMusicControllerRunning()
        BleLog.d("$TAG startMusicController isRunning:$isRunning")
        if (isRunning) return
        mMusicControlCompat = MusicControllerCompat.newInstance().also { it.launch(context) }
    }

    fun stopMusicController() {
        BleLog.d("$TAG stopMusicController")
        mMusicControlCompat?.exit()
        mMusicControlCompat = null
    }

    fun isMusicControllerRunning(): Boolean {
        return mMusicControlCompat != null
    }
}