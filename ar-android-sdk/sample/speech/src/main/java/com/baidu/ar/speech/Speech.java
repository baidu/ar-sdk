/*
 * Copyright (C) 2017 Baidu, Inc. All Rights Reserved.
 */
package com.baidu.ar.speech;

import java.util.HashMap;

import org.json.JSONObject;

import com.baidu.mms.voicesearch.invoke.voicerecognition.IVoiceRecognitionCallback;
import com.baidu.speech.EventListener;
import com.baidu.speech.EventManager;
import com.baidu.speech.EventManagerFactory;
import com.baidu.speech.asr.SpeechConstant;

import android.content.Context;

/**
 * Created by xgx on 2017/6/9.
 * 声音识别
 */
public class Speech {

    private Context mContext;

    private EventManager mEventManager;

    // 是否sdk层来显示语音错误信息
    private boolean showErrorTips = true;

    private SpeechStatus mSpeechStatus = SpeechStatus.SPEECH_IDLE;

    public enum SpeechStatus {
        SPEECH_IDLE,
        SPEECH_INIT,
        SPEECH_OPEN,
        SPEECH_CANCEL,
    }

    private Speech(Context context) {
        mContext = context;

    }

    public void startARListener(HashMap map) {
        if (null != mEventManager) {
            // 开始识别
            mEventManager.send(SpeechConstant.ASR_START, new JSONObject(map).toString(), null, 0, 0);
        }
    }

    /**
     * 停止语音识别
     *
     * @param ivoiceRecognitionCallback 可为null
     */
    public void cancel(IVoiceRecognitionCallback ivoiceRecognitionCallback) {
        if (null != mEventManager) {
            mEventManager.send(SpeechConstant.ASR_CANCEL, new JSONObject().toString(), null, 0, 0);
        }
    }

    public void destroy() {
        mEventManager = null;
        releaseAudioInputStream();
        mContext = null;
    }

    public void setARRecognitionListener(EventListener listener) {
        if (null == mEventManager) {
            mEventManager = EventManagerFactory.create(mContext, "asr");
        }
        mEventManager.registerListener(listener);
    }

    public SpeechStatus getSpeechStatus() {
        return mSpeechStatus;
    }

    public void setSpeechStatus(SpeechStatus status) {
        mSpeechStatus = status;
    }

    public static void releaseAudioInputStream() {
        if (SpeechDataFactory.create8kInputStream() != null) {
            ((AudioInputStream) SpeechDataFactory.create8kInputStream()).closeByUser();
        }
        SpeechDataFactory.release();
    }
}
