//
//  BARSDKDelegate.h
//  ARSDK
//
//  Created by LiuQi on 15/8/24.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import <UIKIt/UIKIt.h>


@protocol BARSDKDelegate <NSObject>

@optional

// 对外统计接口
- (void)addUserStatisticsForThirdPartyWithPCode:(NSString *)pCode detailedID:(NSString *)detailedID userInfo:(NSString *)userinfo;

- (BOOL)isUserLoggedin;

- (NSString *)getUserBduss;


@end
