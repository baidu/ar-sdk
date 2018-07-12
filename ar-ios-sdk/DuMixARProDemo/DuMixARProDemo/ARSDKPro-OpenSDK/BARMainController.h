//
//  BARMainController.h
//  AR-Base
//
//  Created by Asa on 2017/10/19.
//  Copyright © 2017年 Baidu. All rights reserved.
//

#if !TARGET_OS_SIMULATOR

#import <Foundation/Foundation.h>
#import "BARSDKPro.h"
#import "BARSDKObj.h"
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import "BARImageView.h"
#import "BARMessageType.h"

typedef enum : NSUInteger {
    BAROutputBlend = 0,
    BAROutputVideo,
    BAROutputEngine,
} BAROutput;


@protocol AREngineScriptPreferenceDelegate;

#pragma mark - Block

/**
 Case包下载进度回调

 @param progress 进度值
 */
typedef void (^BARDownloadARCaseProgressBlock)(float progress);

/**
 Case资源包下载完成回调

 @param success YES：成功 NO：失败
 @param arKey case arkey
 @param arType case artype
 @param filePath case本地路径
 @param result 结果
 */
typedef void (^BARDownloadARCaseCompleteBlock)(BOOL success,NSString * arKey,NSString * arType,NSString * filePath, id result);

/**
 拍摄回调

 @param image 拍摄的照片
 */
typedef void (^BARTakePictureFinishBlock)(UIImage *image);


typedef void (^BARShowAlertEventBlock)(BARSDKShowAlertType type,dispatch_block_t cancelBlock,dispatch_block_t ensureBlock,NSMutableDictionary *info);


typedef void(^BARLuaMsgBlock)(BARMessageType msgType, NSDictionary *dic);

@interface BARMainController : NSObject

@property (nonatomic, copy) BARSDKUIStateEventBlock uiStateChangeBlock;
@property (nonatomic, copy) BARLuaMsgBlock luaMsgBlock;
@property (nonatomic ,copy) BARShowAlertEventBlock showAlertEventBlock;

@property (nonatomic,assign,readonly) BOOL frontCamera;

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



/**
 取消下载AR资源包
 */
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
 @return bgra 数据
 */
- (void)updateSampleBuffer:(CMSampleBufferRef)sampleBuffer;

/**
 *  设置是否是前置摄像头
 */

- (void) changeToFrontCamera:(BOOL) front;

/**
 手势相关
 */
- (void)onViewGesture:(UIGestureRecognizer *)gesture;
- (void)touchesBegan:(CGPoint)point scale:(CGFloat)scale;
- (void)touchesMoved:(CGPoint)point scale:(CGFloat)scale;
- (void)touchesEnded:(CGPoint)point scale:(CGFloat)scale;
- (void)touchesCancelled:(CGPoint)point scale:(CGFloat)scale;

- (void)switchFilter:(int)filterId type:(int)type;

/**
 拍照

 @param finishBlock 拍照回调
 */
- (void)takePicture:(BARTakePictureFinishBlock)finishBlock;

/**
 销毁当前已经加载的case，重新调起识图

 @param destroyFinish 销毁case后的回调
 */
- (void)destroyCaseForSameSearch:(dispatch_block_t)destroyFinish;


/**
 销毁当前已经加载的case，重新调起识图
 
 @param destroyFinish 销毁case后的回调
 */
- (void)destroyCase:(dispatch_block_t)destroyFinish;

/**
 销毁case
 */
- (void)destroyCase;


/**
 ARSDK版本

 @return 当前ARSDK版本号
 */
+ (NSString *)arSDKVersion;


/**
 设置设备姿态

 @param position 设备姿态
 */
- (void)setDevicePosition:(int)position;

/**
 设置render容器

 @param targetView 目标view
 */
- (void)setTargetView:(BARImageView *)targetView ;


/**
 设置AR输出格式

 @param type
        BAROutputBlend ,
        BAROutputVideo,
        BAROutputEngine,
 */
- (void)setBAROutputType:(BAROutput)type;


/**
 设置相机size、预览size数据

 @param cameraSize 相机尺寸
 @param previewSize 预览尺寸
 */
- (void)setArCameraSize:(CGSize)cameraSize previewSize:(CGSize)previewSize;

/**
 向lua发送消息(新方式)

 @param eventName 消息名
 @param eventData 消息内容
 @discussion lua中通过注册监听，获得消息Event:addEventListener("session_find_anchor", find_anchor)
 */
- (void)sendMsgToLua:(NSString *)eventName eventData:(NSDictionary *)eventData;


/**
 向lua发送消息(旧方式)

 @param mapData 消息体
 */
- (void)sendMsgToLuaWithMapData:(NSDictionary *)mapData;

/**
 取消分布加载下载
 */
- (void)cancelDownloadBatchZip;

/**
 继续分布加载下载
 */
- (void)retryDownloadBatchZip;

@end

#endif
