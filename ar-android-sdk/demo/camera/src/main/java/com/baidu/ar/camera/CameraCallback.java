/*
 * Copyright (C) 2017 Baidu, Inc. All Rights Reserved.
 */
package com.baidu.ar.camera;

/**
 * Created by huxiaowen on 2017/3/23.
 */

public interface CameraCallback {
    void onCameraSetup(boolean result);

    void onCameraRelease(boolean result);

    void onCameraReopen(boolean result);

    void onSurfaceTextureSet(boolean result);

    void onSurfaceHolderSet(boolean result);

    void onPreviewCallbackSet(boolean result);

    void onPreviewStart(boolean result);

    void onPreviewStop(boolean result);

    void onFlashOpen(boolean result);

    void onFlashClose(boolean result);
}
