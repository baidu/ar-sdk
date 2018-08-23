package com.baidu.ar.logo;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.lang.ref.WeakReference;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.baidu.ar.bean.ARConfig;
import com.baidu.ar.bean.DuMixARConfig;
import com.baidu.ar.constants.HttpConstants;
import com.baidu.ar.util.FileUtils;
import com.baidu.ar.util.IoUtils;
import com.baidu.ar.util.UrlUtils;
import com.baidu.ar.util.Utils;

import android.content.Context;
import android.graphics.Bitmap;
import android.net.Uri;
import android.text.TextUtils;
import android.util.Base64;
import android.util.Log;

/**
 * Created by baidu on 2017/8/2.
 */

public class IttRecognitionManager {
    private static final String TAG = IttRecognitionManager.class.getSimpleName();

    private List<LogoModel> mRecognitionRes = new ArrayList<>();

    private List<String> mIconList = new ArrayList<>();

    private static volatile IttRecognitionManager sInstance;

    public static IttRecognitionManager getInstance() {
        if (sInstance == null) {
            synchronized (IttRecognitionManager.class) {
                if (sInstance == null) {
                    sInstance = new IttRecognitionManager();
                }
            }
        }
        return sInstance;
    }

    public void releaseInstance() {
        sInstance = null;
        IttSearchController.getInstance().releaseInstance();
    }

    private IttRecognitionManager() {
    }

    public void parseRecognition(String jsonStr) {
        mIconList.clear();
        mRecognitionRes.clear();
        if (!TextUtils.isEmpty(jsonStr) && new File(jsonStr).exists()) {
            try {
                JSONObject jsonObject = new JSONObject(FileUtils.readFileText(jsonStr));
                if (jsonObject.has("logo")) {
                    JSONObject logoJsonObject = jsonObject.getJSONObject("logo");
                    Iterator iterator = logoJsonObject.keys();
                    while (iterator.hasNext()) {
                        String key = (String) iterator.next();
                        JSONArray keyArray = null;
                        try {
                            keyArray = new JSONArray(logoJsonObject.getString(key));
                            for (int i = 0; i < keyArray.length(); i++) {
                                String str = keyArray.getString(i);
                                LogoModel logoModel = new LogoModel();
                                logoModel.setHeadName(key);
                                logoModel.setMatchKeyName(str);
                                mRecognitionRes.add(logoModel);
                            }

                        } catch (JSONException e) {
                            e.printStackTrace();
                        }
                    }
                }

            } catch (JSONException e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * 初始化图像识别模块
     *
     * @param context  上下文
     * @param callback 图像识别callback
     */
    public void initCloudRecognition(Context context, IttRecognitionCallback callback) {
        IttSearchController.getInstance().setIttRecognitionCallback(callback);
    }

    public LogoModel matchLogoKey(List<RecognitionRes> recognitionRes) {
        if (recognitionRes.size() > 0 && mRecognitionRes.size() > 0) {
            if (recognitionRes.size() > 0) {
                for (RecognitionRes res : recognitionRes) {
                    for (LogoModel model : mRecognitionRes) {
                        String recgName = res.getName();
                        if (recgName.startsWith(model.getMatchKeyName()) || recgName.contains(model.getMatchKeyName())
                                || recgName.endsWith(model.getMatchKeyName())) {
                            return model;
                        }
                    }
                }
            }
        }

        return null;
    }

    public void setYUVFile(byte[] yuvdata, int pWidth, int pHeight) {
        if (yuvdata == null) {
            return;
        }

        WeakReference<byte[]> yuvDatas = new WeakReference<byte[]>(yuvdata);
        WeakReference<Bitmap> bitmap = null;
        ByteArrayOutputStream baos = null;
        WeakReference<int[]> rgbBuf = null;

        try {
            int resizeWidth = (pWidth / 2);
            int resizeHeith = (pHeight / 2);
            byte[] originaluvDatas = Utils.cropYuv(yuvDatas.get(), resizeWidth, resizeHeith, yuvdata,
                    pWidth, pHeight);

            int[] originalRgbBuf = new int[resizeWidth * resizeHeith];
            rgbBuf = new WeakReference<int[]>(originalRgbBuf);
            Utils.decodeYUV420SP(rgbBuf.get(), originaluvDatas, pWidth, pHeight);

            Bitmap originalBitmap =
                    Bitmap.createBitmap(rgbBuf.get(), resizeWidth, resizeHeith, Bitmap.Config.ARGB_8888);

            bitmap = new WeakReference<Bitmap>(originalBitmap);
            baos = new ByteArrayOutputStream();
            if (bitmap.get() != null) {
                bitmap.get().compress(Bitmap.CompressFormat.JPEG, 100, baos);
            }

            byte[] bytes = baos.toByteArray();
            HashMap<String, String> params = new HashMap<>();
            params.put("image", Uri.encode(Base64.encodeToString(bytes, Base64.NO_PADDING)));
            params.put(HttpConstants.AIP_APP_ID, DuMixARConfig.getAipAppId());
            params.put(HttpConstants.IS_AIP, ARConfig.getIsAip());
            params.put(HttpConstants.SIGN, ARConfig.getSignature());
            params.put(HttpConstants.TIMESTAMP, String.valueOf(ARConfig.getTimestamp()));
            params.put(HttpConstants.CUID, ARConfig.getCUID());
            IttSearchController.getInstance().requestResource(UrlUtils.getLogoUrl(), params, bytes);
        } catch (Exception e) {
            e.printStackTrace();
            Log.d(TAG, e.getMessage());
        } finally {
            if (bitmap.get() != null) {
                bitmap.get().recycle();
                bitmap.clear();
            }
            yuvDatas.clear();
            rgbBuf.clear();

            yuvDatas = null;
            IoUtils.closeQuietly(baos);
        }
    }

}
