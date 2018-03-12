//
//  BARConfig.h
//  ARSDK
//
//  Created by LiuQi on 15/8/18.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BARSDKDelegate.h"

typedef enum {
    BAREnvRDLocal,
    BAREnvQA,
    BAREnvInternet
}BAREnv;

@interface BARConfig : NSObject

// 类方法
+ (BARConfig *)sharedInstance;

@property (nonatomic,copy) NSString* engineVersion;
@property (nonatomic,copy) NSString* trackServer;
@property (nonatomic,copy) NSString* serverApi;
@property (nonatomic,copy) NSString* shareServer;
@property (nonatomic,copy) NSString* bundlePath;
@property (nonatomic,copy) NSString* appId;
@property (nonatomic,weak) id<BARSDKDelegate> sdkDelegate;
@property (nonatomic,copy) NSString* arValue;
@property (nonatomic,copy) NSString* arID;
@property (nonatomic, assign) NSTimeInterval startTime;
@property (nonatomic, copy) NSString* scanCenterImageName;
@property (nonatomic, copy) NSString* scanImageName;
@property (nonatomic, assign) NSInteger arType;
@property (nonatomic, assign) BOOL useAsShell;
@property (nonatomic, assign) BOOL monkeyMode;
@property (nonatomic, copy) NSString* resPath;
@property (nonatomic, copy) NSString* arUnsupportURL;   //不支持AR时跳转的URL
@property (nonatomic, assign) NSInteger launchMode; //0：从拍照的多主题，1:手机百度浏览器调起， 2:AR垂类识别   3:案例展示（全量） 4:案例推荐（筛选之后的） 5:帮助
@property (nonatomic, strong) UIImage *launchImage;
@property (nonatomic, assign) BOOL saveArLastPriview;
// 获取资源路径
- (NSString*)getResPath:(NSString*)filename;
// 请求中需要携带的公共参数
- (NSDictionary *)composeCommonServerParameter;
- (NSString*)getSystemInfo;
- (NSString*)getIdentifier;
- (NSString*)getSystemVersion;
- (NSString*)getPlatform;
- (NSString*)getCommonARValue;
- (void)setEnv:(BAREnv)env;
- (NSDictionary *)getPrizeUserInfoDic;
- (void)reloadConfig;

- (void)clearInfo;

- (NSString *)arDeviceInfo:(NSString *)arValue;

@end
