//
//  BARRouter+BARVoice.h
//  AR-Voice-Router
//
//  Created by yijieYan on 2017/11/8.
//  Copyright © 2017年 Baidu. All rights reserved.
//

#import "BARRouter.h"

typedef void(^BARVoiceConfigureVoiceStartBlock)(BOOL success);
typedef void(^BARVoiceConfigureVoiceStopBlock)(void);

@interface BARRouter (BARVoice)

- (id)voice_createVoiceConfigure;
- (void)voice_setStartBlock:(BARVoiceConfigureVoiceStartBlock)startBlock withConfigure:(id)configure;

- (void)voice_setStopBlock:(BARVoiceConfigureVoiceStopBlock)block withConfigure:(id)configure;
- (void)voice_setUpWithConfigure:(id)configure;
- (void)voice_cleanUpWithConfigure:(id)configure;
- (void)voice_stopVoiceWithConfigure:(id)configure;
- (void)voice_startVoiceWithConfigure:(id)configure;
//- (void)voice_setLandscapeMode:(UIDeviceOrientation)oriation withConfigure:(id)configure;
- (void)voice_setShoudlPenddingStart:(BOOL)shouldPendding withConfig:(id)configure;
- (BOOL)voice_getHitcommndStartWithConfigure:(id)configure;
- (NSInteger)voice_getPeddingStartCountWithConfigure:(id)configure;
- (void)voice_setPeddingStartCount:(NSInteger)count WithConfigure:(id)configure;
- (BOOL)voice_getIsVoiceReStartWithConfigure:(id)configure;
- (BOOL)voice_getIsVoiceStopedWithConfigure:(id)configure;

- (void)voice_setApiKey:(NSString *)apiKey withSecretKey:(NSString *)secretKey withAppID:(NSString *)appid;
//- (void)voice_setIsRecording:(BOOL)isRecording withConfigure:(id)configure;
- (void)voice_setStatusBlock:(void (^)(int, id))block withConfigure:(id)configure;

@end
