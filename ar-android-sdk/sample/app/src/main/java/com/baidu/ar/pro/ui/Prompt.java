/*
 * Copyright (C) 2018 Baidu, Inc. All Rights Reserved.
 */
package com.baidu.ar.pro.ui;

import java.util.HashMap;

import com.baidu.ar.ARController;
import com.baidu.ar.DuMixCallback;
import com.baidu.ar.base.MsgField;
import com.baidu.ar.bean.ARConfig;
import com.baidu.ar.bean.ARResource;
import com.baidu.ar.bean.BrowserBean;
import com.baidu.ar.bean.TipBean;
import com.baidu.ar.bean.TrackRes;
import com.baidu.ar.pro.R;
import com.baidu.ar.pro.callback.PromptCallback;
import com.baidu.ar.pro.module.Module;
import com.baidu.ar.pro.view.ARControllerManager;
import com.baidu.ar.pro.view.PointsView;
import com.baidu.ar.pro.view.ScanView;
import com.baidu.ar.recg.CornerPoint;
import com.baidu.ar.speech.SpeechStatus;
import com.baidu.ar.speech.listener.SpeechRecogListener;
import com.baidu.ar.util.Res;
import com.baidu.ar.util.UiThreadUtil;

import android.content.Context;
import android.text.TextUtils;
import android.util.AttributeSet;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

/**
 * 提示层UI
 * Created by xiegaoxi on 2018/5/10.
 */

public class Prompt extends RelativeLayout implements View.OnClickListener, DuMixCallback {

    public static final String TAG = "PromptView";
    /**
     * 返回按钮
     */
    private ImageView mIconBack;
    /**
     * 返回按钮
     */
    private ImageView mIconCamera;

    /**
     * 闪光灯按钮
     */
    private ImageView mIconFlash;
    /**
     * 拍照按钮
     */
    private Button mTackPictureBtn;
    /**
     * 开始录制按钮
     */
    private Button mStartRecordBtn;
    /**
     * 停止录制按钮
     */
    private Button mStopRecordBtn;

    /**
     * 闪光灯是否处于关闭模式
     */
    private boolean mIsFlashOff = true;

    /**
     * Du Mix 状态回调
     */
    private DuMixCallback mDuMixCallback;

    /**
     * Prompt callback
     */
    private PromptCallback mPromptCallback;

    /**
     * Du Mix 状态回调提示文字
     */
    private TextView mDumixCallbackTips;

    /**
     * 本地识图云端识图返回的arKey
     */
    private String arKey;

    /**
     * track 扫描view
     */
    private ScanView mScanView;

    /**
     * 云点
     */
    private PointsView mPointsView;

    private float mScaleWidth;
    private float mScaleHeight;

    /**
     * 依赖外部Module
     */
    private Module mModule;

    /**
     * 2D识图提示文案
     */
    private String mDefaultHint;

    /**
     * ar sdk 接口ARController
     */
    private ARController mARController;

    private RelativeLayout mPluginContainer;

    /**
     * 构造函数
     *
     * @param context context
     */
    public Prompt(Context context) {
        super(context);
        init(context);
    }

    /**
     * 构造函数
     *
     * @param context context
     * @param attrs   attrs
     */
    public Prompt(Context context, AttributeSet attrs) {
        super(context, attrs);
        init(context);
    }

    /**
     * 构造函数
     *
     * @param context  context
     * @param attrs    attrs
     * @param defStyle defStyle
     */
    public Prompt(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
        init(context);
    }

