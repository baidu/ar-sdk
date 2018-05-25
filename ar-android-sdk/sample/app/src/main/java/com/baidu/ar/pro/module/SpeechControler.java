/*
 * Copyright (C) 2018 Baidu, Inc. All Rights Reserved.
 */
package com.baidu.ar.pro.module;

import java.util.HashMap;

import com.baidu.baiduarsdk.util.MsgParamsUtil;

import android.content.Context;

public class SpeechControler {

//    private Speech mSpeech;

    public SpeechControler(Context context) {
//        mSpeech = new Speech(context, appId, appKey, secretKey);
    }

    public void parseMessage(HashMap<String, Object> luaMsg) {
        if (null != luaMsg) {
            int id = MsgParamsUtil.obj2Int(luaMsg.get("id"), -1);
            switch (id) {
                case MsgType.MSG_TYPE_VOICE_START:
                    break;
                case MsgType.MSG_TYPE_VOICE_CLOSE:
                    break;
            }

        }
    }
}
