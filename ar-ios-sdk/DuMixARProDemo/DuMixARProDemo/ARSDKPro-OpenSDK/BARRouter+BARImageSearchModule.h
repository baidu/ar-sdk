//
//  BARRouter+BARImageSearchModule.h
//  ARSDK-Pro
//
//  Created by Asa on 2017/12/6.
//  Copyright © 2017年 Baidu. All rights reserved.
//

#import "BARRouter.h"

@interface BARRouter (BARImageSearchModule)

NS_ASSUME_NONNULL_BEGIN

- (id)imageSearch_initWithARType:(NSInteger)type;
- (void)imageSearch_switchARType:(NSInteger)type withCaller:(id)caller;
- (void)imageSearch_loadSameSearchWithCaller:(id)caller;
- (void)imageSearch_setBufferFrame:(id)sampleBuffer withCaller:(id)caller;
- (void)imageSearch_setResultBlock:(nullable void (^)(id result))block withCaller:(id)caller;
- (void)imageSearch_setErrorBlock:(nullable void (^)(NSError *error))block withCaller:(id)caller;
- (void)imageSearch_startImageSearchWithCaller:(id)caller;
- (void)imageSearch_stopImageSearchWithCaller:(id)caller;

NS_ASSUME_NONNULL_END

@end