    /**
     * init layout
     */
    private void init(Context context) {
        mARController = ARControllerManager.getInstance(context).getArController();
        LayoutInflater.from(context).inflate(R.layout.bdar_layout_prompt, this);
        // button
        mIconBack = findViewById(R.id.bdar_titlebar_back);
        mIconBack.setOnClickListener(this);
        mIconCamera = findViewById(R.id.bdar_titlebar_camera);
        mIconCamera.setOnClickListener(this);
        mIconFlash = findViewById(R.id.bdar_titlebar_flash);
        mIconFlash.setOnClickListener(this);

        mTackPictureBtn = findViewById(R.id.btn_take_picture);
        mTackPictureBtn.setOnClickListener(this);

        mStartRecordBtn = findViewById(R.id.btn_start_record);
        mStartRecordBtn.setOnClickListener(this);

        mStopRecordBtn = findViewById(R.id.btn_stop_record);
        mStopRecordBtn.setOnClickListener(this);

        mDumixCallbackTips = findViewById(R.id.bdar_titlebar_tips);

        mScanView = findViewById(R.id.bdar_gui_scan_view);

        mPointsView = findViewById(R.id.bdar_gui_point_view);

        mPluginContainer = findViewById(R.id.bdar_id_plugin_container);

        mDuMixCallback = this;

        mModule = new Module(getContext(), mARController);
        mModule.setSpeechRecogListener(speechRecogListener);
        mModule.setPluginContainer(mPluginContainer);
    }

    public DuMixCallback getDuMixCallback() {
        return mDuMixCallback;
    }

    public void setPromptCallback(PromptCallback callback) {
        mPromptCallback = callback;
    }

    @Override
    public void onClick(View view) {
        int viewId = view.getId();
        if (viewId == R.id.bdar_titlebar_back) {
            if (mPromptCallback != null) {
                mPromptCallback.onBackPressed();
            }
        } else if (viewId == R.id.bdar_titlebar_camera) {
            if (mPromptCallback != null) {
                mPromptCallback.onSwitchCamera();
            }
        } else if (viewId == R.id.bdar_titlebar_flash) {
            if (mPromptCallback != null) {
                mPromptCallback.onCameraFlashStatus(mIsFlashOff);
            }
            mIsFlashOff = !mIsFlashOff;
            if (mIsFlashOff) {
                mIconFlash.setImageDrawable(getResources().getDrawable(R.drawable
                        .bdar_drawable_btn_flash_disable_selector));
            } else {
                mIconFlash.setImageDrawable(getResources().getDrawable(R.drawable
                        .bdar_drawable_btn_flash_enable_selector));
            }
        } else if (viewId == R.id.btn_take_picture) {
            onTackPictureButtonClick();
        } else if (viewId == R.id.btn_start_record) {
            onStratRecordButtonClick();
        } else if (viewId == R.id.btn_stop_record) {
            onStopRecordButtonClick();

        }
    }

    private void onStratRecordButtonClick() {
        mPromptCallback.onStartRecord();
    }

    private void onStopRecordButtonClick() {
        mPromptCallback.onStropRecord();
    }

    private void onTackPictureButtonClick() {
        mPromptCallback.onTackPicture();
    }

    public void release() {
        mDuMixCallback = null;
        mPromptCallback = null;
    }

