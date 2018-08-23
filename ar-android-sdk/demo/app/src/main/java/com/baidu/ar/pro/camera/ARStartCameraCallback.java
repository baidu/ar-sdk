/*
 * Copyright (C) 2017 Baidu, Inc. All Rights Reserved.
 */
package com.baidu.ar.pro.camera;

import android.graphics.SurfaceTexture;

/**
 * 打开相机的回调
 */
public interface ARStartCameraCallback {
    void onCameraStart(boolean result, SurfaceTexture surfaceTexture, int width, int height);
}
