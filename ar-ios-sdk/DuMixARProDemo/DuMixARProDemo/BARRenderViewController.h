//
//  BARRenderViewController.h
//  ARAPP-Pro
//
//  Created by Asa on 2017/10/23.
//  Copyright © 2017年 Asa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "BARGestureImageView.h"

@protocol BARRenderViewControllerDataSource<NSObject>
@optional

/**
 将相机流数据传给MainController，进行渲染处理

 @param srcBuffer 相机流原始数据
 */
- (void)updateSampleBuffer:(CMSampleBufferRef)srcBuffer;

/**
 录制视频时，将音频数据传给BARVideoRecorder

 @param srcBuffer 音频数据
 */
- (void)updateAudioSampleBuffer:(CMSampleBufferRef)srcBuffer;

/**
 手势相关

 @param gesture 手势
 */
- (void)onViewGesture:(UIGestureRecognizer *)gesture;
- (void)touchesBegan:(CGPoint)point scale:(CGFloat)scale;
- (void)touchesMoved:(CGPoint)point scale:(CGFloat)scale;
- (void)touchesEnded:(CGPoint)point scale:(CGFloat)scale;
- (void)touchesCancelled:(CGPoint)point scale:(CGFloat)scale;
@end

@interface BARRenderViewController : UIViewController

@property (nonatomic, assign) CGRect frame;
@property (nonatomic, weak) id<BARRenderViewControllerDataSource> dataSource;
@property (strong, nonatomic)  UIView *arContentView;//AR视图容器
@property (nonatomic, assign) CGSize previewSizeInPixels;//预览尺寸
@property (nonatomic, assign) CGSize cameraSize;//相机尺寸
@property (nonatomic, assign) CGFloat aspect;//屏占比
@property (nonatomic, strong) BARGestureImageView *videoPreviewView;//AR渲染view
@property (nonatomic, assign) BOOL isLandscape;//是否横屏

/**
 切换到系统相机
 */
- (void)changeToSystemCamera;

/**
 切换到AR相机
 */
- (void)changeToARCamera;

/**
 切换前后摄像头
 */
- (void)rotateCamera;


/**
 相机当前位置

 @return 0:后置 1：前置
 */
- (int)devicePosition;

/**
 停止相机
 */
- (void)stopCapture;

@end
