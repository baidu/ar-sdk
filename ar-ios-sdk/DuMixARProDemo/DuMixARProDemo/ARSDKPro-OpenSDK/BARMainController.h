//
//  BARMainController.h
//  AR-Base
//
//  Created by Asa on 2017/10/19.
//  Copyright © 2017年 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BARSDKPro.h"
#import "BARSDKObj.h"
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import "BARImageView.h"


typedef enum : NSUInteger {
    BAROutputBlend = 0,
    BAROutputVideo,
    BAROutputEngine,
} BAROutput;


@protocol AREngineScriptPreferenceDelegate;

#pragma mark - Block

typedef void (^BARDownloadARCaseProgressBlock)(float progress);//下载过程回调
typedef void (^BARVoiceIconChangedBlock)(BOOL showVoiceTip);
typedef void (^BARDownloadARCaseCompleteBlock)(BOOL success,NSString * arKey,NSString * arType,NSString * filePath, id result);//下载完成回调
typedef void (^BARUIDeviceOrientationDidChangeBlock)(UIDeviceOrientation orientation);
typedef void (^BARCloseEventBlock)(void);
typedef void (^BARTakePictureFinishBlock)(UIImage *image);
typedef void (^BAROpenURLBlock)(NSDictionary *dic);
typedef void (^BARARKitRestartBlock)(void);

typedef void (^BARShowAlertEventBlock)(BARSDKShowAlertType type,dispatch_block_t cancelBlock,dispatch_block_t ensureBlock,NSMutableDictionary *info);

typedef void(^BARActivityBlock)(NSDictionary *dic);
//typedef void(^BARVersionTooLowBlock)(NSDictionary *dic);
typedef void(^BARAPaddleGestureOpenCloseBlock)(NSDictionary *dic, NSString *resPath);
typedef void(^BARLogoRecogChangedBlock)(BOOL show);

@interface BARMainController : NSObject
@property (nonatomic, copy) BARVoiceIconChangedBlock aRVoiceIconChangedBlock;
@property (nonatomic ,copy) BARUIDeviceOrientationDidChangeBlock arOrientationDidChangeBlock;
@property (nonatomic, copy) BARSDKUIStateEventBlock uiStateChangeBlock;
@property (nonatomic, copy) BAROpenURLBlock openURLBlock;
@property (nonatomic ,copy) BARShowAlertEventBlock showAlertEventBlock;
@property (nonatomic, copy) BARCloseEventBlock closeEventBlock;
@property (nonatomic, copy) dispatch_block_t queryArResourceSuccessBlock;
@property (nonatomic, copy) BARActivityBlock activityBlock;
@property (nonatomic, copy) BARAPaddleGestureOpenCloseBlock paddleGestureOpenCloseBlock;
@property (nonatomic, copy) BARARKitRestartBlock arkitRestartBlock;
@property (nonatomic, assign) BOOL isOpenPlaceStatus;
@property (nonatomic, copy) BARLogoRecogChangedBlock logoRecogChangedBlock;

//@property (nonatomic, copy) BARUpdateSLAMPos updateSLAMPosEventBlock;
//@property (nonatomic, copy) BARUpdateIMUPos updateIMUPosEventBlock;
//@property (nonatomic, copy) BARUpdateTrackingPos updateTrackingPosEventBlock;
//@property (nonatomic, copy) BARSetSLAMRelocationType setSLAMRelocationTypeEventBlock;
//typedef void (^BARSwitchARCaseStateBlock)(BARCaseState state);//case状态回调\
//@property (nonatomic, copy) BARLUAConfigBlock arLuaConfigBlock;
#pragma mark - public - method


/**
 初始化方法

 @param cameraSize 相机尺寸
 @param previewSize 预览尺寸
 @return BARMainController实例

 */
- (id)initARWithCameraSize:(CGSize )cameraSize previewSize:(CGSize)previewSize;


/**
 改变帧率

 @param frameRate 帧率
 */
- (void)changeFrameRate:(NSInteger)frameRate;

/**
 下载AR资源包

 @param arKey case key
 @param progress 下载进度block
 @param complete 下载完成block
 */
- (void)downloadARCase:(NSString *)arKey
    downLoadProgress:(BARDownloadARCaseProgressBlock)progress
            complete:(BARDownloadARCaseCompleteBlock)complete;


- (void)cancelDownLoadArCase;

/**
 启动AR
 */
- (void)startAR;

/**
 停止AR
 */
- (void)stopAR;


/**
 暂停AR
 */
- (void)pauseAR;

/**
 恢复AR
 */
- (void)resumeAR;

/**
 @param sampleBuffer 相机数据
 @return bgra数据
 */
- (void)updateSampleBuffer:(CMSampleBufferRef)sampleBuffer;

/**
 手势相关
 */
- (void)onViewGesture:(UIGestureRecognizer *)gesture;
- (void)touchesBegan:(CGPoint)point scale:(CGFloat)scale;
- (void)touchesMoved:(CGPoint)point scale:(CGFloat)scale;
- (void)touchesEnded:(CGPoint)point scale:(CGFloat)scale;
- (void)touchesCancelled:(CGPoint)point scale:(CGFloat)scale;

- (void)switchFilter:(int)filterId type:(int)type;
- (void)takePicture:(BARTakePictureFinishBlock)finishBlock;
- (void)destroyCaseForSameSearch:(dispatch_block_t)destroyFinish;
- (void)destroyCase;

+ (NSString *)arSDKVersion;

- (void)setDevicePosition:(int)position;
- (void)setTargetView:(BARImageView *)targetView ;
- (void)setBAROutputType:(BAROutput)type;

@end
