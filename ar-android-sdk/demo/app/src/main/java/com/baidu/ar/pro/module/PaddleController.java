/*
 * Copyright (C) 2018 Baidu, Inc. All Rights Reserved.
 */
package com.baidu.ar.pro.module;

import java.util.ArrayList;
import java.util.HashMap;

import com.baidu.ar.paddle.ARPaddleHelper;
import com.baidu.ar.paddle.PaddleManager;
import com.baidu.ar.pro.view.ARControllerManager;
import com.baidu.baiduarsdk.ArBridge;
import com.baidu.baiduarsdk.util.MsgParamsUtil;

import android.content.Context;
import android.text.TextUtils;

public class PaddleController {
    private Context mContext;

    public PaddleController(Context context) {
        mContext = context;
    }

    public void paddleInit(Object msg) {
        HashMap<String, Object> mapParams = (HashMap<String, Object>) msg;
        if (mapParams != null) {
            String path = MsgParamsUtil.obj2String(mapParams.get("path0"), "");
            String secretKey = MsgParamsUtil.obj2String(mapParams.get("secretKey"), "");
            // 若未解析出paddle模型路径，则不初始化
            if (!TextUtils.isEmpty(path)) {
                initPaddle(path, secretKey, mapParams);
            }
        }
    }

    /**
     * 接收lua消息，控制paddle-手势的开启关闭
     *
     * @param msg
     */
    public void gestureEnable(Object msg) {
        PaddleManager.getInstance()
                .enablePaddle((boolean) msg, com.baidu.ar.paddle.PaddleController.PADDLE_TYPE_GESTURE);
    }

    /**
     * 接收lua消息，控制paddle-背景分割的开启关闭
     *
     * @param msg
     */
    public void imgSegEnable(Object msg) {
        PaddleManager.getInstance()
                .enablePaddle((boolean) msg, com.baidu.ar.paddle.PaddleController.PADDLE_TYPE_IMG_SEG);
    }

    /**
     * paddle初始化
     *
     * @param path      模型路径
     * @param secretKey 模型密钥
     */
    private void initPaddle(String path, String secretKey, HashMap<String, Object> mapParams) {
        // 新配置策略的paddleNum值不为0
        int num = MsgParamsUtil.obj2Int(mapParams.get("paddleNum"), 0);
        // 执行新的初始化方法
        if (num > 0) {
            ArrayList<String> pathList = new ArrayList<>();
            ArrayList<String> typeList = new ArrayList<>();
            ArrayList<Integer> widthList = new ArrayList<>();
            ArrayList<Integer> heightList = new ArrayList<>();
            ArrayList<Float> fgThresList = new ArrayList<>();
            ArrayList<Float> bgThresList = new ArrayList<>();
            ArrayList<String> nodeNameList = new ArrayList<>();
            ArrayList<Float> rMeanList = new ArrayList<>();
            ArrayList<Float> gMeanList = new ArrayList<>();
            ArrayList<Float> bMeanList = new ArrayList<>();
            ArrayList<Float> rScaleList = new ArrayList<>();
            ArrayList<Float> gScaleList = new ArrayList<>();
            ArrayList<Float> bScaleList = new ArrayList<>();

            for (int i = 0; i < num; i++) {
                pathList.add(MsgParamsUtil.obj2String(mapParams.get("path" + i), null));
                typeList.add(MsgParamsUtil.obj2String(mapParams.get("type" + i), null));
                widthList.add(MsgParamsUtil.obj2Int(mapParams.get("width" + i), 0));
                heightList.add(MsgParamsUtil.obj2Int(mapParams.get("height" + i), 0));
                fgThresList.add(MsgParamsUtil.obj2Float(mapParams.get("fgThres" + i), -1));
                bgThresList.add(MsgParamsUtil.obj2Float(mapParams.get("bgThres" + i), -1));
                nodeNameList.add(MsgParamsUtil.obj2String(mapParams.get("nodeName" + i), null));
                rMeanList.add(MsgParamsUtil.obj2Float(mapParams.get("rMean" + i), -1));
                gMeanList.add(MsgParamsUtil.obj2Float(mapParams.get("gMean" + i), -1));
                bMeanList.add(MsgParamsUtil.obj2Float(mapParams.get("bMean" + i), -1));
                rScaleList.add(MsgParamsUtil.obj2Float(mapParams.get("rScale" + i), -1));
                gScaleList.add(MsgParamsUtil.obj2Float(mapParams.get("gScale" + i), -1));
                bScaleList.add(MsgParamsUtil.obj2Float(mapParams.get("bScale" + i), -1));
            }
            PaddleManager.getInstance().initPaddle(mContext, pathList, secretKey,
                    typeList, widthList, heightList, fgThresList, bgThresList, nodeNameList,
                    rMeanList, gMeanList, bMeanList, rScaleList, gScaleList, bScaleList,
                    new ARPaddleHelper(),
                    new com.baidu.ar.paddle.PaddleController.ActionListener() {
                        @Override
                        public void onGestureResult(HashMap result) {
                            sendPaddleGestureResult(result);
                        }

                        @Override
                        public void startImgSeg(String nodeName) {
                            // 开启背景分割，nodeName为节点名
                            ARControllerManager.getInstance(mContext).getArController()
                                    .switchCameraInFgAndBg(2, nodeName);
                        }

                        @Override
                        public void onImgSegResult(byte[] result, int width, int height, byte[] previewData,
                                                   int orientation) {
                            // 更新背景分割数据，byte数组长度为 width*height*4
                            int widthMask = Math.min(width, height);
                            int heightMask = Math.max(width, height);
                            ARControllerManager.getInstance(mContext).getArController()
                                    .managePreviewFrame(previewData, heightMask, widthMask);
                            ARControllerManager.getInstance(mContext).getArController()
                                    .updateSegMaskData(result, widthMask, heightMask,
                                            orientation);
                        }

                        @Override
                        public void stopImgSeg() {
                            // 停止背景分割
                            ARControllerManager.getInstance(mContext).getArController().switchCameraInFgAndBg(1, null);
                        }
                    });
        }
    }

    /**
     * 向lua发送paddle手势检测结果信息
     *
     * @param mapData
     */
    private void sendPaddleGestureResult(HashMap mapData) {
        ArBridge.getInstance().sendMessage(ArBridge.MessageType.MSG_TYPE_SDK_LUA_BRIDGE, mapData);
    }
}
