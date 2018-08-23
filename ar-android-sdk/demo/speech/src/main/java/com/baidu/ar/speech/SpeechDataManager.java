/*
 * Copyright (C) 2018 Baidu, Inc. All Rights Reserved.
 */
package com.baidu.ar.speech;

import org.json.JSONException;
import org.json.JSONObject;

import android.content.Context;
import android.text.TextUtils;
import android.util.Log;

public class SpeechDataManager {
    private static SpeechDataManager mInstance;
    private Context mContext;

    private JSONObject mVoiceObj = null;

    /**
     * 语音模糊匹配数据
     *
     * @return 单例对象
     */
    public static synchronized SpeechDataManager getInstance(Context context) {
        if (mInstance == null) {
            mInstance = new SpeechDataManager(context);
        }
        return mInstance;
    }

    private SpeechDataManager(Context context) {
        mContext = context;
        parseVoiceData();
    }

    public JSONObject getVoiceObj() {
        return mVoiceObj;
    }

    /**
     * 解析语音数据
     */
    public void parseVoiceData() {
/*        String absVocie = ARFileUtils.getVoiceFilePath(ARConfig.getARKey());
        String voiceData = FileUtils.readFileText(absVocie);
        if (TextUtils.isEmpty(voiceData)) {
            return;
        }
        try {
            boolean show = new JSONObject(voiceData).getBoolean("show_error_tips");
            SpeechManager.getInstance(mContext).setShowErrorTips(show);
            JSONObject obj = new JSONObject(voiceData).getJSONObject("voice");
            mVoiceObj = obj;
        } catch (JSONException e) {
            e.printStackTrace();
            Log.e("lua ", "parseVoiceData error");
        }*/
    }

}

