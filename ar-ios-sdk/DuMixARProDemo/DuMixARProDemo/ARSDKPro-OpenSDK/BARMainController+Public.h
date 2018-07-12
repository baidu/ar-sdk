//
//  BARMainController+Public.h
//  AR-Base
//
//  Created by Asa on 2018/3/28.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#if !TARGET_OS_SIMULATOR

#import "BARMainController.h"
#import "BARImageMovieWriter.h"

//ARType：
/*
  kBARTypeLocalSameSearch || kBARTypeCloudSameSearch - - - Do same searching by yourself
  kBARTypeARKit == arType - - - Currently not supported
  Other - - -Call startAR
 */
typedef void(^BARLoadSuccessBlock)(NSString *arKey, kBARType arType);
typedef void(^BARLoadFailedBlock)(void);

@interface BARMainController (Public)

/**
 从网络加载AR

 @param arKey ARKey
 @param successBlock 加载成功回调
 @param failureBlock 加载失败回调
 */
- (void)loadAR:(NSString *)arKey success:(BARLoadSuccessBlock)successBlock
 failure:(BARLoadFailedBlock)failureBlock;


/**
 从本地路径加载AR

 @param filePath case资源包路径,下载并解压完后的路径：比如 ../bar_10070173/ar/...，传递的参数filePath为../bar_10070173
 @param arType case对应的artype
 @param successBlock 加载成功回调
 @param failureBlock 加载失败回调：case包有问题或者鉴权失败
 */
- (void)loadARFromFilePath:(NSString *)filePath arType:(NSString *)arType success:(BARLoadSuccessBlock)successBlock failure:(BARLoadFailedBlock)failureBlock;

/**
 录制视频时，需要设置movieWriter

 @param movieWriter 视频录制
 */
- (void)setRenderMovieWriter:(BARImageMovieWriter *)movieWriter;

- (kBARType)arTypeFromServer:(NSString *)arType;


@end

#endif
