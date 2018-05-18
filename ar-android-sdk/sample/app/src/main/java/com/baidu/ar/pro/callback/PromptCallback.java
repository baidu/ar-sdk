package com.baidu.ar.pro.callback;

/**
 * Created by xiegaoxi on 2018/5/10.
 */

public interface PromptCallback {

    /**
     * 设置闪光灯状态
     *
     * @param open
     */
    void onCameraFlashStatus(boolean open);

    /**
     * 摄像头前后切换
     */
    void onSwitchCamera();

    /**
     * 退出ar
     */
    void onBackPressed();

    /**
     * 切换case
     *
     * @param key
     */
    void onChangeCase(String key);
}
