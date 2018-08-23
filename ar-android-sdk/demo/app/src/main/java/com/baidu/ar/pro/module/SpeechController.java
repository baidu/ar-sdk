/*
 * Copyright (C) 2018 Baidu, Inc. All Rights Reserved.
 */
package com.baidu.ar.pro.module;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Timer;
import java.util.TimerTask;

import com.baidu.ar.ARController;
import com.baidu.ar.bean.ARConfig;
import com.baidu.ar.pro.R;
import com.baidu.ar.speech.Speech;
import com.baidu.ar.speech.SpeechStatus;
import com.baidu.ar.speech.listener.SpeechRecogListener;
import com.baidu.ar.statistic.StatisticConstants;
import com.baidu.ar.statistic.StatisticHelper;
import com.baidu.ar.util.ARFileUtils;
import com.baidu.ar.util.FileUtils;
import com.baidu.baiduarsdk.util.MsgParamsUtil;

import android.content.Context;
import android.text.TextUtils;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.RelativeLayout;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

/**
 * 语音识别控制器
 * <p>集成百度语音识别能力，可以通过语音识别与AR Case内容进行交互</p>
 * <p>case内需要配置识别数据，并与语音识别进行匹配，支持模糊匹配。配置文件见</p>
 */
public class SpeechController {

    private Speech mSpeech;
    private ARController mARController;
    private boolean mHitSpeech = false;
    public Timer mSpeechTimer;
    public TimerTask mSpeechTask;
    JSONObject mVoiceObj = null;
    private Context mContext;
    private Button mSpeechButton;

    public SpeechController(Context context, SpeechRecogListener speechRecogListener, ARController arController) {
        mSpeech = new Speech(context, speechRecogListener);
        mARController = arController;
        mContext = context;
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

    public void parseVoiceData() {
        String absVocie = ARFileUtils.getVoiceFilePath(ARConfig.getARKey());
        String voiceData = FileUtils.readFileText(absVocie);
        if (TextUtils.isEmpty(voiceData)) {
            return;
        }
        try {
            JSONObject obj = new JSONObject(voiceData).getJSONObject("voice");
            mVoiceObj = obj;
        } catch (JSONException e) {
            e.printStackTrace();
            Log.e("lua ", "parseVoiceData error");
        }
    }

    private void sendVoiceResult(int status, String key) {

        HashMap<String, Object> map = new HashMap<>();
        map.put("id", MsgType.MSG_TYPE_VOICE_START);
        map.put("status", status);
        if (null != key) {
            map.put("voice_result", key);
        }
        if (null != mARController) {
            mARController.sendMessage2Lua(map);
            stopVoiceStatus();
        }

    }

    public void parseResult(String result) {
        if (mHitSpeech) {
            return;
        }
        mVoiceObj = null;
        parseVoiceData();
        if (mVoiceObj != null) {
            Iterator iterator = mVoiceObj.keys();
            while (iterator.hasNext()) {
                String key = (String) iterator.next();
                JSONArray keyArray = null;
                try {
                    keyArray = new JSONArray(mVoiceObj.getString(key));
                    for (int i = 0; i < keyArray.length(); i++) {
                        String str = keyArray.getString(i);
                        if (str != null && result.contains(str)) {
                            mHitSpeech = true;
                            sendVoiceResult(SpeechStatus.RESULT, key);
                            StatisticHelper.getInstance()
                                    .statisticInfo(StatisticConstants.SPEECH_TYPE_HIT);
                            if (mSpeechTimer == null) {
                                mSpeechTimer = new Timer();
                            }
                            mSpeechTask = new TimerTask() {
                                public void run() {
                                    onMicRelease();

                                }
                            };
                            mSpeechTimer.schedule(mSpeechTask, 1000);
                            return;
                        }
                    }
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }

        }

    }


    public void onMicRelease() {
        if (mSpeech != null) {
            mSpeech.cancel();
        }
    }

    public void initView(ViewGroup container) {
        final View view = View.inflate(mContext, R.layout.view_speech, null);
        container.addView(view);
        mSpeechButton = view.findViewById(R.id.btn_speech);
        mSpeechButton.setText("正在语音识别");
        mSpeechButton.setTag("start");
        mSpeechButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if ("start".equals(mSpeechButton.getTag())) {
                    stopVoice();
                } else {
                    startVoice();
                }
            }
        });

    }

    public void startVoice() {
        Map<String, Object> params = new HashMap<>();
        mSpeech.start(params);
        startVoiceStatus();
        mHitSpeech = false;
    }

    public void stopVoice() {
        mSpeech.cancel();
        stopVoiceStatus();
    }

    private void startVoiceStatus() {
        mSpeechButton.setText("正在语音识别");
        mSpeechButton.setTag("start");
    }

    private void stopVoiceStatus() {
        mSpeechButton.setTag("stop");
        mSpeechButton.setText("开始语音识别");
    }

    public void setVoiceStatus(int status) {
        if (status == SpeechStatus.ENDOFSPEECH || status == SpeechStatus.ERROR) {
            stopVoiceStatus();
        }


    }

}
