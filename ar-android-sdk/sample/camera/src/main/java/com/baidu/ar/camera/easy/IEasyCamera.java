package com.baidu.ar.camera.easy;

import com.baidu.ar.camera.CameraParams;

import android.graphics.SurfaceTexture;
import android.hardware.Camera;

/**
 * Created by huxiaowen on 2017/8/23.
 */

public interface IEasyCamera {

    /**
     * 开启摄像头预览
     *
     * @param cameraParams       设置摄像头相关参数
     * @param surfaceTexture     视频帧输出到SurfaceTexture
     * @param previewCallback    返回PreviewCallback数据
     * @param easyCameraCallback 返回摄像头操作结果
     */
    void startCamera(CameraParams cameraParams, SurfaceTexture surfaceTexture, Camera.PreviewCallback previewCallback,
                     EasyCameraCallback easyCameraCallback);

    /**
     * 切换前后摄像头
     */
    void switchCamera();

    /**
     * 开启闪关灯（只有后摄像头时可用）
     */
    void openFlash();

    /**
     * 关闭闪关灯（只有后摄像头时可用）
     */
    void closeFlash();

    /**
     * 结束摄像头预览，并释放相关资源
     */
    void stopCamera();
}
