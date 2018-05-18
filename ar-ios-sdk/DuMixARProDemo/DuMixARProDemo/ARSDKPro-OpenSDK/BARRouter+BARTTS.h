//
//  BARRouter+BARTTS.h
//  ARSDK
//
//  Created by Asa on 2017/11/1.
//  Copyright © 2017年 Baidu. All rights reserved.
//

#import "BARRouter.h"

/*
 路由类别-TTS
 */
@interface BARRouter (BARTTS)

- (void)setUpTTS;
- (void)pauseTTS;
- (void)resumeTTS;
- (void)cancelTTS;
- (void)cleanUpTTS;
- (void)setTTSApiKey:(NSString *)apiKey withSecretKey:(NSString *)secretKey withAppID:(NSString *)appID;

@end
