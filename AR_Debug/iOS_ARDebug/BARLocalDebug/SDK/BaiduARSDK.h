//
//  BaiduARSDK.h
//  BaiduARSDK
//
//  Created by LiuQi on 15/6/15.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BARViewController.h"
#import "BARSDKDelegate.h"

// @class - BaiduARSDK
// @brief - 百度AR SDK

typedef enum {
    kBARTypeUnkonw = -1,
    kBARTypeTracking = 0,
    kBARTypeSlam = 5,
    kBARTypeLocalSameSearch = 6,
    kBARTypeCloudSameSearch = 7,
    kBARTypeIMU = 8
} kBARType;

#define BARNSLocalizedString(key) [BaiduARSDK getBARLocalString:key]

@interface BaiduARSDK : NSObject

/**
 * 设置用户的 appid, apikey, secretKey;
 */
+ (void)setAppID:(NSString *)appId
          APIKey:(NSString *)apiKey
     andSecretKey:(NSString *)secretKey;

/**
 * 获取AR 视图
 */
+ (BARViewController*)viewController:(NSString*)arValue arInfo:(NSDictionary *)arInfo;

/**
 * 清空SDK 缓存
 */
+ (void)cleanCache;

/**
 * 获取SDK 缓存大小
 * @return byte
 */
+ (unsigned long)cacheSize;

/**
 * 设置资源路径,默认为BaiduAR.bundle
 */
+ (void)setBundlePath:(NSString*)path;

/**
 * 设置 SDK 代理
 */
+ (void)setSDKDelegate:(id<BARSDKDelegate>)delegate;

+ (void)setUseCustomView:(BOOL)param;

+ (void)setARPublishID:(NSString *)publishID
             accessKey:(NSString *)accessKey;

+ (void)setAipAppID:(NSString*)aipAppID;

+ (NSString *)arDeviceInfo:(NSString *)arValue;
+ (NSString *)getResPath:(NSString *)fileName;
+ (NSString *)getBARLocalString:(NSString *)key;
+ (NSString *)getDeviceName;

+ (NSString *)opensdkSign:(NSString *)timestamp;
+ (NSString *)opensdkPublishID;
+ (NSString *)opensdkTimeStamp;
+ (NSString *)opensdkAipAppID;

+ (UIDeviceOrientation)currentOrientation;

+ (BOOL)isMonkeyMode;
+ (BOOL)isOpenSDK;
+ (BOOL)isSupportAR;
+ (void)arQAMode:(BOOL)qamode;

@end
