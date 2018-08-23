/*
 * Copyright (C) 2018 Baidu, Inc. All Rights Reserved.
 */
package com.baidu.ar.pro.module;

public class MsgType {
    // tts
    public static final int MSG_TYPE_TTS_SPEAK = 2005;
    public static final int MSG_TYPE_TTS_STOP = 2006;
    public static final int MSG_TYPE_TTS_PAUSE = 2007;
    public static final int MSG_TYPE_TTS_RESUME = 2008;
    // tts end

    // 语音 ID
    public static final int MSG_TYPE_VOICE_START = 2001;
    public static final int MSG_TYPE_VOICE_CLOSE = 2002;
    public static final int MSG_TYPE_VOICE_SHOW_MIC_ICON = 2003;
    public static final int MSG_TYPE_VOICE_HIDE_MIC_ICON = 2004;
    // 语音 ID end
    // 自定义消息ID
    public static final int MSG_TYPE_THIRD = 3333;
    // 自定义消息ID END

    // logo
    public static final int MSG_TYPE_LOGO_START = 3005;
    public static final int MSG_TYPE_LOGO_STOP = 3006;
    // logo end
}
