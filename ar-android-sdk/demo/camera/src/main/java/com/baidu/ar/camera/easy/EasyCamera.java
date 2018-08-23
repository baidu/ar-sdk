package com.baidu.ar.camera.easy;

import com.baidu.ar.camera.CameraCallback;
import com.baidu.ar.camera.CameraController;
import com.baidu.ar.camera.CameraParams;

import android.graphics.SurfaceTexture;
import android.hardware.Camera;
import android.util.Log;

/**
 * Created by huxiaowen on 2017/8/23.
 */

public class EasyCamera implements IEasyCamera, CameraCallback, Camera.PreviewCallback {
    private static final String TAG = EasyCamera.class.getSimpleName();

    private static final int SLEEP_TIME_MS = 50;
    private static final int SLEEP_COUNT_MAX = 10;

    private CameraController mCameraController;

    private CameraParams mCameraParams;
    private SurfaceTexture mSurfaceTexture;
    private Camera.PreviewCallback mPreviewCallback;
    private EasyCameraCallback mEasyCameraCallback;

    private boolean mReopening = false;

    private static volatile boolean sCameraStarting = false;
    private static volatile boolean sCameraClosing = false;

    private static volatile EasyCamera sInstance;

    public static EasyCamera getInstance() {
        if (sInstance == null) {
            synchronized (EasyCamera.class) {
                if (sInstance == null) {
                    sInstance = new EasyCamera();
                }
            }
        }
        return sInstance;
    }

    private EasyCamera() {
    }

    @Override
    public void startCamera(CameraParams cameraParams, SurfaceTexture surfaceTexture,
                            Camera.PreviewCallback previewCallback, EasyCameraCallback easyCameraCallback) {
        Log.d(TAG, "startCamera !!!");
        if (cameraParams == null || surfaceTexture == null) {
            return;
        }
        sCameraStarting = true;
        // 如果正在结束上一次的camera，则等待上一次release，然后再开启
        if (waitWhenReleasing()) {
            return;
        }
        mCameraParams = cameraParams;
        mSurfaceTexture = surfaceTexture;
        mPreviewCallback = previewCallback;
        mEasyCameraCallback = easyCameraCallback;
        if (mCameraController == null) {
            mCameraController = CameraController.getInstance();
        }
        mCameraController.setupCamera(cameraParams, this);
    }

    private boolean waitWhenReleasing() {
        int tryCount = 0;
        while (sCameraClosing) {
            Log.d(TAG, "startCamera tryCount = " + tryCount);
            try {
                Thread.sleep(SLEEP_TIME_MS);
                tryCount++;
            } catch (InterruptedException e) {
                e.printStackTrace();
                return true;
            }
            if (tryCount >= SLEEP_COUNT_MAX) {
                return true;
            }
        }
        return false;
    }

    @Override
    public void switchCamera() {
        Log.d(TAG, "switchCamera !!!");
        if (mCameraParams == null || mCameraController == null) {
            return;
        }
        mReopening = true;
        if (mCameraParams.getCameraId() == Camera.CameraInfo.CAMERA_FACING_BACK) {
            mCameraParams.setCameraId(Camera.CameraInfo.CAMERA_FACING_FRONT);
        } else {
            mCameraParams.setCameraId(Camera.CameraInfo.CAMERA_FACING_BACK);
        }
        mCameraController.reopenCamera(mCameraParams);
    }

    @Override
    public void openFlash() {
        if (mCameraController != null) {
            mCameraController.openFlash();
        }
    }

    @Override
    public void closeFlash() {
        if (mCameraController != null) {
            mCameraController.closeFlash();
        }
    }

    @Override
    public void stopCamera() {
        Log.d(TAG, "stopCamera !!!");
        if (mCameraController != null) {
            sCameraClosing = true;
            mCameraController.stopPreview();
        }
    }

    private static void releaseInstance() {
        sInstance = null;
    }

    @Override
    public void onCameraSetup(boolean result) {
        Log.d(TAG, "onCameraSetup result = " + result);
        if (result) {
            if (mCameraController != null) {
                mCameraController.setSurfaceTexture(mSurfaceTexture);
            }
        } else {
            if (mEasyCameraCallback != null) {
                mEasyCameraCallback.onCameraStart(false);
            }
        }
    }

    @Override
    public void onCameraRelease(boolean result) {
        Log.d(TAG, "onCameraRelease result = " + result);
        if (mEasyCameraCallback != null) {
            mEasyCameraCallback.onCameraStop(result);
        }
        mCameraParams = null;
        mSurfaceTexture = null;
        mPreviewCallback = null;
        mEasyCameraCallback = null;
        mCameraController = null;
        sCameraClosing = false;
        if (!sCameraStarting) {
            releaseInstance();
        }
    }

    @Override
    public void onCameraReopen(boolean result) {
        Log.d(TAG, "onCameraReopen result = " + result);
        if (result) {
            if (mCameraController != null) {
                mCameraController.setSurfaceTexture(mSurfaceTexture);
            }
        } else {
            // 如果reopen失败，则将参数还原
            if (mCameraParams != null) {
                if (mCameraParams.getCameraId() == Camera.CameraInfo.CAMERA_FACING_BACK) {
                    mCameraParams.setCameraId(Camera.CameraInfo.CAMERA_FACING_FRONT);
                } else {
                    mCameraParams.setCameraId(Camera.CameraInfo.CAMERA_FACING_BACK);
                }
            }
            if (mEasyCameraCallback != null) {
                mEasyCameraCallback.onCameraSwitch(false);
            }
        }
    }

    @Override
    public void onSurfaceTextureSet(boolean result) {
        Log.d(TAG, "onSurfaceTextureSet result = " + result);
        if (result) {
            if (mCameraController != null) {
                if (mPreviewCallback != null) {
                    mCameraController.setPreviewCallbackWithBuffer(this);
                }
                mCameraController.startPreview();
            }
        } else {
            if (mEasyCameraCallback != null) {
                if (mReopening) {
                    mEasyCameraCallback.onCameraSwitch(false);
                } else {
                    mEasyCameraCallback.onCameraStart(false);
                }
            }
        }
    }

    @Override
    public void onSurfaceHolderSet(boolean result) {

    }

    @Override
    public void onPreviewCallbackSet(boolean result) {

    }

    @Override
    public void onPreviewStart(boolean result) {
        Log.d(TAG, "onPreviewStart result = " + result);
        if (mEasyCameraCallback != null) {
            if (mReopening) {
                mEasyCameraCallback.onCameraSwitch(result);
                mReopening = false;
            } else {
                mEasyCameraCallback.onCameraStart(result);
            }
        }
        sCameraStarting = false;
    }

    @Override
    public void onPreviewStop(boolean result) {
        Log.d(TAG, "onPreviewStop result = " + result);
        if (mCameraController != null) {
            mCameraController.releaseCamera();
        }
    }

    @Override
    public void onFlashOpen(boolean result) {
        if (mEasyCameraCallback != null) {
            mEasyCameraCallback.onFlashOpen(result);
        }
    }

    @Override
    public void onFlashClose(boolean result) {
        if (mEasyCameraCallback != null) {
            mEasyCameraCallback.onFlashClose(result);
        }
    }

    @Override
    public void onPreviewFrame(byte[] bytes, Camera camera) {
        camera.addCallbackBuffer(bytes);
        if (mPreviewCallback != null) {
            mPreviewCallback.onPreviewFrame(bytes, camera);
        }
    }
}
