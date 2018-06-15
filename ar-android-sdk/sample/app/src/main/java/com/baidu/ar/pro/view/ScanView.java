/*
 * Copyright (C) 2018 Baidu, Inc. All Rights Reserved.
 */
package com.baidu.ar.pro.view;

import java.lang.ref.WeakReference;

import com.baidu.ar.pro.R;
import com.baidu.ar.util.Res;

import android.annotation.SuppressLint;
import android.annotation.TargetApi;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Matrix;
import android.graphics.Paint;
import android.graphics.Path;
import android.graphics.Rect;
import android.graphics.RectF;
import android.graphics.Shader;
import android.graphics.SweepGradient;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.util.AttributeSet;
import android.view.View;

/**
 * scan view
 *
 * @author rendayun
 * @since 2016-07-11
 */
public class ScanView extends View {
    /**
     * 起始角度
     */
    private int mScanStart = 180;
    /**
     * 中心点X坐标
     */
    private int centerX;
    /**
     * 中心点Y坐标
     */
    private int centerY;
    /**
     * 半径
     */
    private int mRadius;
    /**
     * painter
     */
    private Paint mPaintScan;
    /**
     * matrix
     */
    private Matrix mScanMatrix;
    /**
     * 中心点图片资源ID
     */
    private Drawable mCenterPointIcon = null;
    /**
     * Thread
     */
    private Thread mThread;
    /**
     * mRunnable
     */
    private MatrixRotateRunnable mRunnable = null;
    /**
     * Context
     */
    private Context mContext;
    /**
     * 扫描Shader
     */
    private Shader mScanShader = null;
    /**
     * 扫描颜色
     */
    public static final int bdar_scanview_gradient_color_1 = 0x002cccf8;
    public static final int bdar_scanview_gradient_color_2 = 0x002cccf8;
    public static final int bdar_scanview_gradient_color_3 = 0x002cccf8;
    public static final int bdar_scanview_gradient_color_4 = 0x662cccf8;
    /**
     * 扫描Shader颜色 默认
     */
    private int[] mDefaultSharpColor =
            new int[] {bdar_scanview_gradient_color_1, bdar_scanview_gradient_color_2,
                    bdar_scanview_gradient_color_3, bdar_scanview_gradient_color_4};

    public static class MatrixRotateRunnable implements Runnable {
        private WeakReference<ScanView> mScanViewRef = null;

        public MatrixRotateRunnable(ScanView scanView) {
            mScanViewRef = new WeakReference<ScanView>(scanView);
        }

        public void release() {
            if (null != mScanViewRef) {
                mScanViewRef.clear();
            }
            mScanViewRef = null;
        }

        @Override
        public void run() {
            if (null != mScanViewRef) {
                ScanView scanView = mScanViewRef.get();
                if (scanView != null) {
                    while (scanView.isScaning()) {
                        scanView.increaseMatrixRotate();
                        try {
                            Thread.sleep(30);
                        } catch (InterruptedException e) {
                            // e.printStackTrace();
                        }
                    }
                }
            }
        }
    }

    /**
     * scan flag
     */
    private boolean mScanFlag = false;
    /**
     * 圆环 path
     */
    Path mRingPath = null;
    private boolean mIsOnSizeChanged = false;

    /**
     * 构造函数
     *
     * @param context 上下文
     */
    public ScanView(Context context) {
        super(context);
        init(null, context);
    }

    /**
     * 构造函数
     *
     * @param context 上下文
     * @param attrs   attribute set
     */
    public ScanView(Context context, AttributeSet attrs) {
        super(context, attrs);
        init(attrs, context);
    }

    /**
     * 构造函数
     *
     * @param context
     * @param attrs
     * @param defStyleAttr
     */
    public ScanView(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        init(attrs, context);
    }

    /**
     * 构造函数
     *
     * @param context
     * @param attrs
     * @param defStyleAttr
     * @param defStyleRes
     */
    @TargetApi(21)
    public ScanView(Context context, AttributeSet attrs, int defStyleAttr, int defStyleRes) {
        super(context, attrs, defStyleAttr, defStyleRes);
        init(attrs, context);
    }

    @Override
    protected void onSizeChanged(int w, int h, int oldw, int oldh) {
        super.onSizeChanged(w, h, oldw, oldh);
        centerX = w / 2;
        centerY = h / 2;
        mRadius = Math.max(w, h);
        //        invalidate();
        mIsOnSizeChanged = true;
    }

    @Override
    protected void onAttachedToWindow() {
        super.onAttachedToWindow();
        if (null != mRunnable) {
            mRunnable.release();
            mRunnable = null;
        }
        mRunnable = new MatrixRotateRunnable(this);
    }

    @Override
    protected void onDetachedFromWindow() {
        dismissScan();
        if (null != mRunnable) {
            mRunnable.release();
            mRunnable = null;
        }
        super.onDetachedFromWindow();
    }

