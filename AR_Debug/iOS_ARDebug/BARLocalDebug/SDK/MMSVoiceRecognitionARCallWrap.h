//
//  MMSVoiceRecognitionARCallWrap.h
//  MISVoiceSearchLib
//
//  Created by yushichao on 2017/6/15.
//  Copyright © 2017年 yuanhanguang. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, MMSVoiceRecognitionErrorCode) {
    MMSVoiceRecognitionErrorCodeRecoderException = 101,                  // 录音设备异常
    MMSVoiceRecognitionErrorCodeRecoderUnAvailable = 102,                // 录音设备不可用
    MMSVoiceRecognitionErrorCodeRecoderNoPermission = 103,               // 无录音权限
    MMSVoiceRecognitionErrorCodeInterruption = 104,                      // 录音中断
    
    MMSVoiceRecognitionErrorCodeDecoderResolveUrlFailed = 201,           // 解析url失败
    MMSVoiceRecognitionErrorCodeLocalTimeout = 202,                      // 请求超时
    MMSVoiceRecognitionErrorCodeDecoderNetworkUnavailable = 203,         // 网络不可用
    MMSVoiceRecognitionErrorCodeDecoderTokenFailed = 204,                // 获取token失败
    
    MMSVoiceRecognitionErrorCodeNoSpeech = 301,                          // 用户未说话
    MMSVoiceRecognitionErrorCodeShort = 302,                             // 用户说话声音太短
    
    MMSVoiceRecognitionErrorCodeServerParamError = 401,                  // 协议参数错误
    MMSVoiceRecognitionErrorCodeServerRecognError = 402,                 // 识别过程出错
    MMSVoiceRecognitionErrorCodeServerSpeechTooLong = 403,               // 语音过长
    MMSVoiceRecognitionErrorCodeServerNoFindResult = 404,                // 没有找到匹配结果
    MMSVoiceRecognitionErrorCodeServerSpeechQualityProblem = 405,        // 声音不符合识别要求
    MMSVoiceRecognitionErrorCodeServerAppNameUnknownError = 406,         // AppnameUnkown错误
    
    MMSVoiceRecognitionErrorCodeVADException = 501,                      // 前端库异常
    MMSVoiceRecognitionErrorCodeCommonBusy = 502,                        // 识别器忙
    MMSVoiceRecognitionErrorCodeCommonEnqueueError = 503,                // 语音数据enqueue失败
    MMSVoiceRecognitionErrorCodeDecoderExceptioin = 504,                 // 在线识别引擎异常
    MMSVoiceRecognitionErrorCodeCommonPropertyListInvalid = 505,         // 垂类设置有误
    
    MMSVoiceRecognitionErrorCodeShortClick = 601,                        // 长按模式中发生短按
    MMSVoiceRecognitionErrorCodeTimeout = 602,                           // 8.5s超时
    MMSVoiceRecognitionErrorCodeNetworkUnavailable = 603,                // 网络不可用
    MMSVoiceRecognitionErrorCodeMicrophoneNoPermission = 604,            // 麦克风不可用
    MMSVoiceRecognitionErrorCodeSDKParsingFailed = 608                   // SDK返回了结果，但结果解析失败
};

typedef NS_ENUM(NSInteger, MMSMicrophoneNoPermissionButtonClickType) {
    MMSMicrophoneNoPermissionButtonClickTypeDenied = 0,                 //系统弹窗，点击'拒绝'
    MMSMicrophoneNoPermissionButtonClickTypeGranted,                    //系统弹窗，点击'允许'
    MMSMicrophoneNoPermissionButtonClickTypeIKnow,                      //自定义弹窗，iOS8以下，点击'我知道了'
    MMSMicrophoneNoPermissionButtonClickTypeCancel,                     //自定义弹窗，iOS8以上，点击'取消'
    MMSMicrophoneNoPermissionButtonClickTypeSetting                     //自定义弹窗，iOS8以上，点击'设置'
};

@protocol MMSVoiceRecognitionARCallWrapDelegate <NSObject>


/**
 *  初始化语音识别中
 */
- (void)voiceRecognitionClientStartInitialize;

/**
 *  开始录音
 */
- (void)voiceRecognitionClientStartRecord;

/**
 *  语音识别过程中结果返回
 *
 *  @param certainString        语音识别中返回的 置信结果
 *  @param unCertainString      语音识别中返回的 非置信结果
 */
- (void)voiceRecognitionClientFlushDataWithCertainString:(NSString *)certainString unCertainString:(NSString *)unCertainString;

/**
 *  实时音量
 *
 *  @param volume   音量 0~100
 */
- (void)voiceRecognitionClientVolume:(NSInteger)volume;

/**
 *  实时录音数据
 *
 *  @param data     录音数据
 */
- (void)voiceRecognitionClientRecordData:(NSData *)data;

/**
 *  录音停止
 */
- (void)voiceRecognitionClientStopRecord;

/**
 *  识别结果
 *
 *  @param word     识别结果
 */
- (void)voiceRecognitionClientRecognitionFinishedWithWord:(NSString *)word;

/**
 *  识别取消
 */
- (void)voiceRecognitionClientCanceled;

/**
 *  错误回调
 *
 *  @param errorCode   错误码，详见MMSVoiceRecognitionErrorCode
 */
- (void)voiceRecognitionClientErrorWithCode:(MMSVoiceRecognitionErrorCode)errorCode;

/**
 *  麦克风无权限弹窗点击回调
 *
 *  @param type   点击button类型 详见MMSMicrophoneNoPermissionButtonClickType
 */
- (void)microphonePermissionWindowCallback:(MMSMicrophoneNoPermissionButtonClickType)type;

@end

@interface MMSVoiceRecognitionARCallWrap : NSObject

@property (nonatomic,weak) id<MMSVoiceRecognitionARCallWrapDelegate> delegate;

/**
 *  开始语音识别
 *
 *  @param args   配置参数 
 *  例：args=source_app%3Dbaiduboxapp%26referer%3DARCall%26voiceSource%3DARCall%26show_voiceUI%3D0%26shouleListenVolume%3D1
 */
- (void)startRecognitionWithArgs:(NSString *)args;

/**
 *  完成语音识别
 */
- (void)finishRecognition;

/**
 *  取消语音识别
 */
- (void)cancelRecognition;

@end
