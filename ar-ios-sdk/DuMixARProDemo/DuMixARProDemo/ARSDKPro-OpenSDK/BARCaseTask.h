//
//  BARCaseTask.h
//  ARSDK
//
//  Created by liubo on 31/08/2017.
//  Copyright © 2017 Baidu. All rights reserved.
//

#define BARCASTTASKBEGINTODOWNLOADZIP       @"BARCASTTASKBEGINTODOWNLOADZIP"

#import <Foundation/Foundation.h>
@class BARCaseTask;
@protocol BARCaseTaskDelegate
@optional

- (void)caseTask:(BARCaseTask *)task downloadProgress:(float)downloadProgress;
- (void)caseTask:(BARCaseTask *)task taskResult:(NSDictionary *)taskResult error:(NSError *)error;
- (void)caseTaskQueryArResourceSuccess:(BARCaseTask *)task;
- (void)caseTaskDealloc:(BARCaseTask *)task;

//- (void)caseTask:(BARCaseTask *)task queryResult:(NSDictionary *)queryResult error:(NSError *)error;
//- (void)caseTask:(BARCaseTask *)task downloadPath:(NSString *)downladPath error:(NSError *)error;
//- (void)caseTask:(BARCaseTask *)task unzipPath:(NSString *) unzipPath error:(NSError *)error;
@end

@interface BARCaseTask : NSOperation

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithDelegateQueue:(dispatch_queue_t)delegateQueue;

- (void) addDelegate:(id<BARCaseTaskDelegate>) delegate;
- (void) removeDelegate:(id<BARCaseTaskDelegate>) delegate;

@property (nonatomic, copy) NSString *arkey;

@end
