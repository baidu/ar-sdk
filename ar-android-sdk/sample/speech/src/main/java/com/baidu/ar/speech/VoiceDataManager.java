/*
 * Copyright (C) 2017 Baidu, Inc. All Rights Reserved.
 */
package com.baidu.ar.speech;

import android.content.Context;
import android.util.Log;

import org.json.JSONException;
import org.json.JSONObject;

/**
 * Created by xgx on 2017/6/15.
 */

public class VoiceDataManager {

    private static VoiceDataManager mInstance;
    private Context mContext;

    private JSONObject mVoiceObj = null;

    /**
     * 语音模糊匹配数据
     *
     * @return 单例对象
     */
    public static synchronized VoiceDataManager getInstance(Context context) {
        if (mInstance == null) {
            mInstance = new VoiceDataManager(context);
        }
        return mInstance;
    }

    private VoiceDataManager(Context context) {
        mContext = context;
    }

    public JSONObject getVoiceObj() {
        return mVoiceObj;
    }

    /**
     * 解析语音数据
     *
     * @param voiceData
     */
    public void parseVoiceData(String voiceData) {

        try {
            JSONObject obj = new JSONObject(voiceData).getJSONObject("voice");
            mVoiceObj = obj;
        } catch (JSONException e) {
            e.printStackTrace();
            Log.e("lua ", "parseVoiceData error");
        }
    }

}
