/*
 * Copyright (C) 2018 Baidu, Inc. All Rights Reserved.
 */
package com.baidu.ar.pro.module;

import java.util.HashMap;

import com.baidu.ar.ARController;
import com.baidu.ar.speech.listener.SpeechRecogListener;
import com.baidu.ar.util.UiThreadUtil;
import com.baidu.baiduarsdk.util.MsgParamsUtil;

import android.content.Context;
import android.util.Log;
import android.widget.RelativeLayout;

/**
 * Module 控制器
 */
public class Module {

    private Context mContext;
    //  tts 管理器
    private TtsControler ttsControler;
    //  tts 管理器
    private SpeechControler speechControler;

    private SpeechRecogListener speechRecogListener;

    private ARController mARController;

    private RelativeLayout mPluginContainer;

    public Module(Context context, ARController arController) {
        mContext = context;
        mARController = arController;
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
                        speechControler = new SpeechControler(mContext, speechRecogListener, mARController);
                        UiThreadUtil.runOnUiThread(new Runnable() {
                            public void run() {
                                speechControler.initView(mPluginContainer);
                            }
                        });
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

    public void setSpeechRecogListener(SpeechRecogListener speechRecogListener) {
        this.speechRecogListener = speechRecogListener;
    }


    public void parseResult(String result) {
        if (null != speechControler) {
            speechControler.parseResult(result);
        }
    }

    public void setPluginContainer(RelativeLayout pluginContainer) {
        mPluginContainer = pluginContainer;
    }

    public void setVoiceStatus(int status) {
        if (null != speechControler) {
            speechControler.setVoiceStatus(status);
        }
    }

}
