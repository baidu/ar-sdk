/*
 * Copyright (C) 2018 Baidu, Inc. All Rights Reserved.
 */
package com.baidu.ar.pro.view;

import com.baidu.ar.pro.R;

import android.app.Activity;
import android.content.Context;
import android.util.AttributeSet;
import android.view.View;
import android.widget.FrameLayout;
import android.widget.TextView;

public class LoadingView extends FrameLayout {
    /**
     * loading msg
     */
    private TextView mMsg;

    /**
     * 构造函数
     *
     * @param context context
     */
    public LoadingView(Context context) {
        super(context);
        init();
    }

    /**
     * 构造函数
     *
     * @param context context
     * @param attrs   attrs
     */
    public LoadingView(Context context, AttributeSet attrs) {
        super(context, attrs);
        init();
    }

    /**
     * 构造函数
     *
     * @param context  context
     * @param attrs    attrs
     * @param defStyle defStyle
     */
    public LoadingView(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
        init();
    }

    /**
     * init
     */
    private void init() {
        Context context = getContext();
        Activity activity = null;
        if (context instanceof Activity) {
            activity = (Activity) context;
            activity.getLayoutInflater().inflate(R.layout.view_loading, this, true);
            mMsg = (TextView) findViewById(R.id.tv_loading_message);
        }
    }

    /**
     * 设置显示提示文案
     *
     * @param resourceId 资源id
     */
    public void setMsg(int resourceId) {
        if (mMsg != null) {
            mMsg.setText(resourceId);
        }
    }

    /**
     * 设置显示提示文案
     *
     * @param msg msg
     */
    public void setMsg(String msg) {
        if (mMsg != null) {
            mMsg.setText(msg);
        }
    }

    /**
     * 显示
     */
    public void show() {
        this.setVisibility(View.VISIBLE);
    }

    /**
     * 消失
     */
    public void dismiss() {
        this.setVisibility(View.GONE);
    }

}