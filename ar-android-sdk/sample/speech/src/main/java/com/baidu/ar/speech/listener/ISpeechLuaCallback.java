/*
 * Copyright (C) 2017 Baidu, Inc. All Rights Reserved.
 */
package com.baidu.ar.speech.listener;

/**
 * Created by xgx on 2017/6/20.
 */

public interface ISpeechLuaCallback {
    void start();
    void stop();
    void setMicButtonVisible(boolean visible);
}
