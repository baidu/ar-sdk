/*
 * Copyright (C) 2017 Baidu, Inc. All Rights Reserved.
 */
package com.baidu.ar.camera;

import android.graphics.ImageFormat;
import android.graphics.SurfaceTexture;
import android.hardware.Camera;
import android.util.Log;
import android.view.SurfaceHolder;

/**
 * Created by huxiaowen on 2017/3/22.
 */

class CameraEngine {
    private static final String TAG = CameraEngine.class.getSimpleName();

    private static final int RETRY_OPEN_CAMERA_MAX = 3;
    private static final int RETRY_OPEN_CAMERA_DELAY_MS = 50;

    private Camera mCamera = null;

    private static volatile CameraEngine sInstance;

    public static CameraEngine getInstance() {
        if (sInstance == null) {
            synchronized (CameraEngine.class) {
                if (sInstance == null) {
                    sInstance = new CameraEngine();
                }
            }
        }
        return sInstance;
    }

    public static void releaseInstance() {
        sInstance = null;
    }

    private CameraEngine() {
    }

    public boolean openCamera(CameraParams cameraParams) {
        for (int i = 0; i < RETRY_OPEN_CAMERA_MAX; i++) {
            try {
                mCamera = Camera.open(cameraParams.getCameraId());
                return true;
            } catch (Exception e) {
                e.printStackTrace();
            }
            try {
                if (mCamera != null) {
                    mCamera.release();
                }
                Thread.sleep(RETRY_OPEN_CAMERA_DELAY_MS);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
        return false;
    }

    public boolean setParameters(CameraParams cameraParams) {
        try {
            Camera.Parameters parameters = mCamera.getParameters();

            if (cameraParams.isAutoCorrectParams()) {
                CameraHelper.correctCameraParams(cameraParams, parameters);
            }

            parameters.setPreviewSize(cameraParams.getPreviewWidth(), cameraParams.getPreviewHeight());
            parameters.setPreviewFrameRate(cameraParams.getFrameRate());
            parameters.setPictureSize(cameraParams.getPictureWidth(), cameraParams.getPictureHeight());

            if (cameraParams.isAutoFocus()) {
                CameraHelper.setAutoFocus(parameters);
            }
            mCamera.setDisplayOrientation(cameraParams.getRotateDegree());

            mCamera.setParameters(parameters);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean setPreviewTexture(SurfaceTexture surfaceTexture) {
        try {
            mCamera.setPreviewTexture(surfaceTexture);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean setPreviewHolder(SurfaceHolder surfaceHolder) {
        try {
            mCamera.setPreviewDisplay(surfaceHolder);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean setPreviewCallback(Camera.PreviewCallback previewCallback) {
        if (mCamera != null) {
            mCamera.setPreviewCallback(previewCallback);
            return true;
        }
        return false;
    }

    public boolean setPreviewCallbackWithBuffer(Camera.PreviewCallback previewCallback) {
        if (mCamera != null) {
            mCamera.setPreviewCallbackWithBuffer(previewCallback);
            Camera.Size previewSize = mCamera.getParameters().getPreviewSize();
            int previewBufferSize =
                    ((previewSize.width * previewSize.height) * ImageFormat.getBitsPerPixel(ImageFormat.NV21)) / 8;
            // 添加3个buffer，保障buffer足够使用，且不影响效率
            for (int i = 0; i < 3; i++) {
                mCamera.addCallbackBuffer(new byte[previewBufferSize]);
            }
            return true;
        }
        return false;
    }

    public boolean startPreview() {
        Log.d(TAG, "startPreview !!!");
        try {
            mCamera.startPreview();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean stopPreview() {
        Log.d(TAG, "stopPreview");
        try {
            mCamera.stopPreview();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean openFlash() {
        try {
            if (CameraHelper.isBackCameraCurrent()) {
                Camera.Parameters parameters = mCamera.getParameters();
                if (!Camera.Parameters.FLASH_MODE_TORCH.equals(parameters.getFlashMode())) {
                    parameters.setFlashMode(Camera.Parameters.FLASH_MODE_TORCH);
                    mCamera.setParameters(parameters);
                    return true;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean closeFlash() {
        try {
            if (CameraHelper.isBackCameraCurrent()) {
                Camera.Parameters parameters = mCamera.getParameters();
                if (!Camera.Parameters.FLASH_MODE_OFF.equals(parameters.getFlashMode())) {
                    parameters.setFlashMode(Camera.Parameters.FLASH_MODE_OFF);
                    mCamera.setParameters(parameters);
                    return true;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public void release() {
        if (mCamera != null) {
            mCamera.release();
            mCamera = null;
        }
        releaseInstance();
    }

}