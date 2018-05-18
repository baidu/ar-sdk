//
//  BARRouter.h
//  BARRouter
//
//  Created by Asa on 2017/11/1.
//  Copyright © 2017年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 README
 支持的参数、返回值类型：
             基础类型：int、float……
             系统结构体类型：CGPoint、CGRect……
             id类型：NSNumber、NSString……
 */

@interface BARRouter : NSObject

+ (instancetype)sharedInstance;

/**
 跨组件调用

 @param targetName 组件名：由组件开发者在router类别中定义，参考BARRouter+BARTTS.m
 @param actionName 函数名：比如：setWith:and:
 @param arguments 参数数组
 @param shouldCacheTarget 是否缓存target
 @return 返回值.取决于传入函数的返回值
 */
- (id)performTarget:(NSString *)targetName action:(NSString *)actionName arguments:(NSArray *)arguments shouldCacheTarget:(BOOL)shouldCacheTarget;

/**
 释放缓存的target

 @param targetName target name
 */
- (void)releaseCachedTargetWithTargetName:(NSString *)targetName;

@end
