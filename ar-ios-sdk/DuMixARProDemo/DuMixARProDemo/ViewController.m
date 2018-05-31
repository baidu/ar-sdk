//
//  ViewController.m
//  DuMixARProDemo
//
//  Created by Asa on 2018/3/29.
//  Copyright © 2018年 JIA CHUANSHENG. All rights reserved.
//

#import "ViewController.h"
#import "BARBusinessDemoViewController.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)showAR:(id)sender {
#if defined (__arm64__)
    BARBusinessDemoViewController *arVC = [[BARBusinessDemoViewController alloc] init];
    arVC.isLandscape = NO;
    [self presentViewController:arVC animated:NO completion:^{
        
    }];
#endif
}

@end
