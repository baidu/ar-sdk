/*
 * Copyright (C) 2018 Baidu, Inc. All Rights Reserved.
 */
package com.baidu.ar.pro.view;

import com.baidu.ar.pro.R;
import com.baidu.recg.CornerPoint;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.util.AttributeSet;
import android.view.View;

/**
 * Created by puchunjie on 2018/5/17.
 * 自定义point 扫描点
 */

public class PointsView extends View {

    private int mNrCorner;
    private CornerPoint[] mCorners;

    private Paint mPaint;
    private Bitmap bitmap;

    public PointsView(Context context) {
        super(context);
        initPaint();
    }

    public PointsView(Context context, AttributeSet attrs) {
        super(context, attrs);
        initPaint();
    }

    public PointsView(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        initPaint();
    }

    @Override
    protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
        super.onMeasure(widthMeasureSpec, heightMeasureSpec);
        int widthMode = MeasureSpec.getMode(widthMeasureSpec);
        int heightMode = MeasureSpec.getMode(heightMeasureSpec);
        int sizeWidth = MeasureSpec.getSize(widthMeasureSpec);
        int sizeHeight = MeasureSpec.getSize(heightMeasureSpec);

        // 计算出所有的childView的宽和高
        setMeasuredDimension(sizeWidth, sizeHeight);
    }

    @Override
    protected void onDraw(Canvas canvas) {
        super.onDraw(canvas);
        if (mNrCorner > 0) {
            for (CornerPoint cornerPoint : mCorners) {
                drawCircle(canvas, (int) (cornerPoint.x * mScaleWidth), (int) (cornerPoint.y * mScaleHeight));
            }
        }
    }

    public void initPaint() {
        mPaint = new Paint();
        bitmap = BitmapFactory.decodeResource(getResources(), R.drawable.bd_browser_drawable_trigger_point);
    }

    private float mScaleWidth = 1.0f;
    private float mScaleHeight = 1.0f;

    public void setNrCornerAndCornersData(CornerPoint[] corners, float scaleWidth, float scaleHeight) {
        // mNrCorner = nrCorner;
        mNrCorner = corners.length;
        mCorners = corners;
        mScaleWidth = scaleWidth;
        mScaleHeight = scaleHeight;
    }

    public void clear() {
        mNrCorner = 0;
        mCorners = null;
        invalidate();
    }

    public void drawCircle(Canvas canvas, int x, int y) {
        int centerX = x;
        int centerY = y;
        // 开始绘制
        canvas.drawBitmap(bitmap, centerX, centerY, mPaint);
    }

}

