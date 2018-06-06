//
//  BARVideoCameraProtocol.h
//  ARSDK
//
//  Created by lusnaow on 07/12/2017.
//  Copyright © 2017 Baidu. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>

#ifndef BARVideoCameraProtocol_h
#define BARVideoCameraProtocol_h

//相机采集的回调
typedef void (^BARCameraCaptureOutputBlock)(CMSampleBufferRef sampleBuffer);

//对接外部GPUImageCamera的协议
@protocol BARVideoCameraDelegate <NSObject>

@required
- (void)startCaptureWithOutputBlock:(BARCameraCaptureOutputBlock)block;
- (void)stopCapture;
- (void)pauseCapture;
- (void)resumeCapture;
- (AVCaptureSession*)getCaptureSesstion;
- (float)getCaptureFrameRate;

//如果外部自定义的相机不需要闪光灯相关的功能，可以不实现以下函数
@optional
- (BOOL)hasTorch;
- (BOOL)isTorchOn;
- (void)turnTorchOn;
- (void)turnTorchOff;
@end


#endif /* BARVideoCameraProtocol_h */
