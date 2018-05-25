/*
 * Copyright (C) 2018 Baidu, Inc. All Rights Reserved.
 */
package com.baidu.ar.pro.module;

import java.util.HashMap;

import com.baidu.ar.tts.TTSCallback;
import com.baidu.ar.tts.Tts;
import com.baidu.baiduarsdk.util.MsgParamsUtil;

import android.content.Context;

/**
 * tts控制器
 * 参考case:
 */
public class TtsControler {

    protected String appId = "10315470";
    protected String appKey = "bgW5575sEj5m9CHEatxTGln6";
    protected String secretKey = "kD9VCx8q56s3lAaAk0juQtkFfXj3Xsp4";

    private Tts mTts;

    public TtsControler(Context context) {
        mTts = new Tts(context, appId, appKey, secretKey);
    }

    public void parseMessage(HashMap<String, Object> luaMsg) {
        if (null != luaMsg) {
            int id = MsgParamsUtil.obj2Int(luaMsg.get("id"), -1);
            switch (id) {
                case MsgType.MSG_TYPE_TTS_SPEAK:
                    startTts(luaMsg);
                    break;
                case MsgType.MSG_TYPE_TTS_STOP:
                    stop();
                    break;
                case MsgType.MSG_TYPE_TTS_PAUSE:
                    pause();
                    break;
                case MsgType.MSG_TYPE_TTS_RESUME:
                    resume();
                    break;
            }

        }
    }

    public void startTts(HashMap<String, Object> luaMsg) {
        String text = (String) luaMsg.get("tts");
        String speaker = String.valueOf(luaMsg.get("speaker"));
        String speed = String.valueOf(luaMsg.get("speed"));
        String volume = String.valueOf(luaMsg.get("volume"));
        if (text != null) {
            mTts.setup(speaker, speed, volume);
            mTts.speak(text, new TTSCallback() {
                @Override
                public void onTtsStarted() {
                    // TODO: 2018/5/23 开始播放
                }

                @Override
                public void onTtsFinish() {
                    // TODO: 2018/5/23 播放完成
                }

                @Override
                public void onTtsError(int errorCode) {
                    // TODO: 2018/5/23 播放异常
                }
            });
        }
    }

    public void stop() {
        mTts.stop();
    }

    public void pause() {
        mTts.pause();
    }

    public void resume() {
        mTts.resume();
    }

}
