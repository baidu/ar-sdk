/*
 * Copyright (C) 2017 Baidu, Inc. All Rights Reserved.
 */
package com.baidu.ar.camera;

import android.hardware.Camera;

/**
 * Created by huxiaowen on 2017/3/23.
 */

public class CameraParams {
    private static final int DEFAULT_CAMERA_INDEX = Camera.CameraInfo.CAMERA_FACING_BACK;
    private static final boolean DEFAULT_AUTO_CORRECT_PARAMS = true;
    private static final boolean DEFAULT_KEEP_ASPECT_RATIO = true;
    private static final double DEFAULT_ASPECT_TOLERANCE = 0.05;
    private static final int DEFAULT_PREVIEW_WIDTH = 1280;
    private static final int DEFAULT_PREVIEW_HEIGHT = 720;
    private static final boolean DEFAULT_PREVIEW_CORRECT_UPWARD = false;
    private static final int DEFAULT_PREVIEW_FRAME_RATE = 30;
    private static final boolean DEFAULT_FRAME_RATE_CORRECT_UPWARD = false;
    private static final boolean DEFAULT_AUTO_FOCUS = true;
    private static final int DEFAULT_ROTATE_DEGREE = 90;
    private static final int DEFAULT_PICTURE_WIDTH = 1280;
    private static final int DEFAULT_PICTURE_HEIGHT = 720;
    private static final boolean DEFAULT_PICTURE_CORRECT_UPWARD = true;

    private int mCameraId;

    /**
     * if camera device do not support the params requied, then correct the params auto
     */
    private boolean mAutoCorrectParams;
    /**
     * prerequisite： mAutoCorrectParams is true
     * if the correct the preview & picture size keep aspect ratio
     */
    private boolean mKeepAspectRatio;
    /**
     * prerequisite： mKeepAspectRatio is true
     * how much aspect tolerance can accept
     */
    private double mAspectTolerance;

    private int mPreviewWidth;
    private int mPreviewHeight;
    /**
     * prerequisite： mAutoCorrectParams is true
     * if this is true, correct the preview size upward first, then downward.
     * if this is false, correct the preview size downward first, then upward.
     */
    private boolean mPreviewCorrectUpward;
    private int mFrameRate;
    /**
     * prerequisite： mAutoCorrectParams is true
     * if this is true, correct the preview frame rate upward first, then downward.
     * if this is false, correct the preview frame rate downward first, then upward.
     */
    private boolean mFrameRateCorrectUpward;
    private boolean mAutoFocus;
    private int mRotateDegree;

    private int mPictureWidth;
    private int mPictureHeight;
    /**
     * prerequisite： mAutoCorrectParams is true
     * if this is true, correct the preview size upward first, then downward.
     * if this is false, correct the preview size downward first, then upward.
     */
    private boolean mPictureCorrectUpward;

    public CameraParams() {
        mCameraId = DEFAULT_CAMERA_INDEX;
        mAutoCorrectParams = DEFAULT_AUTO_CORRECT_PARAMS;
        mKeepAspectRatio = DEFAULT_KEEP_ASPECT_RATIO;
        mAspectTolerance = DEFAULT_ASPECT_TOLERANCE;
        mPreviewWidth = DEFAULT_PREVIEW_WIDTH;
        mPreviewHeight = DEFAULT_PREVIEW_HEIGHT;
        mPreviewCorrectUpward = DEFAULT_PREVIEW_CORRECT_UPWARD;
        mFrameRate = DEFAULT_PREVIEW_FRAME_RATE;
        mFrameRateCorrectUpward = DEFAULT_FRAME_RATE_CORRECT_UPWARD;
        mAutoFocus = DEFAULT_AUTO_FOCUS;
        mRotateDegree = DEFAULT_ROTATE_DEGREE;
        mPictureWidth = DEFAULT_PICTURE_WIDTH;
        mPictureHeight = DEFAULT_PICTURE_HEIGHT;
        mPictureCorrectUpward = DEFAULT_PICTURE_CORRECT_UPWARD;
    }

    public int getCameraId() {
        return mCameraId;
    }

    public void setCameraId(int cameraId) {
        this.mCameraId = cameraId;
    }

    public boolean isAutoCorrectParams() {
        return mAutoCorrectParams;
    }

    public void setAutoCorrectParams(boolean autoCorrectParams) {
        this.mAutoCorrectParams = autoCorrectParams;
    }

    public boolean isKeepAspectRatio() {
        return mKeepAspectRatio;
    }

    public void setKeepAspectRatio(boolean keepAspectRatio) {
        this.mKeepAspectRatio = keepAspectRatio;
    }

    public double getAspectTolerance() {
        return mAspectTolerance;
    }

    public void setAspectTolerance(double aspectTolerance) {
        this.mAspectTolerance = aspectTolerance;
    }

    public int getPreviewWidth() {
        return mPreviewWidth;
    }

    public void setPreviewWidth(int previewWidth) {
        this.mPreviewWidth = previewWidth;
    }

    public int getPreviewHeight() {
        return mPreviewHeight;
    }

    public void setPreviewHeight(int previewHeight) {
        this.mPreviewHeight = previewHeight;
    }

    public boolean isPreviewCorrectUpward() {
        return mPreviewCorrectUpward;
    }

    public void setPreviewCorrectUpward(boolean previewCorrectUpward) {
        this.mPreviewCorrectUpward = previewCorrectUpward;
    }

    public int getFrameRate() {
        return mFrameRate;
    }

    public void setFrameRate(int frameRate) {
        this.mFrameRate = frameRate;
    }

    public boolean isFrameRateCorrectUpward() {
        return mFrameRateCorrectUpward;
    }

    public void setFrameRateCorrectUpward(boolean frameRateCorrectUpward) {
        this.mFrameRateCorrectUpward = frameRateCorrectUpward;
    }

    public boolean isAutoFocus() {
        return mAutoFocus;
    }

    public void setAutoFocus(boolean autoFocus) {
        this.mAutoFocus = autoFocus;
    }

    public int getRotateDegree() {
        return mRotateDegree;
    }

    public void setRotateDegree(int rotateDegree) {
        this.mRotateDegree = rotateDegree;
    }

    public int getPictureWidth() {
        return mPictureWidth;
    }

    public void setPictureWidth(int pictureWidth) {
        this.mPictureWidth = pictureWidth;
    }

    public int getPictureHeight() {
        return mPictureHeight;
    }

    public void setPictureHeight(int pictureHeight) {
        this.mPictureHeight = pictureHeight;
    }

    public boolean isPictureCorrectUpward() {
        return mPictureCorrectUpward;
    }

    public void setPictureCorrectUpward(boolean pictureCorrectUpward) {
        this.mPictureCorrectUpward = pictureCorrectUpward;
    }
}
