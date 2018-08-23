/*
 * Copyright (C) 2018 Baidu, Inc. All Rights Reserved.
 */
package com.baidu.ar.pro.module;

import java.util.HashMap;
import java.util.List;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import com.baidu.ar.ARController;
import com.baidu.ar.logo.CameraPreViewCallback;
import com.baidu.ar.logo.IttRecognitionCallback;
import com.baidu.ar.logo.IttRecognitionManager;
import com.baidu.ar.logo.LogoModel;
import com.baidu.ar.logo.RecognitionRes;
import com.baidu.ar.msghandler.ComponentMessageType;
import com.baidu.ar.msghandler.ComponentMsgHandler;

import android.content.Context;

/**
 * Created by baidu on 2018/2/11.
 */

public class LogoController implements IttRecognitionCallback, CameraPreViewCallback {

    private static final int RECG_STATE_START = 0;

    private static final int RECG_STATE_WAIT = 1;

    private static final int RECG_STATE_STOP = 2;

    private ExecutorService mSingleThreadPoolExecutor = Executors.newSingleThreadExecutor();

    Context mContext;

    /**
     * 用于判断当前识别的状态 内部用
     */
    private int recgState = RECG_STATE_STOP;

    private boolean isRecoding = false;

    private ARController mARController;

    public LogoController(Context context, ARController arController) {
        this.mContext = context;
        mARController = arController;
        IttRecognitionManager.getInstance().initCloudRecognition(context, this);
        mARController.setCameraPreViewCallback(this);
    }

    public void attchView() {
        recgState = RECG_STATE_START;
    }

    public void removeLogoScanView() {
        recgState = RECG_STATE_STOP;
    }

    @Override
    public void recognition(List<RecognitionRes> recognitionRes) {
        if (recgState == RECG_STATE_STOP) {
            return;
        }
        if (recognitionRes.size() <= 0) {
            recgState = RECG_STATE_START;
            return;
        }

        LogoModel logoModel = IttRecognitionManager.getInstance().matchLogoKey(recognitionRes);
        if (logoModel != null) {
            // 向lua发送指令
            HashMap mapData = new HashMap();
            mapData.put("id", ComponentMessageType.MSG_TYPE_LOGOT);
            mapData.put("logo_code", ComponentMessageType.MSG_TYPE_LOGO_HIT);
            mapData.put("logo_result", logoModel.getHeadName());
            ComponentMsgHandler.sendMessageToLua(mapData);
            recgState = RECG_STATE_STOP;
            return;
        }

        recgState = RECG_STATE_START;
        return;
    }

    public void recogintion(final byte[] dataBuffer, final int width, final int height) {
        // 连网之前询问用户
        if (RECG_STATE_START == recgState) {
            recgState = RECG_STATE_WAIT;
            mSingleThreadPoolExecutor.execute(new Runnable() {
                @Override
                public void run() {
                    IttRecognitionManager.getInstance()
                            .setYUVFile(dataBuffer, width, height);
                }
            });
        }

    }

    public void onResume() {
        if (recgState == RECG_STATE_STOP) {
            return;
        }
        recgState = RECG_STATE_START;
    }

    public void onPause() {
        if (recgState == RECG_STATE_STOP) {
            return;
        }
        recgState = RECG_STATE_WAIT;
    }

    public void release() {
        recgState = RECG_STATE_STOP;
        removeLogoScanView();
        IttRecognitionManager.getInstance().releaseInstance();
    }

    @Override
    public void onPreviewCallback(byte[] bytes, int width, int height) {
        recogintion(bytes, width, height);
    }
}

