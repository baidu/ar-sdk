/*
 * Copyright (C) 2017 Baidu, Inc. All Rights Reserved.
 */
package com.baidu.ar.camera;

import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

import android.content.Context;
import android.graphics.SurfaceTexture;
import android.hardware.Camera;
import android.os.Handler;
import android.os.HandlerThread;
import android.os.Looper;
import android.os.Message;
import android.view.SurfaceHolder;

/**
 * Created by huxiaowen on 2017/3/22.
 */

public class CameraController implements ICamera, CommonHandlerListener {
    private static final String TAG = CameraController.class.getSimpleName();

    private static final String CAMERA_THREAD_NAME = "CameraHandlerThread";

    private HandlerThread mCameraThread;
    private Handler mCameraHandler;

    private CameraEngine mCameraEngine;
    private CameraCallback mCameraCallback;

    // add Lock to resolve when we first call releaseCamera,then call setupCamera immediately, as program will first
    // run setupCamera in main thread, then run handleReleaseCamera in mCameraThread thread, so the mistake happened
    private final Lock mLock = new ReentrantLock(true);
    // optimize new mCameraThread when mCameraThread releasing.
    private static volatile boolean sThreadStarting = false;

    private static volatile CameraController sInstance;

    public static CameraController getInstance() {
        if (sInstance == null) {
            synchronized (CameraController.class) {
                if (sInstance == null) {
                    sInstance = new CameraController();
                }
            }
        }
        return sInstance;
    }

    private static void releaseInstance() {
        sInstance = null;
    }

    private static void setThreadStarting(boolean value) {
        sThreadStarting = value;
    }

    private static boolean isThreadStarting() {
        return sThreadStarting;
    }

    private CameraController() {
    }

    private void initCameraController() {
        if (!isRunning()) {
            mCameraThread = new HandlerThread(CAMERA_THREAD_NAME);
            mCameraThread.start();
            mCameraHandler = new CameraHandler(mCameraThread.getLooper(), this);
        } else {
            mCameraHandler.removeMessages(CameraHandler.MSG_QUIT_THREAD);
        }
        mCameraEngine = CameraEngine.getInstance();
    }

    public boolean isRunning() {
        return mCameraThread != null && mCameraThread.isAlive();
    }

    public boolean hasPermission(Context context) {
        return CameraHelper.checkCameraPermission(context);
    }

    @Override
    public boolean setupCamera(CameraParams cameraParams, CameraCallback cameraCallback) {
        setThreadStarting(true);
        mLock.lock();
        try {
            initCameraController();
            setThreadStarting(false);
        } finally {
            mLock.unlock();
        }
        mCameraCallback = cameraCallback;
        if (mCameraHandler != null) {
            mCameraHandler.sendMessage(mCameraHandler.obtainMessage(CameraHandler.MSG_SETUP_CAMERA, cameraParams));
        }
        return true;
    }

    @Override
    public void releaseCamera() {
        if (mCameraHandler != null) {
            mCameraHandler.sendMessage(mCameraHandler.obtainMessage(CameraHandler.MSG_RELEASW_CAMERA));
            mCameraHandler.sendMessage(mCameraHandler.obtainMessage(CameraHandler.MSG_QUIT_THREAD));
        }
    }

    @Override
    public void reopenCamera(CameraParams cameraParams) {
        if (mCameraHandler != null) {
            mCameraHandler.sendMessage(mCameraHandler.obtainMessage(CameraHandler.MSG_REOPEN_CAMERA, cameraParams));
        }
    }

    @Override
    public void setSurfaceTexture(SurfaceTexture surfaceTexture) {
        if (mCameraHandler != null) {
            mCameraHandler
                    .sendMessage(mCameraHandler.obtainMessage(CameraHandler.MSG_SET_SURFACE_TEXTURE, surfaceTexture));
        }
    }

    @Override
    public void setSurfaceHolder(SurfaceHolder surfaceHolder) {
        if (mCameraHandler != null) {
            mCameraHandler
                    .sendMessage(mCameraHandler.obtainMessage(CameraHandler.MSG_SET_SURFACE_HOLDER, surfaceHolder));
        }
    }

