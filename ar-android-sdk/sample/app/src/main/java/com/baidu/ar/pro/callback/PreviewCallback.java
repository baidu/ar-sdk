/*
 * Copyright (C) 2018 Baidu, Inc. All Rights Reserved.
 */
package com.baidu.ar.pro.callback;

/**
 * Created by huxiaowen on 2017/12/14.
 */

public interface PreviewCallback {
    void onPreviewFrame(byte[] data, int width, int height);
}
