//
//  BARPro.h
//  AR-Base
//
//  Created by liubo on 09/02/2018.
//  Copyright © 2018 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BARSDKDef.h"


@interface BARSDKPro : NSObject

/**
 * 设置用户的 appid, apikey, secretKey;
 */
+ (void)setAppID:(NSString *)appId
          APIKey:(NSString *)apiKey
    andSecretKey:(NSString *)secretKey;
    
/**
 * 清空SDK 缓存
 */
+ (void)cleanCache;

/**
 * 获取SDK 缓存大小
 * @return byte
 */
+ (unsigned long)cacheSize;

+ (NSString *)arDeviceInfo:(NSString *)arValue;
+ (NSString *)getDeviceName;
+ (UIDeviceOrientation)currentOrientation;

+ (BOOL)isOpenSDK;
+ (BOOL)isSupportAR;
+ (NSString *)arSdkVersion;

+ (void)openTimeStatistics:(BOOL)open;
+ (BOOL)isTimeStatisticsOpened;

+ (NSString *)getTimestamp;
+ (NSString *)opensdkSign:(NSString *)timestamp;

+ (NSString*)engineVersion;
+ (NSString*)getIdentifier;
+ (NSString*)getSystemVersion;
+ (NSString*)getPlatform;
+ (NSString *)getVideoPath;

+ (void) resetArID:(NSString *)arID
            arType:(NSString *)arType
           arValue:(NSString *)arValue 
    previewAppInfo:(NSString *)previewAppInfo;

+ (void)useAsShell:(BOOL) use;


@end
