//
//  BARVideoRecorder.h
//  ARSDK
//
//  Created by lusnaow on 30/11/2017.
//  Copyright © 2017 Baidu. All rights reserved.
//

#if !TARGET_OS_SIMULATOR

#import <Foundation/Foundation.h>
#import "BARImageVideoCamera.h"

//录像参数设置，任何一项都有默认值
@interface BARVideoRecorderSettings : NSObject
@property (nonatomic, copy) NSString *videoPath;
@property (nonatomic, assign) CGSize videoSize;
@property (nonatomic, copy) NSDictionary *outputSettings;
@property (nonatomic, assign) float videoFrameRate;//每秒帧率
@property (nonatomic, assign) float videoBitRate;//压缩码率
@end

@interface BARVideoRecorder : NSObject
@property (nonatomic, strong) BARImageMovieWriter *movieWriter;
@property (nonatomic, assign) CGFloat videoDuration;
@property (nonatomic, assign) BOOL isRecording;
@property (nonatomic, assign) BOOL enbaleAudioTrack;

//建议使用此方法初始化
- (instancetype)initWithVideoCamera:(BARImageVideoCamera*)videoCamera
                           settings:(BARVideoRecorderSettings*)settings;
//采用默认的录制路径及video尺寸和编码
- (instancetype)initWithVideoCamera:(BARImageVideoCamera*)videoCamera;
- (instancetype)initVideoRecorder;

- (void)updateWriterWithAudioTrack:(BOOL)enable;
- (void)startRecordingWithAudioTrack:(BOOL)enable;
- (void)stopRecording:(void (^)(void))handler;

- (instancetype)initWithCamera:(id)camera;
@end

#endif
