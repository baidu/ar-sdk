/*
 * Copyright (C) 2018 Baidu, Inc. All Rights Reserved.
 */
package com.baidu.ar.pro.module;

import java.util.HashMap;

import com.baidu.baiduarsdk.util.MsgParamsUtil;

import android.content.Context;

/**
 * Module 控制器
 */
public class Module {

    private Context mContext;
    //  tts 管理器
    private TtsControler ttsControler;
    //  tts 管理器
    private SpeechControler speechControler;

    public Module(Context context) {
        mContext = context;
    }

    public void parseLuaMessage(HashMap<String, Object> luaMsg) {
        if (null != luaMsg) {
            int id = MsgParamsUtil.obj2Int(luaMsg.get("id"), -1);
            switch (id) {
                case MsgType.MSG_TYPE_TTS_SPEAK:
                case MsgType.MSG_TYPE_TTS_STOP:
                case MsgType.MSG_TYPE_TTS_PAUSE:
                case MsgType.MSG_TYPE_TTS_RESUME:
                    if (ttsControler == null) {
                        ttsControler = new TtsControler(mContext);
                    }
                    ttsControler.parseMessage(luaMsg);
                    break;
                case MsgType.MSG_TYPE_VOICE_START:
                case MsgType.MSG_TYPE_VOICE_CLOSE:
                case MsgType.MSG_TYPE_VOICE_SHOW_MIC_ICON:
                case MsgType.MSG_TYPE_VOICE_HIDE_MIC_ICON:
                    if (speechControler == null) {
                        speechControler = new SpeechControler(mContext);
                    }
                    speechControler.parseMessage(luaMsg);
                    break;
                default:
                    break;
            }
        }
    }

    public void onRelease() {
        if (ttsControler != null) {
            ttsControler.stop();
        }
    }

    public void onResume() {
        if (ttsControler != null) {
            ttsControler.resume();
        }
    }

    public void onPause() {
        if (ttsControler != null) {
            ttsControler.pause();
        }
    }
}
