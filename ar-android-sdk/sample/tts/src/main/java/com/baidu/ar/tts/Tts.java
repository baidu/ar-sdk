package com.baidu.ar.tts;

import org.json.JSONException;
import org.json.JSONObject;

import com.baidu.tts.auth.AuthInfo;
import com.baidu.tts.client.SpeechError;
import com.baidu.tts.client.SpeechSynthesizer;
import com.baidu.tts.client.SpeechSynthesizerListener;
import com.baidu.tts.client.TtsMode;

import android.content.Context;
import android.util.Log;

/**
 * Created by xiegaoxi on 2017/10/12.
 */

public class Tts {
    /**
     * debug tag
     */
    private static final String TAG = "TTSManager";
    // context
    private Context mContext;

    /**
     * 只启用在线合成引擎，不需要离线资源包
     */
    public static final int SYNTHESIZER_SERVER = 0;

    /**
     * 发音人
     */
    public static final String TTS_CONFIG_KEY_SPEAKER = "speaker";

    // sdk
    private SpeechSynthesizer mSpeechSynthesizer;

    /**
     * 构造函数
     *
     * @param context
     * @param appId
     * @param aipKey
     * @param secretKey
     */
    public Tts(Context context, String appId, String aipKey, String secretKey)

    {
        mContext = context;
        mSpeechSynthesizer = SpeechSynthesizer.getInstance();
        mSpeechSynthesizer.setContext(mContext);
        mSpeechSynthesizer.setAppId(appId);
        mSpeechSynthesizer.setApiKey(aipKey, secretKey);
        AuthInfo authInfo = mSpeechSynthesizer.auth(TtsMode.ONLINE);
        if (authInfo.isSuccess()) {
            Log.e("tts", "auth success");
        } else {
            String errorMsg = authInfo.getTtsError().getDetailMessage();
            Log.e("tts", "auth failed errorMsg=" + errorMsg);
        }
        // 初始化tts
        mSpeechSynthesizer.initTts(TtsMode.ONLINE);
    }

    /**
     * @param speaker 可用参数为0,1,2,3。。。（服务器端会动态增加，各值含义参考文档，以文档说明为准。0--普通女声，1--普通男声，2--特别男声，3--情感男声。。。）
     * @param speed   语速度 【0.9】默认5
     * @param volume  设置媒体音量 0~1
     */
    public void setup(String speaker, String speed, String volume) {
        mSpeechSynthesizer = SpeechSynthesizer.getInstance();
        mSpeechSynthesizer.setContext(mContext);

        mSpeechSynthesizer.setParam(SpeechSynthesizer.PARAM_SPEED, speed);
        // 设置发声的人声音
        mSpeechSynthesizer.setParam(SpeechSynthesizer.PARAM_SPEAKER, speaker);
        // 播放音量 default 0.5
        mSpeechSynthesizer.setStereoVolume(Float.parseFloat(volume), Float.parseFloat(volume));

        AuthInfo authInfo = mSpeechSynthesizer.auth(TtsMode.ONLINE);
        if (authInfo.isSuccess()) {
            Log.e("tts", "auth success");
        } else {
            String errorMsg = authInfo.getTtsError().getDetailMessage();
            Log.e("tts", "auth failed errorMsg=" + errorMsg);
        }
        // 初始化tts
        mSpeechSynthesizer.initTts(TtsMode.ONLINE);

    }

    /**
     * 合成并播放
     *
     * @param text 合成播放内容
     */
    public void speak(String text, final TTSCallback listener) {
        JSONObject json = new JSONObject();
        if (mSpeechSynthesizer != null) {

            mSpeechSynthesizer.speak(text);
            mSpeechSynthesizer.setSpeechSynthesizerListener(new SpeechSynthesizerListener() {
                @Override
                public void onSynthesizeStart(String s) {
                    Log.d(TAG, "speak i:  onSynthesizeStart " + s);
                }

                @Override
                public void onSynthesizeDataArrived(String s, byte[] bytes, int i) {

                    Log.d(TAG, "speak i:  onSynthesizeDataArrived " + s);
                }

                @Override
                public void onSynthesizeFinish(String s) {

                    Log.d(TAG, "speak i:  onSynthesizeFinish " + s);
                }

                @Override
                public void onSpeechStart(String s) {
                    if (listener != null) {
                        listener.onTtsStarted();
                    }
                    Log.d(TAG, "speak i:  onSpeechStart " + s);
                }

                @Override
                public void onSpeechProgressChanged(String s, int i) {

                    Log.d(TAG, "speak i:  onSpeechProgressChanged " + s);
                }

                @Override
                public void onSpeechFinish(String s) {
                    if (listener != null) {
                        listener.onTtsFinish();
                    }
                    Log.d(TAG, "speak i:  onSpeechFinish " + s);
                }

                @Override
                public void onError(String s, SpeechError speechError) {
                    if (listener != null) {
                        listener.onTtsError(speechError.code);
                    }
                    Log.d(TAG, "speak i:  onError " + s + "speechError = " + speechError.code + "--"
                            + speechError.description);
                }
            });

        }
    }

    /*
     * 设置TTS参数
     *
     * @param paramKey   参数名
     * @param paramValue 参数值
     */
    private void setParam(String paramKey, String paramValue) {
        JSONObject json = new JSONObject();
        try {
            json.put("paramKey", paramKey);
            json.put("paramValue", paramValue);
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }

    public void pause() {
        if (mSpeechSynthesizer != null) {
            this.mSpeechSynthesizer.pause();
        }
    }

    public void resume() {
        if (mSpeechSynthesizer != null) {
            this.mSpeechSynthesizer.resume();
        }
    }

    public void stop() {
        if (mSpeechSynthesizer != null) {
            this.mSpeechSynthesizer.stop();
        }
    }

    public void release() {
        mContext = null;
    }

}