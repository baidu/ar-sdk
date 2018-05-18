/*
 * Copyright (C) 2017 Baidu, Inc. All Rights Reserved.
 */
package com.baidu.ar.camera;

import java.util.Collections;
import java.util.List;

import android.content.Context;
import android.content.pm.PackageManager;
import android.graphics.ImageFormat;
import android.hardware.Camera;
import android.os.Build;

/**
 * Created by huxiaowen on 2017/3/23.
 */

public class CameraHelper {
    private static final String TAG = CameraHelper.class.getSimpleName();

    public static final int GET_CAMERA_ID_ERROR = -1;

    public static int getBackCameraId() {
        int cameraId = Camera.CameraInfo.CAMERA_FACING_BACK;
        if (isCameraSupported(cameraId)) {
            return cameraId;
        }
        return GET_CAMERA_ID_ERROR;
    }

    public static int getFrontCameraId() {
        int cameraId = Camera.CameraInfo.CAMERA_FACING_FRONT;
        if (isCameraSupported(cameraId)) {
            return cameraId;
        }
        return GET_CAMERA_ID_ERROR;
    }

    public static final boolean isBackCameraCurrent() {
        Camera.CameraInfo cameraInfo = new Camera.CameraInfo();
        if (cameraInfo.facing == Camera.CameraInfo.CAMERA_FACING_BACK) {
            return true;
        } else {
            return false;
        }
    }

    public static boolean isCameraSupported(int cameraIndex) {
        Camera.CameraInfo cameraInfo = new Camera.CameraInfo();
        int cameraCount = Camera.getNumberOfCameras();
        for (int i = 0; i < cameraCount; i++) {
            Camera.getCameraInfo(i, cameraInfo);
            if (cameraInfo.facing == cameraIndex) {
                return true;
            }
        }
        return false;
    }

