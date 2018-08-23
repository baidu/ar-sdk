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
import android.widget.RelativeLayout;
import android.widget.Toast;

/**
 * Module 控制器
 */
public class Module {

    private Context mContext;
    //  tts 管理器
    private TtsController ttsControler;
    //  speech 管理器
    private SpeechController speechControler;

    private SpeechRecogListener speechRecogListener;

    private ARController mARController;

    private RelativeLayout mPluginContainer;
    // logo 管理器
    private LogoController logoController;

    // 业务层自定义参数 接收lua数据
    private int mSource;

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
                        ttsControler = new TtsController(mContext);
                    }
                    ttsControler.parseMessage(luaMsg);
                    break;
                case MsgType.MSG_TYPE_VOICE_START:
                case MsgType.MSG_TYPE_VOICE_CLOSE:
                case MsgType.MSG_TYPE_VOICE_SHOW_MIC_ICON:
                case MsgType.MSG_TYPE_VOICE_HIDE_MIC_ICON:
                    if (speechControler == null) {
                        speechControler = new SpeechController(mContext, speechRecogListener, mARController);
                        UiThreadUtil.runOnUiThread(new Runnable() {
                            public void run() {
                                speechControler.initView(mPluginContainer);
                            }
                        });
                    }
                    speechControler.parseMessage(luaMsg);
                    break;
                case MsgType.MSG_TYPE_THIRD:
                    final int source = MsgParamsUtil.obj2Int(luaMsg.get("source"), 0);
                    mSource += source;
                    UiThreadUtil.runOnUiThread(new Runnable() {
                        public void run() {
                            Toast.makeText(mContext, mSource + "", Toast.LENGTH_SHORT).show();
                        }
                    });
                    break;
                case MsgType.MSG_TYPE_LOGO_START:
                    if (null == logoController) {
                        logoController = new LogoController(mContext, mARController);
                    }
                    // 展示logo是别的扫描框
                    logoController.attchView();
                    break;
                case MsgType.MSG_TYPE_LOGO_STOP:
                    if (null == logoController) {
                        logoController = new LogoController(mContext, mARController);
                    }
                    // 展示logo是别的扫描框
                    logoController.attchView();
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
        if (speechControler != null) {
            speechControler.stopVoice();
        }
        if (logoController != null) {
            logoController.release();
        }
    }

    public void onResume() {
        if (ttsControler != null) {
            ttsControler.resume();
        }
        if (logoController != null) {
            logoController.onResume();
        }
    }

    public void onPause() {
        if (ttsControler != null) {
            ttsControler.pause();
        }
        if (logoController != null) {
            logoController.onPause();
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
