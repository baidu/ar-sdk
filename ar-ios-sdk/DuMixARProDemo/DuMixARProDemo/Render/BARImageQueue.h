//
//  BARImageQueue.h
//  BARImage
//
//  Created by yuxin on 2017/10/22.
//  Copyright © 2017年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BARImageContext;

void runWithoutDeadlockingOnMainQueue(void (^block)(void));
void runSynOnVideoProcessingQueue(void (^block)(void));
void runAsynOnVideoProcessingQueue(void (^block)(void));
void runSynOnContextQueue(BARImageContext *context, void (^block)(void));
void runAsynOnContextQueue(BARImageContext *context, void (^block)(void));

@interface BARImageQueue : NSObject

+ (void)runSynOnVideoProcessingQueue:(void (^)(void)) block;
+ (void)runAsynOnVideoProcessingQueue:(void (^)(void)) block;
+ (void)runSynOnContextQueue:(BARImageContext *) context block:(void (^)(void)) theBock;
+ (void)runAsynOnContextQueue:(BARImageContext *) context block:(void (^)(void)) theBock;

@end
