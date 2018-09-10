/*
 * Copyright (C) 2018 Baidu, Inc. All Rights Reserved.
 */
package com.baidu.ar.pro.module;

import java.util.HashMap;

import com.baidu.ar.tts.TTSCallback;
import com.baidu.ar.tts.Tts;
import com.baidu.ar.util.UiThreadUtil;
import com.baidu.baiduarsdk.util.MsgParamsUtil;

import android.content.Context;
import android.widget.Toast;

/**
 * tts控制器
 * 参考case:
 */
public class TtsController {

    /**
     * 用户自定义设置appId，appKey，secretKey
     * http://ai.baidu.com/sdk#tts
     */
    protected String appId = "请输入APPID";
    protected String appKey = "请输入APPKEY";
    protected String secretKey = "请输入SECRETKEY";


    private Tts mTts;


    private Context context;


    public TtsController(Context context) {
        mTts = new Tts(context, appId, appKey, secretKey);
        this.context = context;
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
                    if (errorCode == -4 || errorCode == -8) {
                        UiThreadUtil.runOnUiThread(new Runnable() {
                            @Override
                            public void run() {
                                Toast.makeText(context.getApplicationContext(), "appid和appkey的鉴权失败", Toast.LENGTH_SHORT)
                                        .show();
                            }
                        });
                        return;
                    }
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
