package com.baidu.ar.pro.draw;

import javax.microedition.khronos.egl.EGLConfig;
import javax.microedition.khronos.opengles.GL10;

import com.baidu.ar.pro.draw.ARDrawer;
import com.baidu.ar.pro.draw.ARRenderCallback;
import com.baidu.ar.statistic.StatisticConstants;
import com.baidu.ar.statistic.StatisticHelper;

import android.graphics.SurfaceTexture;
import android.opengl.GLES10;
import android.opengl.GLES20;
import android.opengl.GLSurfaceView;
import android.util.Log;

/**
 * Created by huxiaowen on 2017/12/7.
 */

public class ARRenderer implements GLSurfaceView.Renderer {
    private static final String TAG = ARRenderer.class.getSimpleName();
    private ARDrawer mCameraDrawer;
    private SurfaceTexture mCameraTexture;
    private int mCameraTextureID;
    private int mCameraWidth;
    private int mCameraHeight;
    private SurfaceTexture.OnFrameAvailableListener mCameraFrameListener;

    private ARDrawer mARDrawer;
    private SurfaceTexture mARTexture;
    private int mARTextureID;
    private int mARWidth;
    private int mARHeight;
    private ARRenderCallback mARRenderCallback;
    private SurfaceTexture.OnFrameAvailableListener mARFrameListener;

    private volatile boolean mDrawAR = true;
    // 是否是横屏模式
    private boolean mScreenLandscape;

    public ARRenderer(boolean landscape) {

        mScreenLandscape = landscape;
        if (mCameraTexture == null) {
            int mCameraTextureID = createTexture(GLES10.GL_TEXTURE_2D);
            mCameraTexture = new SurfaceTexture(mCameraTextureID);
        }
        if (mARTexture == null) {
            int mARTextureID = createTexture(GLES10.GL_TEXTURE_2D);
            mARTexture = new SurfaceTexture(mARTextureID);
        }
    }

    public SurfaceTexture getCameraTexture() {
        return mCameraTexture;
    }

    public void setDrawAR(boolean drawAR) {
        mDrawAR = drawAR;
        mDrawerChanged = true;
    }

    private boolean mDrawerChanged = false;

    //    public void setCameraRenderCallback(CameraRenderCallback callback) {
    //        mCameraRenderCallback = callback;
    //    }

    public void setCameraFrameListener(SurfaceTexture.OnFrameAvailableListener listener) {
        mCameraFrameListener = listener;
        setCameraFrameListener();
    }

    private void setCameraFrameListener() {
        if (mCameraTexture != null && mCameraFrameListener != null) {
            mCameraTexture.setOnFrameAvailableListener(mCameraFrameListener);
        }
    }

    public void setARRenderCallback(ARRenderCallback callback) {
        mARRenderCallback = callback;
        if (mARRenderCallback != null) {
            mARRenderCallback.onCameraDrawerCreated(mCameraTexture, 1280, 720);
        }
        if (mARRenderCallback != null) {
            mARRenderCallback.onARDrawerCreated(mARTexture, mARFrameListener, mARWidth, mARHeight);
        }
    }

    public void setARFrameListener(SurfaceTexture.OnFrameAvailableListener listener) {
        // 这里仅把listener设置进来，在pro内设置给对应的Target SurfaceTexture
        mARFrameListener = listener;
    }

    @Override
    public void onSurfaceCreated(GL10 gl, EGLConfig config) {
        mCameraTextureID = createTexture(GLES10.GL_TEXTURE_2D);
        mARTextureID = createTexture(GLES10.GL_TEXTURE_2D);
    }

    @Override
    public void onSurfaceChanged(GL10 gl, int width, int height) {
        GLES20.glViewport(0, 0, width, height);

        mARWidth = width;
        mARHeight = height;

        if (mCameraDrawer == null) {
            mCameraDrawer = new ARDrawer(mCameraTextureID, GLES10.GL_TEXTURE_2D, mScreenLandscape);
        }

        if (mARDrawer == null) {
            mARDrawer = new ARDrawer(mARTextureID, GLES10.GL_TEXTURE_2D, mScreenLandscape);
            // if (mARRenderCallback != null) {
            // mARRenderCallback.onARDrawerCreated(mARTexture, width, height);
            // }
        }

        if (mARRenderCallback != null) {
            mARRenderCallback.onARDrawerChanged(mARTexture, mARWidth, mARHeight);
        }
    }

    @Override
    public void onDrawFrame(GL10 gl) {
        updateDrawer();
        if (StatisticConstants.getIsRenderModel()) {
            StatisticHelper.getInstance().statisticFrameRate(StatisticConstants.VIEW_RENDER_FRAME_TIME);
        }

        GLES20.glClearColor(1.0f, 1.0f, 1.0f, 1.0f);
        GLES20.glClear(GLES20.GL_COLOR_BUFFER_BIT | GLES20.GL_DEPTH_BUFFER_BIT);

        try {
            if (mDrawAR) {
                if (mARTexture != null) {
                    Log.d(TAG, "mARTexture.updateTexImage(); ");
                    mARTexture.updateTexImage();
                    float[] mtx = new float[16];
                    mARTexture.getTransformMatrix(mtx);
                    mARDrawer.draw(mtx);
                }
            } else {
                if (mCameraTexture != null) {
                    mCameraTexture.updateTexImage();
                    float[] mtx = new float[16];
                    mCameraTexture.getTransformMatrix(mtx);
                    mCameraDrawer.draw(mtx);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void updateDrawer() {
        if (mDrawerChanged) {
            try {
                mARTexture.detachFromGLContext();
            } catch (Exception e) {
                Log.e(TAG, "onSurfaceChanged attachToGLContext error!!!");
                e.printStackTrace();
            }
            try {
                mCameraTexture.detachFromGLContext();
            } catch (Exception e) {
                Log.e(TAG, "onSurfaceChanged attachToGLContext error!!!");
                e.printStackTrace();
            }
            try {
                if (mDrawAR) {
                    mARTexture.attachToGLContext(mARTextureID);
                } else {
                    mCameraTexture.attachToGLContext(mCameraTextureID);
                }
            } catch (Exception e) {
                Log.e(TAG, "onSurfaceChanged attachToGLContext error!!!");
                e.printStackTrace();
            }
            mDrawerChanged = false;
        }
    }

    public void release() {
        if (mARDrawer != null) {
            mARDrawer = null;
        }
        if (mARTexture != null) {
            mARTexture.release();
            mARTexture = null;
        }
        mARRenderCallback = null;
    }

    /**
     * 生成TextureID
     *
     * @param textureTarget
     *
     * @return
     */
    private int createTexture(int textureTarget) {
        int[] texture = new int[1];

        GLES20.glGenTextures(1, texture, 0);
        GLES20.glBindTexture(textureTarget, texture[0]);
        GLES20.glTexParameterf(textureTarget, GL10.GL_TEXTURE_MIN_FILTER, GL10.GL_LINEAR);
        GLES20.glTexParameterf(textureTarget, GL10.GL_TEXTURE_MAG_FILTER, GL10.GL_LINEAR);
        GLES20.glTexParameteri(textureTarget, GL10.GL_TEXTURE_WRAP_S, GL10.GL_CLAMP_TO_EDGE);
        GLES20.glTexParameteri(textureTarget, GL10.GL_TEXTURE_WRAP_T, GL10.GL_CLAMP_TO_EDGE);

        return texture[0];
    }
}
