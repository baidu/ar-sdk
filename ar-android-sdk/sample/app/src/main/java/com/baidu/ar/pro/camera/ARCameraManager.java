/*
 * Copyright (C) 2017 Baidu, Inc. All Rights Reserved.
 */
package com.baidu.ar.pro.camera;

import android.graphics.SurfaceTexture;
import android.hardware.Camera;
import android.util.Log;

import com.baidu.ar.camera.CameraHelper;
import com.baidu.ar.camera.CameraParams;
import com.baidu.ar.camera.easy.EasyCamera;
import com.baidu.ar.camera.easy.EasyCameraCallback;
import com.baidu.ar.pro.callback.PreviewCallback;

/**
 * AR相机管理
 */
public class ARCameraManager implements EasyCameraCallback, Camera.PreviewCallback {
    private static final String TAG = ARCameraManager.class.getSimpleName();

    private CameraParams mCameraParams;
    private SurfaceTexture mSourceTexture;
    private PreviewCallback mPreviewCallback;

    private ARStartCameraCallback mStartCameraCallback;
    private ARCameraCallback mStopCameraCallback;
    private ARCameraCallback mOpenFlashCallback;
    private ARCameraCallback mCloseFlashCallback;
    private ARSwitchCameraCallback mSwitchCameraCallback;

    /**
     * mPreBuffer
     */
    private byte[] mPreBuffer = null;
    private Camera.Size mPreviewSize;

    public ARCameraManager() {
    }

    public void startCamera(SurfaceTexture sourceTexture, ARStartCameraCallback callback) {
        mStartCameraCallback = callback;
        mSourceTexture = sourceTexture;
        if (mCameraParams == null) {
            mCameraParams = new CameraParams();
        }

//        mCameraParams.setRotateDegree(-90);
        EasyCamera.getInstance().startCamera(mCameraParams, mSourceTexture, this, this);
    }

    public void stopCamera(ARCameraCallback callback, boolean saveLastPreview) {
        mStopCameraCallback = callback;
        EasyCamera.getInstance().stopCamera();

    }

    public void openFlash(ARCameraCallback callback) {
        mOpenFlashCallback = callback;
        EasyCamera.getInstance().openFlash();
    }

    public void closeFlash(ARCameraCallback callback) {
        mCloseFlashCallback = callback;
        EasyCamera.getInstance().closeFlash();
    }

    public void switchCamera(ARSwitchCameraCallback callback) {
        mSwitchCameraCallback = callback;
        EasyCamera.getInstance().switchCamera();
    }

    @Override
    public void onCameraStart(boolean result) {
        if (mStartCameraCallback != null && mCameraParams != null) {
            mStartCameraCallback.onCameraStart(result, mSourceTexture, mCameraParams.getPreviewWidth(),
                    mCameraParams.getPreviewHeight());
        }
    }

    @Override
    public void onCameraSwitch(boolean result) {
        if (mSwitchCameraCallback != null && mCameraParams != null) {
            mSwitchCameraCallback
                    .onCameraSwitch(result, mCameraParams.getCameraId() == Camera.CameraInfo.CAMERA_FACING_BACK);
        }
    }

    @Override
    public void onFlashOpen(boolean result) {
        if (mOpenFlashCallback != null) {
            mOpenFlashCallback.onResult(result);
        }
    }

    @Override
    public void onFlashClose(boolean result) {
        if (mCloseFlashCallback != null) {
            mCloseFlashCallback.onResult(result);
        }
    }

    @Override
    public void onCameraStop(boolean result) {
        if (mStopCameraCallback != null) {
            mStopCameraCallback.onResult(result);
        }
    }

    @Override
    public void onPreviewFrame(byte[] data, Camera camera) {
        Log.d(TAG, "onPreviewFrame");
        if (mPreviewCallback != null) {
            mPreviewCallback.onPreviewFrame(data, mCameraParams.getPreviewWidth(), mCameraParams.getPreviewHeight());
        }
        mPreBuffer = data;
        try {
            if (mPreviewSize == null) {
                mPreviewSize = camera.getParameters().getPreviewSize();
            }
        } catch (Exception e) {
            // Camera.release() 后调getParameters会报错
            e.printStackTrace();
        }
    }

    public void setPreviewCallback(PreviewCallback previewCallback) {
        this.mPreviewCallback = previewCallback;
    }


    /**
     * 判断是否支持前置摄像头
     *
     * @return
     */
    public boolean isFrontCameraPreviewSupported() {
        return CameraHelper.isCameraSupported(Camera.CameraInfo.CAMERA_FACING_FRONT);
    }
}
