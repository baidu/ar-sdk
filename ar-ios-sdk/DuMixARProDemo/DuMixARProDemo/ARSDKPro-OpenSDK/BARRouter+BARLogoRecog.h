//
//  BARRouter+BARLogoRecog.h
//  ARSDK
//
//  Created by Zhao,Xiangkai on 2018/1/17.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import "BARRouter.h"

@interface BARRouter (BARLogoRecog)

- (id)logo_init;
- (void)logo_setLogoRecogErrorBlock:(void(^)(NSError *error))block withCaller:(id)caller;
- (void)logo_startLogoRecog:(BOOL)start withCaller:(id)caller;
- (void)logo_updateSampleBuffer:(id)sampleBuffer withCaller:(id)caller;
- (void)logo_cleanUpWithCaller:(id)caller;
- (void)logo_setLogoIsRecognizing:(BOOL)isRecognizing caller:(id)caller;

@end
