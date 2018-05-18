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
- (void)updateSampleBuffer:(CMSampleBufferRef)srcBuffer;
- (void)updateAudioSampleBuffer:(CMSampleBufferRef)srcBuffer;
- (void)onViewGesture:(UIGestureRecognizer *)gesture;
- (void)touchesBegan:(CGPoint)point scale:(CGFloat)scale;
- (void)touchesMoved:(CGPoint)point scale:(CGFloat)scale;
- (void)touchesEnded:(CGPoint)point scale:(CGFloat)scale;
- (void)touchesCancelled:(CGPoint)point scale:(CGFloat)scale;
@end

@interface BARRenderViewController : UIViewController
@property (nonatomic, assign) CGRect frame;
@property (nonatomic, weak) id<BARRenderViewControllerDataSource> dataSource;
@property (strong, nonatomic)  UIView *cameraPreview;
@property (strong, nonatomic)  UIView *arContentView;
@property (nonatomic, assign) CGSize previewSizeInPixels;
@property (nonatomic, assign) CGSize cameraSize;
@property (nonatomic, assign) CGFloat aspect;
@property (nonatomic, strong) BARGestureImageView *videoPreviewView;
@property (nonatomic, assign) BOOL isLandscape;

- (void)changeToSystemCamera;
- (void)changeToARCamera;
- (void)rotateCamera;
- (int)devicePosition;
- (void)stopCapture;
@end