    /**
     * 初始化
     *
     * @param attrs   属性
     * @param context 上下文
     */
    private void init(AttributeSet attrs, Context context) {
        mContext = context;
        initPaint();
        mScanMatrix = new Matrix();
        mCenterPointIcon = mContext.getResources().getDrawable(R.drawable.bdar_drawable_scan_center);
    }

    /**
     * 初始化paint
     */
    private void initPaint() {
        mPaintScan = new Paint();
        mPaintScan.setColor(Color.WHITE);
        mPaintScan.setAntiAlias(true);
    }

    @SuppressLint("DrawAllocation")
    @Override
    protected void onDraw(Canvas canvas) {
        super.onDraw(canvas);
        if (mScanFlag) {
            canvas.save();
            mScanShader = new SweepGradient(centerX, centerY, mDefaultSharpColor, null);
            mPaintScan.setShader(mScanShader);
            canvas.concat(mScanMatrix);
            Path path = buildRing(360);
            canvas.drawPath(path, mPaintScan);
            canvas.restore();
            // draw center img
            drawCircleImg(canvas);
        }
        mIsOnSizeChanged = false;
    }

    /**
     * build ring
     *
     * @return ring path
     */
    private Path buildRing(float sweep) {
        if (!mIsOnSizeChanged) {
            if (null != mRingPath) {
                return mRingPath;
            }
        } else {
            mRingPath = null;
        }
        RectF bounds = new RectF();
        bounds.set(getLeft(), getTop(), getRight(), getBottom());
        float x = bounds.width() / 2.0f;
        float y = bounds.height() / 2.0f;
        float diagonal =
                (float) (Math.sqrt((double) (Math.pow(bounds.width(), 2d) + Math.pow(bounds.height(), 2d))) + 0.5);
        float thickness = diagonal - Math.min(bounds.width(), bounds.height());
        // inner radius, 30dp
        float radius = dipToPx(getContext(), 30);
        RectF innerBounds = new RectF(bounds);
        innerBounds.inset(x - radius, y - radius);
        bounds = new RectF(innerBounds);
        bounds.inset(-thickness, -thickness);
        if (mRingPath == null) {
            mRingPath = new Path();
        }
        final Path ringPath = mRingPath;
        // arcTo treats the sweep angle mod 360, so check for that, since we
        // think 360 means draw the entire oval
        if (sweep < 360 && sweep > -360) {
            ringPath.setFillType(Path.FillType.EVEN_ODD);
            // inner top
            ringPath.moveTo(x + radius, y);
            // outer top
            ringPath.lineTo(x + radius + thickness, y);
            // outer arc
            ringPath.arcTo(bounds, 0.0f, sweep, false);
            // inner arc
            ringPath.arcTo(innerBounds, sweep, -sweep, false);
            ringPath.close();
        } else {
            // add the entire ovals
            ringPath.addOval(bounds, Path.Direction.CW);
            ringPath.addOval(innerBounds, Path.Direction.CCW);
        }
        return ringPath;
    }

    /**
     * draw 中心蓝点图
     *
     * @param canvas 画布
     */
    private void drawCircleImg(Canvas canvas) {
        Bitmap centerPoint =
                ((BitmapDrawable) (mCenterPointIcon)).getBitmap();
        if (null == centerPoint) {
            return;
        }
        Rect src = new Rect(0, 0, centerPoint.getWidth(), centerPoint.getHeight());
        Rect dst =
                new Rect((getWidth() - centerPoint.getWidth()) / 2, (getHeight() - centerPoint.getHeight()) / 2,
                        (getWidth() + centerPoint.getWidth()) / 2, (getHeight() + centerPoint.getHeight()) / 2);
        canvas.drawBitmap(centerPoint, src, dst, null);
    }

    /**
     * 开始扫描
     */
    public void startScan() {
        mScanFlag = true;
        if (getVisibility() != View.VISIBLE) {
            setVisibility(View.VISIBLE);
            if (mThread == null || !mThread.isAlive()) {
                if (null != mRunnable) {
                    Thread localThread = new Thread(mRunnable);
                    this.mThread = localThread;
                    this.mThread.start();
                }
            }
        }
    }

    /**
     * 停止扫描并隐藏
     */
    public void dismissScan() {
        mScanFlag = false;
        mScanStart = 180;
        setVisibility(View.GONE);
        if (mThread != null) {
            mThread.interrupt();
            mThread = null;
        }
    }

    /**
     * 是否正在扫描
     *
     * @return
     */
    public boolean isScaning() {
        return mScanFlag;
    }

    /**
     * 增加旋转矩阵的旋转数值
     */
    public void increaseMatrixRotate() {
        mScanStart += 3;

        mScanMatrix = new Matrix();
        mScanMatrix.postRotate(mScanStart, centerX, centerY);
        postInvalidate();
    }

    /**
     * dp to px
     *
     * @param context Context
     * @param dip     dip
     *
     * @return int px
     */
    public static int dipToPx(Context context, float dip) {
        final float scale = context.getResources().getDisplayMetrics().density;
        return (int) (dip * scale + 0.5f);
    }
}
