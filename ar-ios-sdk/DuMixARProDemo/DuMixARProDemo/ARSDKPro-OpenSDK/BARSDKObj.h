//
//  BARProSDKObj.h
//  ARSDK-Pro
//
//  Created by yijieYan on 2017/10/21.
//  Copyright © 2017年 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,BARSDKUIState) {
    BARSDKUIState_UnKnown = -1,
    BARSDKUIState_TrackOn,
    BARSDKUIState_TrackLost_HideModel,
    BARSDKUIState_TrackLost_ShowModel,
    BARSDKUIState_TrackTimeOut,
    BARSDKUIState_DistanceNormal,
    BARSDKUIState_DistanceTooFar,
    BARSDKUIState_DistanceTooNear,
//    BARSDKUIState_StartScan,
//    BARSDKUIState_HideScan,
//    BARSDKUIState_TrackAlphaImageShow,
//    BARSDKUIState_TrackAlphaImageHide,
    BARSDKUIState_TipShow,
    BARSDKUIState_TipHide,
    BARSDKUIState_ShowRecordUI,
    BARSDKUIState_Enanle_Front_Camera,
    BARSDKUIState_Case_Initial_Click,
    BARSDKUIState_SetNativeUI_Visible,
    BARSDKUIState_Change_FrontBack_Camera,
    /*
      BARSDKUIState_Enanle_Front_Camera                   // 开启前置摄像头
     
      BARSDKUIState_Initial_Click                         // 引导页点击事件
      BARSDKUIState_View_Visible_Type                     // UI显示的类型
     */
};

typedef NS_ENUM(NSInteger,BARSDKShowAlertType) {
    BARSDKShowAlertType_UnKnown = -1,
    BARSDKShowAlertType_NetWrong,
    BARSDKShowAlertType_SDKVersionTooLow,
    BARSDKShowAlertType_Unsupport,
    BARSDKShowAlertType_ARError,
    BARSDKShowAlertType_BatchZipDownloadFail,
    BARSDKShowAlertType_ARError_OnlyNeedReturn,
    BARSDKShowAlertType_BARImageSearchError_NetWrong,               // 网络失败
    BARSDKShowAlertType_BARImageSearchError_DataWrong,              // 鉴权等
    BARSDKShowAlertType_BARImageSearchError_DownLoadFeaWrong,       // 下载特征库失败
    BARSDKShowAlertType_BARImageSearchError_ImageSearchTimeout,     // 识别超时
    BARSDKShowAlertType_BARLogoRecogError_NetWrong,                 // Logo识别网络失败
    BARSDKShowAlertType_LuaInvokeSDKAlert,                          // lua主动调起sdk的弹窗
    BARSDKShowAlertType_LuaInvokeSDKToast                           // lua主动调起sdk的toast

};

/*
typedef NS_ENUM(NSInteger,BARQueryAndDownLoadCaseState) {
    BARCaseStateUnKnown = -1,
    BARCaseStateQueryStart,
    BARCaseStateQueryCompleted,
    BARCaseStateDownloadStart,
    BARCaseStateDownloadComplete,
    BARCaseStateUnzipStart,
    BARCaseStateUnzipComplete,
};*/

typedef NS_ENUM(NSInteger,BARRenderState) {
    BARRenderStateUnKnown = -1,
    BARRenderStateNone,
    BARRenderStateActived,
    BARRenderStatePaused,
};

typedef NS_ENUM(NSInteger,BARSDKStateError) {
    BARSDKStateError_UnKnown = -1,
    BARSDKStateError_NetWrong,
    BARSDKStateError_SDKVersionTooLow,
    BARSDKStateError_Unsupport,
    BARSDKStateError_ARError,
};

typedef NS_ENUM(NSInteger,BARImageSearchError) {
    BARImageSearchError_UnKnown = -1,
    BARImageSearchError_NetWrong = -101,//网络失败
    BARImageSearchError_DataWrong = -102, //鉴权等
    BARImageSearchError_DownLoadFeaWrong = -103, //下载特征库失败
    BARImageSearchError_ImageSearchTimeout = -104, //识别超时
};

//语音识别UI
typedef NS_ENUM(NSInteger, BARVoiceUIState) {
    BARVoiceUIState_ShowLoading,
    BARVoiceUIState_StopLoading,
    BARVoiceUIState_ShowWave,
    BARVoiceUIState_StopWave,
    BARVoiceUIState_WaveChangeVolume,
    BARVoiceUIState_ShowTips,
    BARVoiceUIState_HideVoice
};

typedef void(^BARSDKUIStateEventBlock) (BARSDKUIState state,NSDictionary *info);

typedef void(^BARUpdateSLAMPos) (float* rtData);
typedef void(^BARUpdateIMUPos) (float* rtData);
typedef void(^BARUpdateTrackingPos) (float* rtData);
typedef void(^BARSetSLAMRelocationType) (NSInteger type);


@interface BARSDKDownLoadObj : NSObject
@property (nonatomic,copy)NSString *err_code;
@property (nonatomic,copy)NSString *err_msg;
@property (nonatomic,copy)NSString *help_url;
@property (nonatomic,assign)BARSDKStateError error_state;
@end

@interface BARSDKObj : NSObject

@end
