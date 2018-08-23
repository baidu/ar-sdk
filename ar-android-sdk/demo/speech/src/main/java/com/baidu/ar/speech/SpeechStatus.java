/*
 * Copyright (C) 2017 Baidu, Inc. All Rights Reserved.
 */
package com.baidu.ar.speech;

/**
 * Created by xgx on 2017/6/9.
 * 语音识别的状态
 */

public class SpeechStatus {

    // 准备就绪
    public static final int READYFORSPEECH = 0;
    // 开始说话
    public static final int BEGINNINGOFSPEECH = 1;
    // 说话结束
    public static final int ENDOFSPEECH = 2;
    // 识别出错
    public static final int ERROR = 3;
    // 识别最终结果
    public static final int RESULT = 4;
    // 识别结果不匹配
    public static final int RESULT_NO_MATCH = 5;
    // 识别临时结果
    public static final int PARTIALRESULT = 6;
    // 取消识别
    public static final int CANCLE = 7;

    public class SpeechErrorStatus {
        // 未知错误
        public static final int ERROR_NULL = 0;
        // 没有语音输入
        public static final int ERROR_SPEECH_TIMEOUT = 1;
        //  网络错误
        public static final int ERROR_NETWORK = 2;
        // 权限错误
        public static final int ERROR_INSUFFICIENT_PERMISSIONS = 3;
    }

}
