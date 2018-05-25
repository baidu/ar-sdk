package com.baidu.ar.tts;

/**
 * 语音合成回调
 * Created by xiegaoxi on 2017/10/12.
 */

public interface TTSCallback {
    /**
     * 语音合成开始状态
     */
    void onTtsStarted();

    /**
     * 语音合成结束状态
     */
    void onTtsFinish();

    /**
     * 语音合成错误
     */
    void onTtsError(int errorCode);
}