    @Override
    public void setPreviewCallback(Camera.PreviewCallback previewCallback) {
        if (mCameraHandler != null) {
            mCameraHandler
                    .sendMessage(mCameraHandler.obtainMessage(CameraHandler.MSG_SET_PREVIEW_CALLBACK, previewCallback));
        }
    }

    @Override
    public void setPreviewCallbackWithBuffer(Camera.PreviewCallback previewCallback) {
        if (mCameraHandler != null) {
            mCameraHandler.sendMessage(
                    mCameraHandler.obtainMessage(CameraHandler.MSG_SET_PREVIEW_CALLBACK_WITH_BUFFER, previewCallback));
        }
    }

    @Override
    public void startPreview() {
        if (mCameraHandler != null) {
            mCameraHandler.sendMessage(mCameraHandler.obtainMessage(CameraHandler.MSG_START_PREVIEW_MSG));
        }
    }

    @Override
    public void stopPreview() {
        if (mCameraHandler != null) {
            mCameraHandler.sendMessage(mCameraHandler.obtainMessage(CameraHandler.MSG_STOP_PREVIEW_MSG));
        }
    }

    @Override
    public void openFlash() {
        if (mCameraHandler != null) {
            mCameraHandler.sendMessage(mCameraHandler.obtainMessage(CameraHandler.MSG_OPEN_FLASH));
        }
    }

    @Override
    public void closeFlash() {
        if (mCameraHandler != null) {
            mCameraHandler.sendMessage(mCameraHandler.obtainMessage(CameraHandler.MSG_CLOSE_FLASH));
        }
    }

    @Override
    public void handleMessage(Message msg) {
        switch (msg.what) {
            case CameraHandler.MSG_SETUP_CAMERA:
                handleSetupCamera((CameraParams) msg.obj);
                break;
            case CameraHandler.MSG_RELEASW_CAMERA:
                handleReleaseCamera();
                break;
            case CameraHandler.MSG_REOPEN_CAMERA:
                handleReopenCamera((CameraParams) msg.obj);
                break;
            case CameraHandler.MSG_SET_SURFACE_TEXTURE:
                handleSetSurfaceTexture((SurfaceTexture) msg.obj);
                break;
            case CameraHandler.MSG_SET_SURFACE_HOLDER:
                handleSetSurfaceHolder((SurfaceHolder) msg.obj);
                break;
            case CameraHandler.MSG_SET_PREVIEW_CALLBACK:
                handleSetPreviewCallback((Camera.PreviewCallback) msg.obj);
                break;
            case CameraHandler.MSG_SET_PREVIEW_CALLBACK_WITH_BUFFER:
                handleSetPreviewCallbackWithBuffer((Camera.PreviewCallback) msg.obj);
                break;
            case CameraHandler.MSG_START_PREVIEW_MSG:
                handleStartPreview();
                break;
            case CameraHandler.MSG_STOP_PREVIEW_MSG:
                handleStopPreview();
                break;
            case CameraHandler.MSG_OPEN_FLASH:
                handleOpenFlash();
                break;
            case CameraHandler.MSG_CLOSE_FLASH:
                handleCloseFlash();
                break;
            case CameraHandler.MSG_QUIT_THREAD:
                if (!isThreadStarting()) {
                    mLock.lock();
                    try {
                        handleQuitThread();
                    } finally {
                        mLock.unlock();
                    }
                }
                break;
            default:
                break;
        }
    }

    private void handleSetupCamera(CameraParams cameraParams) {
        boolean result = false;
        if (mCameraEngine != null) {
            result = mCameraEngine.openCamera(cameraParams);
            if (result) {
                result = mCameraEngine.setParameters(cameraParams);
            }
        }
        if (mCameraCallback != null) {
            mCameraCallback.onCameraSetup(result);
        }
    }

    private void handleReleaseCamera() {
        if (mCameraEngine != null) {
            mCameraEngine.release();
            mCameraEngine = null;
        }
    }

