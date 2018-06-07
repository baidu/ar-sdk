
package com.baidu.ar.pro.draw;

import android.graphics.SurfaceTexture;

/**
 * Created by huxiaowen on 2017/12/7.
 */

public interface ARRenderCallback {
    void onCameraDrawerCreated(SurfaceTexture surfaceTexture, int width, int height);

    void onARDrawerCreated(SurfaceTexture surfaceTexture, SurfaceTexture.OnFrameAvailableListener
            arFrameListener, int width, int height);

    void onARDrawerChanged(SurfaceTexture surfaceTexture, int width, int height);
}