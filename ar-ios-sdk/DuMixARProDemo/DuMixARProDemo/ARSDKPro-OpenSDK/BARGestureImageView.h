//
//  BARDemoRenderView.h
//  ARAPP-Pro
//
//  Created by yijieYan on 2017/10/24.
//  Copyright © 2017年 Asa. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BARImageQueue.h"
#import "BARImageContext.h"
#import "BARImageOutput.h"
#import "BARImageView.h"
#import "BARImageVideoCamera.h"
#import "BARImagePicture.h"
#import "BARImageMovieWriter.h"
#import "BARImageFilterGroup.h"
#import "BARImageFramebuffer.h"
#import "BARImageFramebufferCache.h"

@protocol BARGestureImageViewDelegate <NSObject>
- (void)onViewGesture:(UIGestureRecognizer *)gesture;
- (void)touchesBegan:(CGPoint)point scale:(CGFloat)scale;
- (void)touchesMoved:(CGPoint)point scale:(CGFloat)scale;
- (void)touchesEnded:(CGPoint)point scale:(CGFloat)scale;
- (void)touchesCancelled:(CGPoint)point scale:(CGFloat)scale;
@end

@interface BARGestureImageView : BARImageView

@property (nonatomic, weak) id<BARGestureImageViewDelegate> gesturedelegate;

@end
