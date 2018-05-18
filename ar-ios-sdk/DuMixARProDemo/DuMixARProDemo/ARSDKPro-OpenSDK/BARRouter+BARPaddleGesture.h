//
//  BARRouter+BARPaddleGesture.h
//  AR-PaddleGesture-Router
//
//  Created by liubo on 12/01/2018.
//  Copyright © 2018 Baidu. All rights reserved.
//

#import "BARRouter.h"
#import <CoreMedia/CoreMedia.h>

@interface BARRouter (BARPaddleGesture)

- (id) paddleGesture_allocInit;

- (BOOL) paddleGesture:(id) paddeleGesture loadGestureModel:(NSString *)filePath;
- (void) paddleGesture:(id) paddeleGesture cameraWillOutputSampleBuffer:(CMSampleBufferRef) sampleBuffer;
- (void) paddleGesture:(id) paddeleGesture releaseGestureModel:(id) ext;

@end


@interface BARCMSampleBufferRefObject: NSObject
- (instancetype) initWithCMSampleBufferRef:(CMSampleBufferRef) sampleBufferRef;
@property (nonatomic, assign)CMSampleBufferRef sampleBufferRef;
@end

