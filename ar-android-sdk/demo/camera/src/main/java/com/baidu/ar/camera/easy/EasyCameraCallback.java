package com.baidu.ar.camera.easy;

/**
 * Created by huxiaowen on 2017/8/23.
 */

public interface EasyCameraCallback {
    void onCameraStart(boolean result);

    void onCameraSwitch(boolean result);

    void onFlashOpen(boolean result);

    void onFlashClose(boolean result);

    void onCameraStop(boolean result);
}
