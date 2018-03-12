//
//  BARViewController+Login.h
//  ARSDK
//
//  Created by yijieYan on 16/9/21.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BARViewController.h"

@interface BARViewController(Login)

@property (nonatomic, copy) dispatch_block_t showLoginViewEventBlock;
- (void)loginFinish;
- (void)loginCancel;
@end
