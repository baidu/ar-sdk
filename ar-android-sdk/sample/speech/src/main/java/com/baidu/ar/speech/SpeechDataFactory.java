package com.baidu.ar.speech;

import java.io.InputStream;

import android.util.Log;

/**
 * Created by xgx on 2017/8/3.
 * 音频源共享给语音sdk
 */
public class SpeechDataFactory {
    private static final String TAG = SpeechDataFactory.class.getSimpleName();

    private static InputStream mAudioInputStream;

    public static void setAudioInputStream(InputStream audioInputStream) {
        Log.e(TAG, " setAudioInputStream ");
        SpeechDataFactory.mAudioInputStream = audioInputStream;
    }

    public static InputStream create8kInputStream() {
        Log.e(TAG, " create8kInputStream ");
        if (mAudioInputStream == null) {
            Log.e(TAG, " create8kInputStream mAudioInputStream is null !!!");
        }
        return mAudioInputStream;
    }

    public static void release() {
        mAudioInputStream = null;
    }

}
