/*
 * Copyright (C) 2018 Baidu, Inc. All Rights Reserved.
 */
package com.baidu.ar.pro.module;

import java.util.HashMap;
import java.util.Map;

import com.baidu.ar.speech.Speech;
import com.baidu.ar.speech.listener.SpeechRecogListener;
import com.baidu.baiduarsdk.util.MsgParamsUtil;

import android.content.Context;

public class SpeechControler {

    private Speech mSpeech;

    public SpeechControler(Context context, SpeechRecogListener speechRecogListener) {
        mSpeech = new Speech(context, speechRecogListener);
    }

    public void parseMessage(HashMap<String, Object> luaMsg) {
        if (null != luaMsg) {
            int id = MsgParamsUtil.obj2Int(luaMsg.get("id"), -1);
            switch (id) {
                case MsgType.MSG_TYPE_VOICE_START:
                    Map<String, Object> params = new HashMap<>();
                    mSpeech.start(params);
                    break;
                case MsgType.MSG_TYPE_VOICE_CLOSE:
                    mSpeech.cancel();
                    break;
            }

        }
    }
}
