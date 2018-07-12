//
//  BARCaseTask.h
//  ARSDK
//
//  Created by liubo on 31/08/2017.
//  Copyright © 2017 Baidu. All rights reserved.
//

#if !TARGET_OS_SIMULATOR

#define BARCASTTASKBEGINTODOWNLOADZIP       @"BARCASTTASKBEGINTODOWNLOADZIP"

#import <Foundation/Foundation.h>

@class BARCaseTask;
@protocol BARCaseTaskDelegate
@optional

- (void)caseTask:(BARCaseTask *)task downloadProgress:(float)downloadProgress;
- (void)caseTask:(BARCaseTask *)task taskResult:(NSDictionary *)taskResult error:(NSError *)error;
- (void)caseTaskQueryArResourceSuccess:(BARCaseTask *)task;
- (void)caseTaskDealloc:(BARCaseTask *)task;
@end

@interface BARCaseTask : NSOperation

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithDelegateQueue:(dispatch_queue_t)delegateQueue;

- (void) addDelegate:(id<BARCaseTaskDelegate>) delegate;
- (void) removeDelegate:(id<BARCaseTaskDelegate>) delegate;

@property (nonatomic, copy) NSString *arkey;

@end

#endif
