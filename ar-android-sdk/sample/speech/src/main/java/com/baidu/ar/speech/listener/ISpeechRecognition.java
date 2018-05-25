package com.baidu.ar.speech.listener;

/**
 * Created by xgx on 2017/7/31.
 */

public interface ISpeechRecognition {

    /**
     * 提示用户开始说话状态
     */
    void onVoiceRecordStarted();

    /**
     * 语音
     *
     * @param volume
     */
    void onVolumeChange(double volume);

    /**
     * 开始智能识别
     */
    void onVoiceRecognitionStarted();

    /**
     * 结束智能识别
     */
    void onVoiceRecognitionSuccess();

    /**
     * 停止智能识别
     */
    void onVoiceRecognitionCancel();

    /**
     * 上屏文字
     *
     * @param text
     * @param intermediate 是否是中间状态 true 中间 false 结果
     */
    void setSpeechText(boolean intermediate, String text);

    /**
     * 识别错误
     *
     * @param errorCode
     */
    void onRecognitionFail(int errorCode, String msg);

    /**
     * 麦克风释放
     */
    void onMicRelease();


}
