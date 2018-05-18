/*
 * Copyright (C) 2017 Baidu, Inc. All Rights Reserved.
 */
package com.baidu.ar.camera;

import android.graphics.SurfaceTexture;
import android.hardware.Camera;
import android.view.SurfaceHolder;

/**
 * Created by huxiaowen on 2017/3/23.
 */

public interface ICamera {

    /**
     * 初始化并打开摄像头
     *
     * @param cameraParams   设置摄像头相关参数
     * @param cameraCallback 返回摄像头操作结果
     */
    boolean setupCamera(CameraParams cameraParams, CameraCallback cameraCallback);

    /**
     * 关闭并释放摄像头
     */
    void releaseCamera();

    /**
     * 根据参数重新初始化并打开摄像头
     *
     * @param cameraParams 设置摄像头相关参数
     */
    void reopenCamera(CameraParams cameraParams);

    /**
     * 设置承接摄像头返回帧数据的SurfaceTexture
     *
     * @param surfaceTexture 承接摄像头返回帧数据
     */
    void setSurfaceTexture(SurfaceTexture surfaceTexture);

    /**
     * 设置承接摄像头返回帧数据的SurfaceHolder
     *
     * @param surfaceHolder 承接摄像头返回帧数据
     */
    void setSurfaceHolder(SurfaceHolder surfaceHolder);

    /**
     * 设置摄像头预览数据的callback
     * callback的buffer是系统负责创建和销毁的，无需自行管理，但是每帧都会创建和销毁，会有内存波动，效率较低
     *
     * @param previewCallback 预览数据callback
     */
    void setPreviewCallback(Camera.PreviewCallback previewCallback);

    /**
     * 设置摄像头预览数据的callback
     * callback的buffer程序创建并给提供给系统的，需要在回调函数onPreviewFrame中调用camera.addCallbackBuffer(data)函数，
     * 将data占用的buffer添加回去，这样系统就无需重复创建和释放buffer，不会有内存波动，效率较高
     *
     * @param previewCallback 预览数据callback
     */
    void setPreviewCallbackWithBuffer(Camera.PreviewCallback previewCallback);

    /**
     * 开始预览
     */
    void startPreview();

    /**
     * 结束预览
     */
    void stopPreview();

    /**
     * 开启闪关灯（只有后摄像头时可用）
     */
    void openFlash();

    /**
     * 关闭闪关灯（只有后摄像头时可用）
     */
    void closeFlash();
}
