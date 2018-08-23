package com.baidu.ar.logo;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.baidu.ar.util.HttpUtils;

import android.os.Handler;
import android.os.HandlerThread;
import android.os.Looper;
import android.os.Message;
import android.text.TextUtils;

/**
 * Created by baidu on 2017/8/2.
 */

public class IttSearchController implements CommonHandlerListener {
    private static volatile IttSearchController sInstance;
    private static final String CLOUD_SEARCH_THREAD_NAME = "CloudSearchThread";

    private HandlerThread mSearchThread;
    private Handler mSearchHandler;

    private IttRecognitionCallback logoRecognitionCallback;

    public static IttSearchController getInstance() {
        if (sInstance == null) {
            synchronized (IttSearchController.class) {
                if (sInstance == null) {
                    sInstance = new IttSearchController();
                }
            }
        }
        return sInstance;
    }

    public void releaseInstance() {
        sInstance = null;
        logoRecognitionCallback = null;
    }

    public void setIttRecognitionCallback(IttRecognitionCallback logoRecognitionCallback) {
        this.logoRecognitionCallback = logoRecognitionCallback;
    }

    private IttSearchController() {
        initCameraController();
    }

    private void initCameraController() {
        if (!isRunning()) {
            mSearchThread = new HandlerThread(CLOUD_SEARCH_THREAD_NAME);
            mSearchThread.start();
            mSearchHandler = new CloudSearchHandler(mSearchThread.getLooper(), this);
        }
    }

    @Override
    public void handleMessage(Message msg) {
        switch (msg.what) {
            case CloudSearchHandler.MSG_REQUEST_FEATURE_RESOURCE:
                RequestModel requestModel = (RequestModel) msg.obj;
                handleRequestResource(requestModel.mUrl, requestModel.mParamsMap, requestModel.yuvData);
                break;
            default:
                break;
        }
    }

    public void requestResource(String url, HashMap<String, String> params, byte[] yuv) {
        if (mSearchHandler != null) {
            mSearchHandler.removeMessages(CloudSearchHandler.MSG_QUIT);
            RequestModel requestModel = new RequestModel(url, params, yuv);
            mSearchHandler.sendMessage(
                    mSearchHandler.obtainMessage(CloudSearchHandler.MSG_REQUEST_FEATURE_RESOURCE, requestModel));
        }
    }

    private void handleRequestResource(String url, HashMap<String, String> mParamsMap, byte[] yuvData) {
        StringBuilder stringBuilder = new StringBuilder();
        if (mParamsMap != null) {
            Iterator iter = mParamsMap.entrySet().iterator();
            while (iter.hasNext()) {
                Map.Entry entry = (Map.Entry) iter.next();
                stringBuilder.append(entry.getKey());
                stringBuilder.append("=");
                stringBuilder.append(entry.getValue());
                stringBuilder.append("&");
            }
            stringBuilder.deleteCharAt(stringBuilder.lastIndexOf("&"));
        }
        String jsonString = HttpUtils.post(url, stringBuilder.toString());
        IttResResponse feaResResponse = new IttResResponse();

        List<RecognitionRes> recognitionRes = new ArrayList<>();
        int errorNum = -1;
        try {
            JSONObject jsonObject = new JSONObject(jsonString);
            errorNum = jsonObject.getInt("errorNum");
            feaResResponse.setSuccess(errorNum == 0);
            feaResResponse.setMessage(jsonObject.getString("errorMsg"));
            if (jsonObject.has("data") && !TextUtils.isEmpty(jsonObject.get("data").toString())) {
                RecognitionRes recognitionRes1 = new RecognitionRes();
                JSONArray feaResJsonObjectArray = jsonObject.getJSONArray("data");
                for (int i = 0; i < feaResJsonObjectArray.length(); i++) {
                    JSONObject jsonObject1 = feaResJsonObjectArray.getJSONObject(i);
                    recognitionRes1.setName(jsonObject1.getString("name"));
                    recognitionRes1.setCode(jsonObject1.getString("code"));
                    recognitionRes1.setType(jsonObject1.getInt("type"));
                    recognitionRes1.setProbability(jsonObject1.getDouble("probability"));
                    if (jsonObject1.has("location")) {
                        JSONObject subJsonObject = jsonObject1.getJSONObject("location");
                        ImageLocation imageLocation = new ImageLocation();
                        imageLocation.setHeight(subJsonObject.getInt("height"));
                        imageLocation.setTop(subJsonObject.getInt("top"));
                        imageLocation.setLeft(subJsonObject.getInt("left"));
                        imageLocation.setWidth(subJsonObject.getInt("width"));
                        recognitionRes1.setImageLocation(imageLocation);
                    }
                    recognitionRes.add(recognitionRes1);

                }
                if (logoRecognitionCallback != null) {
                    logoRecognitionCallback.recognition(recognitionRes);
                }
            } else {
                if (logoRecognitionCallback != null) {
                    logoRecognitionCallback.recognition(recognitionRes);
                }
            }
        } catch (JSONException e) {
            e.printStackTrace();
            if (logoRecognitionCallback != null) {
                logoRecognitionCallback.recognition(recognitionRes);
            }
        }
    }

    private static class CloudSearchHandler extends Handler {
        public static final int MSG_REQUEST_FEATURE_RESOURCE = 1001;
        public static final int MSG_QUIT = 1007;

        private CommonHandlerListener listener;

        public CloudSearchHandler(Looper looper, CommonHandlerListener listener) {
            super(looper);
            this.listener = listener;
        }

        @Override
        public void handleMessage(Message msg) {
            listener.handleMessage(msg);
        }
    }

    public boolean isRunning() {
        return mSearchThread != null && mSearchThread.isAlive();
    }

    private class RequestModel {
        String mUrl;
        HashMap<String, String> mParamsMap;
        byte[] yuvData;

        public RequestModel(String mUrl, HashMap<String, String> mParamsMap, byte[] yuvData) {
            this.mUrl = mUrl;
            this.mParamsMap = mParamsMap;
            this.yuvData = yuvData;
        }
    }
}