    private void handleReopenCamera(CameraParams cameraParams) {
        boolean result = false;
        if (mCameraEngine != null) {
            result = mCameraEngine.stopPreview();
            if (result) {
                mCameraEngine.release();
                mCameraEngine = null;
                mCameraEngine = CameraEngine.getInstance();
                result = mCameraEngine.openCamera(cameraParams);
                if (result) {
                    result = mCameraEngine.setParameters(cameraParams);
                }
            }
        }
        if (mCameraCallback != null) {
            mCameraCallback.onCameraReopen(result);
        }
    }

    private void handleSetSurfaceTexture(SurfaceTexture surfaceTexture) {
        boolean result = false;
        if (mCameraEngine != null) {
            result = mCameraEngine.setPreviewTexture(surfaceTexture);
        }
        if (mCameraCallback != null) {
            mCameraCallback.onSurfaceTextureSet(result);
        }
    }

    private void handleSetSurfaceHolder(SurfaceHolder surfaceHolder) {
        boolean result = false;
        if (mCameraEngine != null) {
            result = mCameraEngine.setPreviewHolder(surfaceHolder);
        }
        if (mCameraCallback != null) {
            mCameraCallback.onSurfaceHolderSet(result);
        }
    }

    private void handleSetPreviewCallback(Camera.PreviewCallback previewCallback) {
        boolean result = false;
        if (mCameraEngine != null) {
            result = mCameraEngine.setPreviewCallback(previewCallback);
        }
        if (mCameraCallback != null) {
            mCameraCallback.onPreviewCallbackSet(result);
        }
    }

    private void handleSetPreviewCallbackWithBuffer(Camera.PreviewCallback previewCallback) {
        boolean result = false;
        if (mCameraEngine != null) {
            result = mCameraEngine.setPreviewCallbackWithBuffer(previewCallback);
        }
        if (mCameraCallback != null) {
            mCameraCallback.onPreviewCallbackSet(result);
        }
    }

    private void handleStartPreview() {
        boolean result = false;
        if (mCameraEngine != null) {
            result = mCameraEngine.startPreview();
        }
        if (mCameraCallback != null) {
            mCameraCallback.onPreviewStart(result);
        }
    }

    private void handleStopPreview() {
        boolean result = false;
        if (mCameraEngine != null) {
            result = mCameraEngine.stopPreview();
        }
        if (mCameraCallback != null) {
            mCameraCallback.onPreviewStop(result);
        }
    }

    private void handleOpenFlash() {
        boolean result = false;
        if (mCameraEngine != null) {
            result = mCameraEngine.openFlash();
        }
        if (mCameraCallback != null) {
            mCameraCallback.onFlashOpen(result);
        }
    }

    private void handleCloseFlash() {
        boolean result = false;
        if (mCameraEngine != null) {
            result = mCameraEngine.closeFlash();
        }
        if (mCameraCallback != null) {
            mCameraCallback.onFlashClose(result);
        }
    }

    private void handleQuitThread() {
        if (mCameraCallback != null) {
            mCameraCallback.onCameraRelease(true);
            mCameraCallback = null;
        }
        if (mCameraThread != null) {
            mCameraThread.getLooper().quit();
        }
        mCameraThread = null;
        mCameraHandler = null;
        releaseInstance();
    }

    private static class CameraHandler extends Handler {
        public static final int MSG_SETUP_CAMERA = 1001;
        public static final int MSG_RELEASW_CAMERA = 1002;
        public static final int MSG_REOPEN_CAMERA = 1003;
        public static final int MSG_SET_SURFACE_TEXTURE = 1004;
        public static final int MSG_SET_SURFACE_HOLDER = 1005;
        public static final int MSG_SET_PREVIEW_CALLBACK = 1006;
        public static final int MSG_SET_PREVIEW_CALLBACK_WITH_BUFFER = 1007;
        public static final int MSG_START_PREVIEW_MSG = 1008;
        public static final int MSG_STOP_PREVIEW_MSG = 1009;
        public static final int MSG_OPEN_FLASH = 1010;
        public static final int MSG_CLOSE_FLASH = 1011;
        public static final int MSG_QUIT_THREAD = 1012;

        private CommonHandlerListener listener;

        public CameraHandler(Looper looper, CommonHandlerListener listener) {
            super(looper);
            this.listener = listener;
        }

        @Override
        public void handleMessage(Message msg) {
            listener.handleMessage(msg);
        }
    }
}