    public static boolean isCameraPreviewSupported(CameraParams cameraParams) {
        if (isCameraSupported(cameraParams.getCameraId())) {
            boolean result = false;
            Camera camera = null;
            try {
                camera = Camera.open(cameraParams.getCameraId());
                Camera.Parameters parameters = camera.getParameters();    // 针对魅族手机
                List<Camera.Size> previewSizes = parameters.getSupportedPreviewSizes();
                for (Camera.Size size : previewSizes) {
                    if (size.width == cameraParams.getPreviewWidth()
                            && size.height == cameraParams.getPreviewHeight()) {
                        result = true;
                        break;
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
            if (camera != null) {
                try {
                    camera.release();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
            return result;
        }
        return false;
    }

    // 检测并修正camera参数
    public static void correctCameraParams(CameraParams cameraParams, Camera.Parameters parameters) {
        Camera.Size optimalPreviewSize =
                getOptimalPreviewSize(parameters, cameraParams.getPreviewWidth(), cameraParams.getPreviewHeight(),
                        cameraParams.isKeepAspectRatio(), cameraParams.getAspectTolerance(),
                        cameraParams.isPreviewCorrectUpward());
        if (optimalPreviewSize != null) {
            cameraParams.setPreviewWidth(optimalPreviewSize.width);
            cameraParams.setPreviewHeight(optimalPreviewSize.height);
        }

        Camera.Size optimalPictureSize =
                getOptimalPictureSize(parameters, cameraParams.getPictureWidth(), cameraParams.getPictureHeight(),
                        cameraParams.isKeepAspectRatio(), cameraParams.getAspectTolerance(),
                        cameraParams.isPictureCorrectUpward());
        if (optimalPreviewSize != null) {
            cameraParams.setPictureWidth(optimalPictureSize.width);
            cameraParams.setPictureHeight(optimalPictureSize.height);
        }

        int optimalPreviewFrameRate = getOptimalPreviewFrameRate(parameters, cameraParams.getFrameRate(),
                cameraParams.isFrameRateCorrectUpward());

        // 获取设备支持的预览format
        List<Integer> formatsList = parameters.getSupportedPreviewFormats();
        if (formatsList.contains(ImageFormat.NV21)) {
            // 设置预览格式为NV21，默认为NV21
            parameters.setPreviewFormat(ImageFormat.NV21);
        }

        cameraParams.setFrameRate(optimalPreviewFrameRate);
    }

    private static Camera.Size getOptimalPreviewSize(Camera.Parameters parameters, int previewWidth, int previewHeight,
                                                     boolean keepAspectRatio, double aspectTolerance,
                                                     boolean correctUpward) {
        if (parameters == null) {
            return null;
        }

        List<Camera.Size> previewSizes = parameters.getSupportedPreviewSizes();
        if (previewSizes == null) {
            return null;
        }

        Camera.Size optimalSize =
                getOptimalSize(previewSizes, previewWidth, previewHeight, keepAspectRatio, aspectTolerance,
                        correctUpward);
        if (optimalSize == null) {
            optimalSize = getOptimalSize(previewSizes, previewWidth, previewHeight, keepAspectRatio, aspectTolerance,
                    !correctUpward);
        }

        return optimalSize;
    }

    private static Camera.Size getOptimalPictureSize(Camera.Parameters parameters, int pictureWidth, int pictureHeight,
                                                     boolean keepAspectRatio, double aspectTolerance,
                                                     boolean correctUpward) {
        if (parameters == null) {
            return null;
        }

        List<Camera.Size> pictureSizes = parameters.getSupportedPictureSizes();
        if (pictureSizes == null) {
            return null;
        }

        Camera.Size optimalSize =
                getOptimalSize(pictureSizes, pictureWidth, pictureHeight, keepAspectRatio, aspectTolerance,
                        correctUpward);
        if (optimalSize == null) {
            optimalSize = getOptimalSize(pictureSizes, pictureWidth, pictureHeight, keepAspectRatio, aspectTolerance,
                    !correctUpward);
        }

        return optimalSize;
    }

    private static Camera.Size getOptimalSize(List<Camera.Size> sizes, int targetWidth, int targetHeight,
                                              boolean keepAspectRatio, double aspectTolerance,
                                              boolean correctUpward) {
        double targetRatio = (double) targetWidth / targetHeight;
        Camera.Size optimalSize = null;
        // Try to find an size match aspect ratio and size
        Collections.sort(sizes, new CameraSizeComparator(correctUpward));
        for (Camera.Size size : sizes) {
            if (correctUpward) {
                if (size.width < targetWidth) {
                    continue;
                }
            } else {
                if (size.width > targetWidth) {
                    continue;
                }
            }
            if (keepAspectRatio) {
                double ratio = (double) size.width / size.height;
                if (Math.abs(ratio - targetRatio) > aspectTolerance) {
                    continue;
                }
            }
            optimalSize = size;
            break;
        }
        return optimalSize;
    }

    private static int getOptimalPreviewFrameRate(Camera.Parameters parameters, int targetFrameRate,
                                                  boolean correctUpward) {
        List<Integer> rates = parameters.getSupportedPreviewFrameRates();
        if (rates == null) {
            return targetFrameRate;
        }
        int optimalFrameRate = getOptimalRate(rates, targetFrameRate, correctUpward);
        if (optimalFrameRate == 0) {
            optimalFrameRate = getOptimalRate(rates, targetFrameRate, !correctUpward);
        }
        return optimalFrameRate;
    }

    private static int getOptimalRate(List<Integer> rates, int targetFrameRate, boolean correctUpward) {
        if (rates.contains(targetFrameRate)) {
            return targetFrameRate;
        } else {
            Collections.sort(rates);
            if (!correctUpward) {
                Collections.reverse(rates);
            }
            int optimalFrameRate = 0;
            for (Integer rate : rates) {
                if (correctUpward) {
                    if (rate < targetFrameRate) {
                        continue;
                    }
                } else {
                    if (rate > targetFrameRate) {
                        continue;
                    }
                }
                optimalFrameRate = rate;
            }
            return optimalFrameRate;
        }
    }

    public static void setAutoFocus(Camera.Parameters parameters) {
        List<String> supportFocusModes = parameters.getSupportedFocusModes();
        if (supportFocusModes.contains(Camera.Parameters.FOCUS_MODE_CONTINUOUS_VIDEO)) {
            parameters.setFocusMode(Camera.Parameters.FOCUS_MODE_CONTINUOUS_VIDEO);
        } else if (supportFocusModes.contains(Camera.Parameters.FOCUS_MODE_CONTINUOUS_PICTURE)) {
            parameters.setFocusMode(Camera.Parameters.FOCUS_MODE_CONTINUOUS_PICTURE);
        } else if (supportFocusModes.contains(Camera.Parameters.FOCUS_MODE_AUTO)) {
            parameters.setFocusMode(Camera.Parameters.FOCUS_MODE_AUTO);
        }
    }

    public static boolean checkCameraPermission(Context context) {
        String packageName = context.getApplicationContext().getPackageName();
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            return checkPermissionOverVersionM(context, packageName);
        } else {
            return checkPermissionUnderVersionM();
        }
    }

    private static boolean checkPermissionOverVersionM(Context context, String packageName) {
        PackageManager packageManager = context.getPackageManager();
        int permission = packageManager.checkPermission("android.permission.CAMERA", packageName);
        if (PackageManager.PERMISSION_GRANTED == permission) {
            return true;
        } else {
            return false;
        }
    }

    private static boolean checkPermissionUnderVersionM() {
        boolean hasPermission = true;
        Camera camera = null;
        try {
            camera = Camera.open();
            Camera.Parameters parameters = camera.getParameters();    // 针对魅族手机
            camera.setParameters(parameters);
        } catch (Exception e) {
            hasPermission = false;
            e.printStackTrace();
        }

        if (camera != null) {
            try {
                camera.release();
            } catch (Exception e) {
                e.printStackTrace();
                return hasPermission;
            }
        }
        return hasPermission;
    }
}
