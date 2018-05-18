//
//  BARCaseManager.h
//  ARSDK
//
//  Created by liubo on 31/08/2017.
//  Copyright © 2017 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BARCaseTask.h"

@interface BARCaseManager : NSObject
+ (instancetype) sharedInstance;

- (void)cleanCache;
- (unsigned long)cacheSize;

- (NSString *) targetpath_bararkey:(NSString *)arkey;
- (NSString *) caseExist:(NSString *)arKey version_code:(NSString *)version_code;

@end
