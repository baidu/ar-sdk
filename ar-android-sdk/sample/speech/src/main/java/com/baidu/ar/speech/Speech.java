/*
 * Copyright (C) 2017 Baidu, Inc. All Rights Reserved.
 */
package com.baidu.ar.speech;

import java.util.Map;

import org.json.JSONObject;

import com.baidu.ar.speech.listener.RecogResult;
import com.baidu.ar.speech.listener.SpeechRecogListener;
import com.baidu.speech.EventListener;
import com.baidu.speech.EventManager;
import com.baidu.speech.EventManagerFactory;
import com.baidu.speech.asr.SpeechConstant;

import android.content.Context;
import android.util.Log;

/**
 * Created by xgx on 2017/6/9.
 * 声音识别
 */
public class Speech implements EventListener {

    private Context mContext;
    /**
     * SDK 内部核心 EventManager 类
     */
    private EventManager asr;

    private SpeechRecogListener speechRecogListener;

    public Speech(Context context, SpeechRecogListener speechRecogListener) {
        mContext = context;
        asr = EventManagerFactory.create(context, "asr");
        asr.registerListener(this);
        this.speechRecogListener = speechRecogListener;

    }

    public void start(Map<String, Object> params) {
        String json = new JSONObject(params).toString();
        asr.send(SpeechConstant.ASR_START, json, null, 0, 0);
    }

    /**
     * 提前结束录音等待识别结果。
     */
    public void stop() {
        asr.send(SpeechConstant.ASR_STOP, "{}", null, 0, 0);
    }

    /**
     * 取消本次识别，取消后将立即停止不会返回识别结果。
     * cancel 与stop的区别是 cancel在stop的基础上，完全停止整个识别流程，
     */
    public void cancel() {
        if (asr != null) {
            asr.send(SpeechConstant.ASR_CANCEL, "{}", null, 0, 0);
        }
    }

    //   EventListener  回调方法
    @Override
    public void onEvent(String name, String params, byte[] data, int offset, int length) {
        String logTxt = "name: " + name;
        Log.e("status = ", "" + name);

        if (params != null && !params.isEmpty()) {
            logTxt += " ;params :" + params;
        }
        if (name.equals(SpeechConstant.CALLBACK_EVENT_ASR_PARTIAL)) {
            if (params.contains("\"nlu_result\"")) {
                if (length > 0 && data.length > 0) {
                    logTxt += ", 语义解析结果：" + new String(data, offset, length);
                }
            }
        } else if (data != null) {
            logTxt += " ;data length=" + data.length;
        }
        printLog(logTxt);
        if (speechRecogListener != null) {
            speechRecogListener.onSpeechRecog(name, params);
        }
    }

    private void printLog(String text) {
        Log.e("status", text);
    }
}