    // callback
    @Override
    public void onStateChange(final int state, final Object msg) {
        Log.e(TAG, "onStateChange, state = " + state + " msg = " + msg);

        switch (state) {
            case MsgField.MSG_STAT_FIRST_LOAD_QUERY_FAILURE:
            case MsgField.MSG_AUTH_FAIL:
                UiThreadUtil.runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        Toast.makeText(getContext(), getContext().getText(R.string.auth_fail), Toast.LENGTH_SHORT)
                                .show();
                        if (mPromptCallback != null) {
                            mPromptCallback.onBackPressed();
                        }
                    }
                });
                break;
            case MsgField.MSG_ON_QUERY_RESOURCE:
                // 初始隐藏scanview
                hideScanView();
                break;
            // so加载成功
            case MsgField.IMSG_SO_LOAD_SUCCESS:
                showToast("so load success");
                break;

            // so加载失败
            case MsgField.IMSG_SO_LOAD_FAILED:
                showToast("so load failed");
                break;

            // 解压zip失败
            case MsgField.MSG_ON_PARSE_RESOURCE_UNZIP_ERROR:
                showToast(Res.getString("bdar_error_unzip"));
                break;
            case MsgField.MSG_ON_PARSE_RESOURCE_JSON_ERROR:
                showToast(Res.getString("bdar_error_json_parser"));
                break;

            // 识图AR错误消息
            case MsgField.IMSG_RECGAR_TOAST_ERROR:
                showToast("识图AR错误消息");
                break;

            // 识图AR网络错误
            case MsgField.IMSG_RECGAR_NETWORT_ERROR:
                showToast("识图AR网络错误");
                break;

            // 云端识图AR错误消息
            case MsgField.IMSG_CLOUDAR_TOAST_ERROR:
                showToast("云端识图AR错误消息");
                break;

            // 截图成功
            case MsgField.IMSG_SAVE_PICTURE:
                showToast(" 截图成功");
                break;

            // 录制成功
            case MsgField.IMSG_SAVE_VIDEO:
                showToast(" 录制成功");
                break;

            // 网络未连接
            case MsgField.IMSG_NO_NETWORK:
                showToast(" 网络未连接");
                break;

            // 识图初始化
            case MsgField.IMSG_ON_DEVICE_IR_START:
                showToast(" 识图初始化");
                break;

            // 云端识图初始化
            case MsgField.IMSG_CLORD_ID_START:
                showToast(" 云端识图初始化");
                break;

            // track 模型显示
            case MsgField.IMSG_TRACK_MODEL_APPEAR:
                showToast(" track 模型显示");
                break;

            // slam 模型消失
            case MsgField.IMSG_SLAM_MODEL_DISAPPEAR:
                showToast(" slam 模型消失");
                break;

            // imu 模型消失
            case MsgField.IMSG_IMU_MODEL_DISAPPEAR:
                showToast(" imu 模型消失");
                break;

            // 2D算法跟踪丢失
            case MsgField.IMSG_TRACK_LOST:
                showToast(" 2D算法跟踪丢失 ");
                break;

            // 2D算法跟踪成功
            case MsgField.IMSG_TRACK_FOUND:
                hideScanView();
                showToast(" 2D算法跟踪成功 ");
                break;
            // 跟踪距离过远
            case MsgField.IMSG_TRACK_DISTANCE_TOO_FAR:
                showToast(" 跟踪距离过远 ");
                break;

            // 跟踪距离过近
            case MsgField.IMSG_TRACK_DISTANCE_TOO_NEAR:
                showToast(" 跟踪距离过近 ");
                break;

            // 跟踪距离正常
            case MsgField.IMSG_TRACK_DISTANCE_NORMAL:
                showToast(" 跟踪距离正常 ");
                break;

            // 引擎模型加载完毕, 所有ar业务都会发送此消息
            case MsgField.IMSG_MODEL_LOADED:
                showToast(" 引擎模型加载完毕 ");
                break;

            // Track消息 tips提示
            case MsgField.IMSG_TRACKED_TIPS_INFO:
                // TODO: 2018/6/21 case配置
                TrackRes trackRes = (TrackRes) msg;
                break;

            case MsgField.IMSG_MODE_SHOWING:
                break;

            // track 模型消失
            case MsgField.IMSG_TRACK_MODEL_NOT_SHOWING:
                break;
            // track 模型消失
            case MsgField.IMSG_TRACK_HIDE_LOST_INFO:
                // set lost info view GONE
                break;

            case MsgField.IMSG_TRACKED_TARGET_BITMAP_RES:
                break;

            case MsgField.MSG_ID_TRACK_MODEL_CAN_DISAPPEARING:
                boolean modelShowing = (boolean) msg;
                if (!modelShowing) {
                    showScanView();
                }
                break;

            case MsgField.MSG_ID_TRACK_MSG_ID_TRACK_LOST:
                break;
            case MsgField.MSG_OPEN_URL:
                BrowserBean browserBean = (BrowserBean) msg;
                String url = browserBean.getUrl();
                int type = browserBean.getType();
                // 打开url链接处理
                //                mUIController.getARCallback().openUrl(url);
                break;
            case MsgField.MSG_PADDLE_INIT:
                break;
            case MsgField.MSG_SHARE:
                break;
            // 本地识图 识别结果
            case MsgField.MSG_ON_DEVICE_IR_RESULT:
                setPointViewVisible(false);
                arKey = (String) msg;
                // 根据本地识图结果 切换case
                mPromptCallback.onChangeCase(arKey);
                showToast(" 本地识图成功.切换CASE: " + arKey);
                break;
            case MsgField.IMSG_CLOUDAR_RECG_RESULT:
                setPointViewVisible(false);
                arKey = (String) msg;
                // 根据云端识图结果 切换case
                mPromptCallback.onChangeCase(arKey);
                showToast(" 云端识图成功.切换CASE: " + arKey);
                break;
            case MsgField.IMSG_DEVICE_NOT_SUPPORT:
                showToast("哎呦，机型硬件不支持");
                break;
            default:
                break;
        }

    }

    @Override
    public void onLuaMessage(HashMap<String, Object> hashMap) {
        // TODO: 2018/5/10 接收lua信息到业务层
        mModule.parseLuaMessage(hashMap);

    }

    @Override
    public void onStateError(int i, String s) {
    }

    @Override
    public void onSetup(boolean b) {
        Log.e(TAG, "onStateChange, state = " + " onSetup ");
    }

    @Override
    public void onCaseChange(boolean b) {
        Log.e(TAG, "onStateChange, state = " + " onCaseChange ");
    }

    @Override
    public void onCaseCreated(ARResource arResource) {
        Log.e(TAG, "onStateChange, state = " + " onCaseCreated ");
    }

    @Override
    public void onPause(boolean b) {
        mModule.onPause();
    }

    @Override
    public void onResume(boolean b) {
        mModule.onResume();
    }

    @Override
    public void onReset(boolean b) {

    }

    @Override
    public void onRelease(boolean b) {
        mModule.onRelease();

    }
    // callback end

    public void pause() {
        mModule.onPause();
    }

    public void resume() {
        mModule.onResume();
    }

    /**
     * ui 界面提示信息
     *
     * @param s
     */
    private void showToast(final String s) {
        UiThreadUtil.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                mDumixCallbackTips.setText(s);
            }
        });
    }

    /**
     * 显示扫描界面
     */
    protected void showScanView() {
        UiThreadUtil.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                if (mScanView != null) {
                    mScanView.startScan();
                }
            }
        });
    }

    /**
     * 隐藏扫描界面
     */
    protected void hideScanView() {
        UiThreadUtil.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                if (mScanView != null) {
                    mScanView.dismissScan();
                }
            }
        });
    }

    SpeechRecogListener speechRecogListener = new SpeechRecogListener() {
        @Override
        public void onSpeechRecog(int status, String result) {
            if (status == SpeechStatus.PARTIALRESULT || status == SpeechStatus.RESULT) {
                showToast(result);
                mModule.parseResult(result);
            }
            mModule.setVoiceStatus(status);

        }
    };

    public void setCornerPoint(final CornerPoint[] cornerPoints) {
        UiThreadUtil.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                mPointsView.setNrCornerAndCornersData(cornerPoints, mScaleWidth, mScaleHeight);
                mPointsView.invalidate();
            }
        });
    }

    /**
     * 计算屏幕和preview 的宽高比
     */

    public void initPreviewScreenScale(int cameraW, int cameraH) {
        DisplayMetrics dm = getResources().getDisplayMetrics();
        mScaleHeight = (float) ((dm.heightPixels * 1.0) / (cameraW * 1.0));
        mScaleWidth = (float) ((dm.widthPixels * 1.0) / (cameraH * 1.0));
    }

    public void setPointViewVisible(final boolean visible) {
        UiThreadUtil.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                mPointsView.clear();
                mPointsView.setVisibility(visible ? View.VISIBLE : View.GONE);
            }
        });
    }

}
